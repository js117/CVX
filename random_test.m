m = 5; n = 5;

y = rand(m,1);
x = rand(n,1);

w1 = rand(m,1);
w2 = rand(m,1);
w3 = rand(m,1);
A1 = rand(m,m);

cvx_begin 

    variables W01(m,n) W02(m,n) W03(m,n)
    variable W1_inv(m,m)
    variable W2_inv(m,m)
    variable s(m) 
    variable z1(m) z2(m) z3(m) 
    
    minimize norm(W2_inv*y - W1_inv*s)
    subject to
        s == 2*z
        z == W0*x
    
    
%     minimize norm(W2_inv*y - s)
%     subject to
%         s <= W1_inv*z
%         z == W0*x
%         W2_inv == semidefinite(m,m)
%         W1_inv == semidefinite(m,m)
%         W0 == semidefinite(m,n)
        
cvx_end