% 1D signal reconstruction via CVX
function y = SignalReconstruction(x, alpha)
    n = length(x);
    % x is a corrupted signal, x_hat is reconstruction
    cvx_begin
        variable x_hat(n);
        variable v(n-1);
        minimize norm(x_hat - x, 2) + alpha*norm(v, 1) % total variation smoothing
        subject to
            for i=1:n-1
               v(i) == x_hat(i+1) - x_hat(i);
            end
    
    cvx_end
    y = x_hat;
end