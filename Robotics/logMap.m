% form the logMap of E in SE(3). k is the multiplicity for additional
% solutions, e.g. k = 0, 1, -1, 2, -2
function logE = logMap(E, k)
    % E = [R, p; 0, 1]
    % logE = [log(R), inv(A)*p; 0, 0]
    
    R = E(1:3,1:3);
    theta = acos((trace(R)-1)/2) + 2*pi*k;
    w_hat = 1/(2*sin(theta))*(R - R');
    w = deskew(w_hat);
    nw = norm(w);
    
    if (nw ~= 0)
       Ainv = eye(3) - 0.5*theta*w_hat + ((2*sin(nw) - nw*(1+cos(nw)))/(2*nw*nw*sin(nw)))*w_hat*w_hat*theta*theta;
    else
       Ainv = eye(3);
    end
    
    % http://en.wikipedia.org/wiki/User:BenFrantzDale/SE(3)
    %v = eye
    
    logE = zeros(4,4);
    logE(1:3,1:3) = theta*w_hat;
    logE(1:3,4) = Ainv*E(1:3,4);
    
end