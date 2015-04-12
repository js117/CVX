function y = GenerateRandomX(Xmin, Xmax, T)
    X = 2*(rand(size(Xmax,1),T)-0.5); %now between -1, 1
    % to derive, draw out and match ratios of (l1, x1, u1) and (l2, x2, u2)
    % with l1 = -1, u1 = 1, l2 = Xmin, u2 = Xmax
    for i=1:T
       X(:,i) = ((X(:,i)+1).*Xmax + (1-X(:,i)).*Xmin)/2;
    end
    y = X;
end