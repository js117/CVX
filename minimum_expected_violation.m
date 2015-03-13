% test

m = 100; n = 10;

A = rand(m,n);
b = rand(m,1);

cvx_begin
    variable x(n)
    minimize max(pos(b - A*x))
    subject to
        norm(x, inf) <= 1
cvx_end

p1 = cvx_optval;
x1 = x;

cvx_begin
    variable x(n)
    variable s(m)
    variable t(1)
    minimize t
    subject to
        s >= b - A*x
        s >= 0
        t*ones(m,1) >= s
        norm(x, inf) <= 1
cvx_end

p2 = cvx_optval;
x2 = x;
