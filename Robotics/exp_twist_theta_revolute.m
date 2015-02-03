% Uses Rodriguez' formula for e^(wt), assuming norm(w) == 1
function M = exp_twist_theta_revolute(e,t)
    
    v = e(1:3);
    w = e(4:6);
    
    w_hat = [[0,-w(3),w(2)];[w(3),0,-w(1)];[-w(2),w(1),0]];
    
    expWt = eye(3) + w_hat*sin(t) + w_hat*w_hat*(1 - cos(t));
    
    M = [expWt, ((eye(3) - expWt)*cross(w,v) + w*(w'*v)*t); zeros(1,3), 1];

end