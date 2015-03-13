% Portfolio Optimization

p = [1.1, 1.35, 1.25, 1.05]';
S = [ 0.2, -0.2, -0.12, 0.02;
     -0.2, 1.4, 0.02, 0;
     -0.12, 0.02, 1, -0.4;
     0.02, 0, -0.4, 0.2      ];
 
 gammas = [0:0.01:2]'; 
 %will not go up to expected return of 2;
 % any gamma > max(p) will be infeasible
 variances = zeros(size(gammas));
 n = size(p,1);
 numTrials = size(gammas, 1);
 Xs = zeros(numTrials, n); % store the optimal investment vectors
 
 for i=1:numTrials
    cvx_begin quiet
        variable x(n)
        minimize (x'*S*x)
        subject to 
            p'*x >= gammas(i)
            x >= 0
            ones(1,n)*x == 1
    cvx_end
    variances(i) = cvx_optval;
    Xs(i,:) = x';
 end
 
 figure; plot(gammas, variances);