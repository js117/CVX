%MINIMAX RATIONAL FIT TO THE EXPONENTIAL

k = 200;
t = zeros(k,1); %to hold t data
t2 = zeros(k,1); %to hold t^2 data
y = zeros(k,1); %to hold y = e^t data
for i=1:k
   t(i) = -3 + 6*(i-1)/(k-1);
   t2(i) = t(i)*t(i);
   y(i) = exp(t(i));
end

%test
figure; plot(y); %good



epsilon = zeros(k,1);
epsilon = epsilon + 1e-6;

% upper and lower bounds on qcvx problem of norm minimization
u = 10e3; l = 0; tol = 0.001;
gamma = (l + u)/2;
M = [ones(k,1), t, t2]; %problem data

x1opt = zeros(3,1);
x2opt = zeros(2,1);

while (tol < (u - l))
    
    gamma = (l + u)/2;
    %solve cvx feasibility problem
    cvx_begin
        cvx_quiet(true);
        variable x1(3); %numerator parameters: [a0, a1, a2]'
        variable x2(2); %denominator parameters: [b1, b2]'

        minimize 0; %actual objective is norm(n/d - y, Inf) 
        subject to
            %%%%%%%%%%%%
            M*x1 - y.*(M*[1;x2]) <= gamma*M*[1;x2];
            M*x1 - y.*(M*[1;x2]) >= -gamma*M*[1;x2];

    cvx_end
    
    if (strcmp(cvx_status,'Solved') == 0) %infeasible
       l = gamma; 
    else %feasible - lower the upper bound
       u = gamma; 
       x1opt = x1;
       x2opt = x2;
    end
end

cvx_optval
figure; plot(y);

%construct rational fnc fit
fit = zeros(k,1);
n = M*x1opt;
d = M*[1;x2opt];
for i=1:k
    fit(i) = n(i)/d(i);
end
figure; plot(fit);

x1opt
x2opt