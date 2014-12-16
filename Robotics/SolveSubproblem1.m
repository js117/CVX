% Solves exp(twist_hat*t1)*p = q, for t1
% Required: r, a point on the twist axis
% twists are 6-d vectors, p,q,r are 4-d (3-d + 1 at end)
function t1 = SolveSubproblem1(twist, p, q, r)

    tol = 1e-18;
    w = twist(4:6);
    u = p(1:3) - r(1:3);
    v = q(1:3) - r(1:3);
    
%     check1 = norm(w'*u - w'*v);
%     if (check1 > tol)
%        %disp('Failed subproblem1, check1=');
%        %disp(num2str(check1));
%        t1 = -10; % something that won't make sense
%        return;
%     end
    
    u_prime = u - w*(w'*u);
    v_prime = v - w*(w'*v);
    
%     check2 = abs(norm(u_prime)-norm(v_prime));
%     if (check2 > tol)
%         %disp('Failed subproblem1, check2=');
%         %disp(num2str(check2));
%         t1 = -10;
%         return;
%     end
    
    t1 = atan2(w'*cross(u_prime, v_prime), u_prime'*v_prime);
    
end