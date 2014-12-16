%%%%%%%%%%%% Sequential Convex Optimization for Inverse Motion Control %%%%%%%%%%%%%
%
% Tuned for the Nao humanoid robot http://en.wikipedia.org/wiki/Nao_%28robot%29
% Enter a 6D target pose for the right-arm end effector: (px, py, pz, roll, pitch, yaw)
% Receive a sequence of joint control commands to realize this, while
% minimizing the energy expenditure of the trajectory.

%function finalTrajectory = SCP_IK_main(start, target)
start = [0.2209, 0.2485, 1.4695]';%, 1.5446, 1.0477]'; % joint angles
target = [0.1029, -0.0867, 0.0769, 1.5247, 0.2140, 0.2544]'; % target pose

PenaltyItrs = 20; % TEST3: 10; and numParticles was 20
%ConvexItrs = 20; 
numParticles = 30; % number of particles for creating cvx approxs to nonconvex functions
mu = 10; % initial penalty weighting factor
penaltyScale = 5; % penalty increasing weighting factor
constraintSlackTol = 0.5e-3; % less than half a percent for range [-1,1]
convexResidualTol = 0.12; % will accept this % mean error on convex approx. to subproblems
TRexpandFactor = 1.1;
TRshrinkFactor = 0.5;
MeritGain = 0.1; % if the local approximated optimization problem yields a 10% improvement in actual
% objective, take it.
TRminNormTol = 0.008; % if our trust region becomes this small, done cvx loops

