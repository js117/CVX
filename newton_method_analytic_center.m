% Newton method for problem instance "analytic center of set of
% inequalities ai'*x <= bi and abs(xi) <= 1"

% algorithm
% given x0 (starting point), TOL, MAXITERS, line search params
% repeat:
%
%   compute function(x)
%   compute gradient(x)
%   compute hessian(x)
%
%   v = -Hess.inv*grad;
%   lambdaSquared = v'*Hess*v;
%   
%   if (lambdaSquared <= 2*TOL) quit
%
%   do line search to compute step size t > 0
%   
%   update: x = x + t*v
%
% end

ALPHA = 0.1;
BETA = 0.5;
MAXITERS = 1000;
NEWTON_DEC_TOL = 0.5e-8;

n = 10;
m = 20;
randn('state',1);
A=randn(m,n);
x = zeros(n,1); %initial point x(0) is 0

% Iterative main loop
for i=1:MAXITERS
   
   val = -sum(log(1-A*x)) - sum(log(1+x)) - sum(log(1-x));
   d = 1./(1-A*x);
   grad = A'*d - 1./(1+x) + 1./(1-x);
   Hess = A'*diag(d.^2)*A + diag((1./(1-x)).^2 - (1./(1+x)).^2);
   v = -Hess\grad; % solve Hess*v = -grad to get v, the Newton step
   lambdaSquared = v'*Hess*v;
   
   if lambdaSquared <= 2*NEWTON_DEC_TOL, break; end;
   
   % NOTE - we do the exact same line search as in grad desc. 
   % 
   fprime = grad'*v;
   t = 1; 
   while ((max(A*(x+t*v)) >= 1) || (max(abs(x+t*v)) >= 1))
      t = BETA*t;
      %disp(strcat('t = ',num2str(t)));
   end;
   % backtracking line search
   % note - DO NOT RESET t = 1! Proceed from a feasible point as found
   % above.
   while ( -sum(log(1-A*(x+t*v))) - sum(log(1-(x+t*v).^2)) > val + ALPHA*t*fprime )
      t = BETA*t;
      %disp(strcat('linesearch t = ',num2str(t)));
   end
   
   x = x + t*v;
   
   disp(strcat('Completed iteration: ',num2str(i),' with Newton decrement = ',num2str(sqrt(lambdaSquared))));
   
end

x_newton = x;

%cvx_begin
%    variable x(n)
%    minimize -sum(log(1-A*x)) - sum(log(1+x)) - sum(log(1-x));
%cvx_end
%yep, all good
