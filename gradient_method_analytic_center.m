% gradient method for problem instance "analytic center of set of
% inequalities ai'*x <= bi and abs(xi) <= 1"

% algorithm
% given x0 (starting point), GRADTOL, MAXITERS, line search params
% while norm(gradient(x)) < GRADTOL
%
%   compute function(x)
%   compute gradient(x)
%
%   deltaX = -gradient(x)
%   do line search to compute step size t > 0
%   
%   update: x = x + t*deltaX
%
% end

ALPHA = 0.01;
BETA = 0.5;
MAXITERS = 1000;
GRADTOL = 1e-3;

n = 1000;
m = 20000;
randn('state',1);
A=randn(m,n);
x = zeros(n,1); %initial point x(0) is 0

% Iterative main loop
for i=1:MAXITERS
   
   val = -sum(log(1-A*x)) - sum(log(1+x)) - sum(log(1-x));
   grad = A'*(1./(1-A*x)) - 1./(1+x) + 1./(1-x);
   grad_norm = norm(grad,2);
   if grad_norm < GRADTOL, break; end;
   v = -grad;
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
   
   disp(strcat('Completed iteration: ',num2str(i),' with grad norm = ',num2str(grad_norm)));
   
end





