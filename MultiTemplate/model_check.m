% check if two optimization models are equivalent

m = 400; % e.g data points per template, all axes
n = 20; % e.g number of templates to compare with

A = rand(m, n); % would be the templates places into columns
b = A(:, 5) + rand(m,1); % would be the user's data, e.g match col 5
% How close are they even with noise on the same order of magnitude?
t = 1:m;
%figure; plot(t, A(:,5), 'r+', t, b, 'b*');
gamma = 0.5; % regularizer constant on L1 norm

b = rand(m,1);

cvx_begin 
    variables x(n) s(n)
    minimize (0.5*x'*2*A'*A*x - 2*x'*A'*b + b'*b + gamma*ones(1,n)*s)
    subject to
        x >= 0
        -s <= x <= s
        ones(1,n)*x == 1

cvx_end 

cvx_optval
x1 = x;

cvx_begin 
    variable x(n)
    minimize (0.5*x'*2*A'*A*x - 2*x'*A'*b + b'*b + gamma*ones(1,n)*x)
    subject to
        x >= 0
        ones(1,n)*x == 1

cvx_end 

cvx_optval
x2 = x;

P = 2*A'*A;
q = -2*A'*b + gamma*ones(n,1);
r = b'*b;

cvx_begin
    cvx_precision low
    variable x(n)
    minimize (0.5*x'*P*x + q'*x + r)
    subject to
        x >= 0
        ones(1,n)*x == 1

cvx_end 

cvx_optval
x3 = x;