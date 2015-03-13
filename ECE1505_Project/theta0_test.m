% test theta0

l = 8;
n = 3;

T = [1, 1, 1; 1, -1, -1; 1, 1, 0; 1, -1, 0; 1, -1, 0; 1, 1, 0; 1, -1, -1; 1, 1, 1];

p = [-pi/2, -pi/2, pi/2, pi/2, 0, 0, 0, 0]';

w = zeros(size(p));

thetaMin = [-pi, -pi, -pi]';
thetaMax = -1*thetaMin;

cvx_begin
    variable theta0(n)
    variable k(l)
    minimize norm(T*theta0 + p + 2*pi*k, 2)
    subject to
        thetaMin <= theta0 <= thetaMax
        k >= 1
        %-n*pi*ones(l,1) <= w <= n*pi*ones(l,1)
cvx_end

cvx_begin
    variable theta0(n)
    variable k(l)
    minimize norm(T*theta0 + p + 2*pi*k, 2)
    subject to
        thetaMin <= theta0 <= thetaMax
        k <= -1
        %-n*pi*ones(l,1) <= w <= n*pi*ones(l,1)
cvx_end