%%%%% PROBLEM STATEMENT %%%%%
% Minimize the energy expenditure, measured by instantaneous changes in
% joint angles, such that our final position is our target position, and
% the joint angles stay within a specified acceptable range for the right
% arm. More specifically,
%
% minimize sum(norm(X(:,t+1)-X(:,t),2))
% subject to
%           ForwardKinRH(X(:,T) = target
%           Xmin <= X(:,t) <= Xmax, t = 1,...,T 
% 
% Where T time slices are used to interpolate the motion. The forward
% kinematics constraint on the end effector target is the nonconvex portion
% of this problem. 
%

%%%%% PROBLEM SPECIFIC VARS %%%%%
% Xmax, Xmin: represent joint angle ranges in radians
% T: number of time steps of our control path
n = 3; % number of joint angles in right arm
m = 6; % number of physical coordinates (x,y,z,roll,pitch,yaw)
Xmax = [2.0857, 0.3142, 2.0857]';%, 1.5446, 1.8238]';
Xmin = [-2.0857, -1.3265, -2.0857]';%, 0.0349, -1.8238]';
T = 10; 
TrustRegionMin = Xmin;
TrustRegionMax = Xmax;
OriginalTRnorm = norm(Xmax - Xmin);
Xcurrent = GenerateRandomX(TrustRegionMin,TrustRegionMax,T); % size is n x T
Xcurrent(:,1) = start;
trueImproveLast = 1e9;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:PenaltyItrs
    
   while 1
       % Step 1: convexify problem. In our case, get an approximation to
       % h(x) --> the forward kinematics function @ time T
       % Uses a particle method to generate a quadratic approximation to
       % the function within the trust region.
       %
       % Because h(x) = FWD(X(:,T)) returns (px,py,pz,roll,pitch,yaw), we
       % will break it up into 6 different equality constraints, and form 6
       % different constraints, h1(x) = target(1), h2(x) = target(2), etc.
       % The resulting function approximations will be: (1,2,3,4,5,6)
       % h1(x) ~ (x-x(k))'*P1*(x-x(k) + q1'*(x-x(k)) + r1, whre x(k) <--> Xcurrent(:,T) == x(T)
       %
       % Final implementation detail: if our cvx approx error is not within
       % a tolerable bound, reduce the trust region here and try again.
       residuals = ones(6,1);
       %[P1,q1,r1, residuals(1)] = QuadraticApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, Xcurrent(:,T), 1);
       %[P2,q2,r2, residuals(2)] = QuadraticApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, Xcurrent(:,T), 2);
       %[P3,q3,r3, residuals(3)] = QuadraticApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, Xcurrent(:,T), 3);
       %[P4,q4,r4, residuals(4)] = QuadraticApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, Xcurrent(:,T), 4);
       %[P5,q5,r5, residuals(5)] = QuadraticApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, Xcurrent(:,T), 5);
       %[P6,q6,r6, residuals(6)] = QuadraticApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, Xcurrent(:,T), 6);
       XcurrentAtT = Xcurrent(:,T);
       [a1,b1,residuals(1)] = AffineApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT, 1);
       [a2,b2,residuals(2)] = AffineApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT, 2);
       [a3,b3,residuals(3)] = AffineApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT, 3);
       [a4,b4,residuals(4)] = AffineApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT, 4);
       [a5,b5,residuals(5)] = AffineApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT, 5);
       [a6,b6,residuals(6)] = AffineApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT, 6);
       meanResiduals = mean(residuals);
       while (meanResiduals > convexResidualTol)
          TrustRegionMin = TrustRegionMin*TRshrinkFactor;
          TrustRegionMax = TrustRegionMax*TRshrinkFactor;
          if (residuals(1) > meanResiduals)
              %[P1,q1,r1, residuals(1)] = QuadraticApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, Xcurrent(:,T), 1);
              [a1,b1,residuals(1)] = AffineApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT, 1);
          end
          if (residuals(2) > meanResiduals)
              %[P2,q2,r2, residuals(2)] = QuadraticApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, Xcurrent(:,T), 2);
              [a2,b2,residuals(2)] = AffineApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT, 2);
          end
          if (residuals(3) > meanResiduals)
              %[P3,q3,r3, residuals(3)] = QuadraticApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, Xcurrent(:,T), 3);
              [a3,b3,residuals(3)] = AffineApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT, 3);
          end
          if (residuals(4) > meanResiduals)
              %[P4,q4,r4, residuals(4)] = QuadraticApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, Xcurrent(:,T), 4);
              [a4,b4,residuals(4)] = AffineApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT, 4);
          end
          if (residuals(5) > meanResiduals)
              %[P5,q5,r5, residuals(5)] = QuadraticApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, Xcurrent(:,T), 5);
              [a5,b5,residuals(5)] = AffineApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT, 5);
          end
          if (residuals(6) > meanResiduals) 
              %[P6,q6,r6, residuals(6)] = QuadraticApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, Xcurrent(:,T), 6);
              [a6,b6,residuals(6)] = AffineApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT, 6);
          end
          meanResiduals = mean(residuals);
          disp('extra convexity loop'); % Consider removing this entire loop
       end
       
       
       % Now we are ready to minimize our approximated penalty function:
       cvx_begin
           variable Xproposed(n,T)
           variable t1(n,T) % inequality constraint slack var
           variable t2(n,T) % inequality constraint slack var
           variable s(m) % equality constraint slack var
           variable s2(n) % equality constraint slack var
           f = 0;
           for k=1:T-1
              f = f + norm(Xproposed(:,k+1)-Xproposed(:,k),2); 
           end
           f = f + mu*(ones(m,1)'*s + ones(n,1)'*s2);
           %f = f + mu*(ones(n,1)'*t1*ones(T,1) + ones(n,1)'*t2*ones(T,1) + ones(m,1)'*s + sqrt(mu)*ones(n,1)'*s2);
           minimize f
           subject to
                 for k=1:T-1
                    Xmin <= Xproposed(:,k) <= Xmax; 
                 end
                 TrustRegionMin <= Xproposed(:,T) - XcurrentAtT <= TrustRegionMax;
%                for k=1:T
%                    t1(:,k) >= 0;
%                    t2(:,k) >= 0;
%                    Xproposed(:,k) - TrustRegionMax <= t1(:,k);
%                    -Xproposed(:,k) + TrustRegionMin <= t2(:,k);
%                end
               % Trying direct affine fit:
               -s(1) <= a1'*(Xproposed(:,T)-XcurrentAtT) + b1 <= s(1);
               -s(2) <= a2'*(Xproposed(:,T)-XcurrentAtT) + b2 <= s(2);
               -s(3) <= a3'*(Xproposed(:,T)-XcurrentAtT) + b3 <= s(3);
               -s(4) <= a4'*(Xproposed(:,T)-XcurrentAtT) + b4 <= s(4);
               -s(5) <= a5'*(Xproposed(:,T)-XcurrentAtT) + b5 <= s(5);
               -s(6) <= a6'*(Xproposed(:,T)-XcurrentAtT) + b6 <= s(6);  
               % Below: use a quasilinear approximation to the quadratic fit
