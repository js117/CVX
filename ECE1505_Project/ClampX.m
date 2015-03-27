function y = ClampX(X, Xmin, Xmax)
    lim = size(Xmin,1);
    for i=1:lim
       if X(i) < Xmin(i)
           X(i) = Xmin(i);
       end
       if X(i) > Xmax(i)
           X(i) = Xmax(i);
       end
    end
    y = X;
end