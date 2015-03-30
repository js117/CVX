% X: n x T
% Xmin, Xmax: n x 1
function y = ClampX(X, Xmin, Xmax)
    T = size(X,2); lim = size(Xmin,1);
    for k=1:T
        for i=1:lim
           if X(i,k) < Xmin(i)
               X(i,k) = Xmin(i);
           end
           if X(i,k) > Xmax(i)
               X(i,k) = Xmax(i);
           end
        end
    end
    y = X;
end