%%%%%%%%%%%% Sequential Convex Optimization for Inverse Motion Control %%%%%%%%%%%%%
%
% Tuned for the Nao humanoid robot http://en.wikipedia.org/wiki/Nao_%28robot%29
% Enter a 6D target pose for the right-arm end effector: (px, py, pz, roll, pitch, yaw)
% Receive a sequence of joint control commands to realize this, while
% minimizing the energy expenditure of the trajectory.

function finalTrajectory = SCP_IK_main(start, target)

PenaltyItrs = 6;
ConvexItrs = 6; 
mu = 10; % initial penalty weighting factor
penaltyScale = 10; % penalty increasing weighting factor
constraintSlackTol = 0.5e-3; % less than half a percent for range [-1,1]
convexResidualTol = 0.125; % will accept this % mean error on convex approx. to subproblems

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
Xmax = [2.0857, 0.3142, 2.0857, 1.5446, 1.8238]';
Xmin = [-2.0857, -1.3265, -2.0857, 0.0349, -1.8238]';
T = 10;
TrustRegionMin = Xmin*0.2;
TrustRegionMax = Xmax*0.2;
Xcurrent = GenerateRandom(TrustRegionMin,TrustRegionMax,T);
Xprevious = Xcurrent;

for i=1:PenaltyItrs
    
   for j=1:ConvexItrs
       % Step 1: convexify problem. In our case, get an approximation to
       % h(x) --> the forward kinematics function @ time T
       % Uses a particle method to generate a quadratic approximation to
       % the function within the trust region.
       [P,q,r, residuals] = QuadraticApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, Xcurrent(:,T));
       
       
       
       
       
       
       
   end
   
   if (TestOriginalProblemConstraints(Xmin,Xmax,T,start,target,X) < constraintSlackTol)
       break;
   else
      mu = k*mu; %increase penalty weighting, re-optimize 
   end
    
end

finalTrajectory = Xcurrent;

end
