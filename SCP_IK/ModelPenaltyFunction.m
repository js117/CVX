% Return the value of the current SCP CVX approx model at the previous
% starting point
function y = ModelPenaltyFunction(n, m, T, t1, t2, s, s2, mu, Xcurrent) % X is current point
    t1 = zeros(n,T);
    t2 = zeros(n,T);
    f = 0;
    for k=1:T-1
       f = f + norm(Xcurrent(:,k+1)-Xcurrent(:,k),2); 
    end
    f = f + mu*(ones(n,1)'*t1*ones(T,1) + ones(n,1)'*t2*ones(T,1) + ones(m,1)'*s + ones(n,1)'*s2);
    y = f;
end