% A primer on function handles: to explain our input arguments
%f1=@(x) (x^2); 
%f2=@(x) (x^3);
%f3=@(x) (x^4);
%fi = cell(3,1);
%fi{1} = f1; fi{2} = f2; fi{3} = f3;
%fi{1}(5)
%ans =
%    25
 
% Given a convex feasibility problem, find x0 that is feasible
% Returns an error vector e, e(j) = fi{j}(x0) - s(j)
% where positive errors e(j) indicate a constraint not being satisfied.

function [p_star, x_star, lam_star, nu_star] = PrimalDual(x0, m, f0, fi, A, b, grad_f0, grad_fi, hess_fi)
    
    x = x0;
    

end