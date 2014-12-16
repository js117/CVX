% Generate an affine approximation of the forward kinematics of the right
% hand, in the trust region, with Xcurrent (at time T) as the center
% Example usage:
% [a, b, residuals] = AffineApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT);
function [a,b,residual] = AffineApproxForwardKinRH(TrustRegionMin, TrustRegionMax, numParticles, XcurrentAtT, index)
    n = size(TrustRegionMin,1);
    Z = GenerateRandomX(TrustRegionMin, TrustRegionMax, numParticles);
    m = 6; % Problem specific to the ForwardKinRH function
    Y = zeros(m,numParticles);
    for i=1:numParticles
        Y(:,i) = ForwardKinRH_TEST_SIMPLE(Z(:,i));
        %Y(:,i) = [Z(:,i);1].^2;
    end

    cvx_begin quiet
        variable a1(n)
        variable b1
        f = 0;
        for i=1:numParticles
           f = f + abs(a1'*(Z(:,i)-XcurrentAtT) + b1 - Y(index,i));
        end
        
        minimize f 
        
    cvx_end
    
    a = a1;
    b = b1;
    residual = cvx_optval/(max(Y(index,:))-min(Y(index,:)))/numParticles;
    
%     test = zeros(size(Y(index,:)));
%     for i=1:numParticles
%        test(i) = a1'*(Z(:,i)-XcurrentAtT) + b1;
%     end
%     timeAxis = 1:numParticles;
%     figure; plot(timeAxis, Y(index,:), 'b', timeAxis, test, 'r');
%     figure; plot(Y(index,:)-test);
%     errorPercent = norm(Y(index,:)-test,1)/(max(Y(index,:))-min(Y(index,:)))/numParticles;
%     disp(errorPercent);
    
end