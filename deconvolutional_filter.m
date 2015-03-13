% deconvolutional filter

n = size(h,1); % h is Rn, and given
m = 20; % deconv filter g is Rm

optVals = 1e10*ones(n,1);
optFilters = zeros(m,n);

H = zeros(n,m);
for i=1:n
   H(i:n,i) = h(i:n); 
end

for D=1:n
    cvx_begin quiet
        variable g(m)
        f = 0; % function variable
        for i=1:n
           if i ~= D
               f = f + (H(i,:)*g)^2;
           end
        end
        minimize f
        subject to 
            H(D,:)*g == 1;
    cvx_end
    optVals(D) = cvx_optval;
    optFilters(:,D) = g;
end

[minOptVal, minIndex] = min(optVals);
optDeconvFilter = optFilters(:,minIndex);

