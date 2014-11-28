%%%%%%%%%%%%%%% QUASICONVEX OPTIMIZATION - BISECTION METHOD %%%%%%%%%%%%%%%

k = 1000; % #of discrete domain points

t = zeros(k,1); %to hold t data
t2 = zeros(k,1); %to hold t^2 data
t3 = zeros(k,1); %to hold t^2 data
t4 = zeros(k,1); %to hold t^2 data
t5 = zeros(k,1); %to hold t^2 data
t6 = zeros(k,1); %to hold t^2 data
t7 = zeros(k,1); %to hold t^2 data
t8 = zeros(k,1); %to hold t^2 data
t9 = zeros(k,1); %to hold t^2 data
t10 = zeros(k,1); %to hold t^2 data
t11 = zeros(k,1); %to hold t^2 data

y = zeros(k,1); %to hold y = f(x) data

lower_lim = -pi; % set as desired
upper_lim = pi;

for i=1:k
   t(i) = lower_lim + (upper_lim-lower_lim)*(i-1)/(k-1);% the linspace
   
   % Polynomial features:
   t2(i) = t(i)*t(i);
   t3(i) = t2(i)*t(i);
   t4(i) = t3(i)*t(i);
   t5(i) = t4(i)*t(i);
   t6(i) = t5(i)*t(i);
   t7(i) = t6(i)*t(i);
   t8(i) = t7(i)*t(i);
   t9(i) = t8(i)*t(i);
   t10(i) = t9(i)*t(i);
   t11(i) = t10(i)*t(i);
   
   % Function to approximate:
   y(i) = cos(t(i));
end

% upper and lower bounds on qcvx problem of norm minimization
u = 10e3; l = 0; tol = 0.001;
gamma = (l + u)/2;

n = 8;

while (tol < (u - l))
    
    gamma = (l + u)/2;
    %solve cvx feasibility problem
    cvx_begin
        %cvx_quiet(true);
        variable x(n)

        minimize 0; %actual objective is norm(n/d - y, Inf) 
        subject to
            %%%%%%%%%%%%
            

    cvx_end
    
    if (strcmp(cvx_status,'Solved') == 0) %infeasible
       l = gamma; 
    else %feasible - lower the upper bound
       u = gamma; 
    end
end