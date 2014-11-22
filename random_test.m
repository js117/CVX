m = 200; n = 40;

y = rand(m,1);
x = rand(n,1);

w1 = rand(m,1);
w2 = rand(m,1);
w3 = rand(m,1);
A1 = rand(m,m);

cvx_begin %gp

    variable W0(m,n) 
    variable s(m) 
    variable z(m) 
    
    
    
    minimize norm(y - s,2)
    
    subject to
        
        z.^10 <= s;
        
        z == W0*x;
    
cvx_end