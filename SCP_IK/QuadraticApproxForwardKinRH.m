% Generate a quadratic approximation of the forward kinematics of the right
% hand, in the trust region, with Xcurrent (at time T) as the center
function [P,q,r, residuals, Y, Z] = QuadraticApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT)
    n = size(TrustRegionMin,1);
    Z = GenerateRandomX(TrustRegionMin, TrustRegionMax, numParticles);
    m = 6; % Problem specific to the ForwardKinRH function
    Y = zeros(m,numParticles);
    for i=1:numParticles
        Y(:,i) = ForwardKinRH(Z(:,i));
    end

    cvx_begin
        variable P1(n,n)
        variable q1(n)
        variable r1
        f = 0;
        for i=1:numParticles
           f = f + ((Z(:,i)-XcurrentAtT)'*P1*(Z(:,i)-XcurrentAtT) + q1'*(Z(:,i)-XcurrentAtT) + r1 - Y(1,i)).^2; % messing w/ small numbers
        end
        
        minimize f 
        subject to 
            P1 == semidefinite(n,n);
        
    cvx_end
    
    P = P1;
    q = q1;
    r = r1;
    residuals = cvx_optval;
    
    figure;plot(Y(1,:));
    test = zeros(numParticles,1);
    for i=1:numParticles
       test(i) = (Z(:,i))'*P1*(Z(:,i)) + q1'*(Z(:,i)) + r1; 
    end
    figure; plot(test);
end