% Test matrix decomposition approximations

n = size(P1,1);

cvx_begin
    variables X(n,n) Y(n,n)
    variables lam(n)
    variable upper_lim
    minimize norm(P1 - X + Y, 2)
    subject to
        X == semidefinite(n)
        Y == semidefinite(n)
       
        
        
        % Below: make the matrix Y have repeated large first eigenval.
        % Regularize objective with + 0.1*[0,ones(1,n-1)]*lam
        %0 <= lam(1)*eye(n)
        %for i=1:n-1
        %    lam(i)*eye(n) <= lam(i+1)*eye(n)
        %end
        %lam(n-1)*eye(n) <= Y <= lam(n)*eye(n)
        
cvx_end

