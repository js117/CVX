% Portfolio Opt Test

n = 100;
S = rand(n,n); S = (S' + S)/2; S = S + n*eye(n);
min_return = 0.2;
p = rand(n,1);

cvx_begin 
        variable x(n)
        minimize (x'*S*x)
        subject to 
            p'*x >= min_return
            x >= 0
            ones(1,n)*x == 1
cvx_end