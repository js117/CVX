% optimal control of unit mass

A = [1, 1; 0, 1];
B = [1*0.5, 1]';
z0 = [0,0]';
zN = [1, 0]';
z5_1 = 0;

N = 10; % must be even
n = 2; % number of state variables

HN = zeros(n,N);
for i=N:-1:1
   HN(:,N-i+1) = (A^(i-1))*B; 
end

AN = A^N;

%%%% For problem set 3, #7.a) %%%%
cvx_begin
    variable p(N)
    minimize norm(p,1) % Inf for part c, 1 for part a
    subject to
        zN - AN*z0 == HN*p
cvx_end
p_star = cvx_optval;

cvx_begin
    variable mu(n)
    minimize ((zN - AN*z0)'*mu)
    subject to 
        -ones(N,1) <= HN'*mu <= ones(N,1) % part a
        %norm(HN'*mu, 1) <= 1 % part c
cvx_end
d_star = cvx_optval;

x_xdot = zeros(n,N+1);
x_xdot(:,1) = z0;
for i=1:N
   x_xdot(:,i+1) = A*x_xdot(:,i) + B*p(i); 
end

figure; plot(p); % force
figure; plot(x_xdot(1,:)); % position
figure; plot(x_xdot(2,:)); % velocity

return;

%%%% For problem set 2, as before %%%%
cvx_begin
    variable p(N)
    minimize norm(p,2)
    subject to
        zN - AN*z0 == HN*p
cvx_end

optval_a = cvx_optval;
p_a = p;

d_t = [1,0]*HN(:,(N/2)+1:N); % i.e. get the first row of H5 = [A^4*b A^3*b ... A*b b]
cvx_begin
    variable p(N)
    minimize norm(p,2)
    subject to
        %[zN - AN*z0; 0] == [HN; [d_t, zeros(1,5)]]*p
        zN - AN*z0 == HN*p
        z5_1 - [1,0]*(A^(N/2))*z0 == [1,0]*HN(:,(N/2)+1:N)*[eye(N/2),zeros(N/2)]*p;
        %p(1:N/2) == 0
cvx_end

optval_b = cvx_optval;
p_b = p;

figure; plot(1:N,p_a,1:N,p_b);