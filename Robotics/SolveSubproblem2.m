% Solves exp(twist_hat1*t1)*exp(twist_hat2*t2)*p = q, for t1, t2
% Required: r, a point on the twist axis
% Note: returns all possible solutions (two pairs at most)
% twists are 6-d vectors, p,q,r are 4-d (3-d + 1 at end)
function [t11, t21, t12, t22] = SolveSubproblem2(twist1, twist2, p, q, r)

    tol = 1e-6;
    w1 = twist1(4:6);
    w2 = twist2(4:6);
    
    r = r(1:3);
    u = p(1:3) - r;
    v = q(1:3) - r;
    
    % find z, the axis from intersection of w1/w2 to their common point(s)
    % of rotation
    % z = alpha*w1 + beta*w2 + gamma*cross(w1, w2)
    
    alpha = ((w1'*w2)*w2'*u - w1'*v) / ((w1'*w2)^2 - 1);
    
    beta = ((w1'*w2)*w1'*v - w2'*u) / ((w1'*w2)^2 - 1);
    
    % solve for gamma param: 
    temp = (u'*u - alpha*alpha - beta*beta - 2*alpha*beta*(w1'*w2)) / norm(cross(w1,w2))^2;
    
    if (temp < 0)
        temp = 0;
    end
    
%     if (temp < 0)      
%        disp('No real solutions for subproblem2');
%        temp
%        t11 = Inf; t21 = Inf; t12 = Inf; t22 = Inf;
%        return;
%     end
    
    
    gamma = sqrt(temp);
    
    if (gamma < tol) % gamma ~ 0, so single solution
        z = alpha*w1 + beta*w2;
        c = z + r;
        t21 = SolveSubproblem1(twist2, p, c, r);
        t11 = SolveSubproblem1(-twist1, q, c, r);
        
        % copy to second possible solution
        t22 = t21;
        t12 = t11;
        
    else
        z1 = alpha*w1 + beta*w2 + gamma*cross(w1, w2);
        z2 = alpha*w1 + beta*w2 - gamma*cross(w1, w2);
        c1 = z1 + r;
        c2 = z2 + r;
        
        t21 = SolveSubproblem1(twist2, p, c1, r);
        t11 = SolveSubproblem1(-twist1, q, c1, r);
        
        t22 = SolveSubproblem1(twist2, p, c2, r);
        t12 = SolveSubproblem1(-twist1, q, c2, r);       
    end

end