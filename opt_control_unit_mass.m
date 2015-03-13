% optimal control of unit mass

A = [1, 1; 0, 1];
B = [1*0.5, 1]';
z0 = [0,0]';
zN = [1, 0]';
z5_1 = 0;

N = 10000; % must be even

HN = zeros(2,N);
for i=N:-1:1
   HN(:,N-i+1) = (A^(i-1))*B; 
end

AN = A^N;

cvx_begin
    variable p(N)
    minimize norm(p,2)
    subject to
        zN - AN*z0 == HN*p
cvx_end

optval_a = cvx_optval;
p_a = p;

cvx_begin
    variable p(N)
    minimize norm(p,2)
    subject to
        zN - AN*z0 == HN*p
        z5_1 - [1,0]*(A^(N/2))*z0 == [1,0]*HN(:,1:(N/2))*[eye(N/2),zeros(N/2)]*p;
        %p(1:N/2) == 0
cvx_end

optval_b = cvx_optval;
p_b = p;

figure; plot(1:N,p_a,1:N,p_b);