%                -s(1) <= (P1*Xcurrent(:,T)+q1)'*(Xproposed(:,T)-Xcurrent(:,T))+r1 <= s(1);
%                -s(2) <= (P2*Xcurrent(:,T)+q2)'*(Xproposed(:,T)-Xcurrent(:,T))+r2 <= s(2);
%                -s(3) <= (P3*Xcurrent(:,T)+q3)'*(Xproposed(:,T)-Xcurrent(:,T))+r3 <= s(3);
%                -s(4) <= (P4*Xcurrent(:,T)+q4)'*(Xproposed(:,T)-Xcurrent(:,T))+r4 <= s(4);
%                -s(5) <= (P5*Xcurrent(:,T)+q5)'*(Xproposed(:,T)-Xcurrent(:,T))+r5 <= s(5);
%                -s(6) <= (P6*Xcurrent(:,T)+q6)'*(Xproposed(:,T)-Xcurrent(:,T))+r6 <= s(6);
               s >= 0;
               -s2 <= Xproposed(:,1) - start <= s2;
               s2 >= 0;
       cvx_end
       
       % Now compare trueImprove with modelImprove (to decide if we accept
       % Xproposed and increase our trust region)
       modelImprove = ModelPenaltyFunction(n, m, T, t1, t2, s, s2, mu, Xcurrent) - cvx_optval; % predicted decrease, >= 0
       trueImprove = TruePenaltyFunction(Xmin, Xmax, T, start, target, mu, Xcurrent) - TruePenaltyFunction(Xmin, Xmax, T, start, target, mu, Xproposed);
       disp(strcat('Model improve: ',num2str(modelImprove), ' / trueImprove: ',num2str(trueImprove)));
       if (trueImprove >= MeritGain*modelImprove) % accept proposal point, expand trust region
           disp('Acceptable model improve.');
           
           TrustRegionMax = TrustRegionMax*TRexpandFactor;
           TrustRegionMin = TrustRegionMin*TRexpandFactor;
           % Ensure trust regions are still physically feasible:
           for ii=1:n
              if (Xmax(ii) > 0 && TrustRegionMax(ii) > Xmax(ii)) TrustRegionMax(ii) = Xmax(ii); end 
              if (Xmax(ii) < 0 && TrustRegionMax(ii) < Xmax(ii)) TrustRegionMax(ii) = Xmax(ii); end
              if (Xmin(ii) > 0 && TrustRegionMin(ii) > Xmin(ii)) TrustRegionMin(ii) = Xmin(ii); end
              if (Xmin(ii) < 0 && TrustRegionMin(ii) < Xmin(ii)) TrustRegionMin(ii) = Xmin(ii); end
           end
           % Update Xcurrent:
           Xcurrent = Xproposed;
           break;
       else
           disp('Model improve not accepted.');
           TrustRegionMax = TrustRegionMax*TRshrinkFactor;
           TrustRegionMin = TrustRegionMin*TRshrinkFactor;
           disp(TrustRegionMax-TrustRegionMin);
           if (trueImprove > trueImproveLast)
              %disp('True improve better than last, accepting solution');
              Xcurrent = Xproposed;
              trueImproveLast = 1e9;
              TrustRegionMax = Xmax;
              TrustRegionMin = Xmin;
           end
       end    
       trueImproveLast = trueImprove;
       if (norm(TrustRegionMax-TrustRegionMin) < TRminNormTol*OriginalTRnorm)
          break; 
       end
       
   end
   
   if (TestOriginalProblemConstraints(Xmin,Xmax,T,start,target,Xcurrent) < constraintSlackTol)
       break;
   else
      mu = penaltyScale*mu; %increase penalty weighting, re-optimize
      % Re-init trust region size
      TrustRegionMin = Xmin;
      TrustRegionMax = Xmax;
      disp(strcat('Outer iteration number: ',num2str(i), '  mu: ',num2str(mu)));
   end
    
end

finalTrajectory = Xcurrent;

%end
