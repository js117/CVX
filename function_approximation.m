% GENERALIZED FUNTION APPROXIMATION BY FEATURES

% Fit a function f: R --> R by polynomial features (e.g. a short Taylor
% Series) on a given domain

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
   y(i) = 1/(1+exp(-t(i)));
end

%test
%figure; plot(y); %good


% Optimization Routine below
A = [ones(k,1), t, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11]; %problem data
p = size(A,2); % number of features
cvx_begin
    variable x(p)
    minimize norm(y - A*x, 2)
cvx_end

fit = zeros(k,1);
for i=1:k
   fit(i) = A(i,:)*x;
end

figure; plot(t, y, 'k', t, fit, 'r');

