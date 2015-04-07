% ECE1505 Assignment 4 Q1

% Set W:
W = W50; % W = W10; W = W50;
[n,n] = size(W);

%%% Get Xstar from relaxed problem %%%
cvx_begin
    variable Xstar(n,n)
    minimize trace(Xstar*W)
    subject to
            Xstar == semidefinite(n)
            for i=1:n
                Xstar(i,i) == 1
            end
cvx_end
p_star_relaxed = cvx_optval;

% cvx_begin
%     variable v(n);
%     maximize(-sum(v));
%     subject to
%             W + diag(v) == semidefinite(n);
% cvx_end
% p_star_relaxed2 = cvx_optval; % testing to confirm model equality

%%%%%%%%% 11.23b - eigenvector heurisric %%%%%%%%%%
[E,D] = eigs(Xstar);
x_hat_b = sign(E(:,1)); % pick 1st eigenvector, corresponds to largest eigenval.
p_star_b = x_hat_b'*W*x_hat_b;

%%%%%%%%% 11.23c - randomized method heuristic %%%%%%%%%
% Reference: http://www.mathworks.com/help/matlab/ref/randn.html
% e.g.
% mu = [1 2];
% sigma = [1 0.5; 0.5 2];
% R = chol(sigma);
% z = repmat(mu,10,1) + randn(10,2)*R
K = 100;
mu = zeros(1,n);
% R = chol(Xstar); % Note that we may not have a Cholesky decomp. if any
% eigs equal 0 (i.e. Xstar is not necessary positive definite).
% Instead we can use an LDL' decomposition:
[L,D] = ldl(Xstar);
R = (L*D^0.5)'; % so that R'*R == Xstar, like the Cholesky decomp.
% And when Xstar is strictly positive definite, the decompositions are
% equivalent.
Xsamples = repmat(mu,K,1) + randn(K,n)*R;
% sample j is X(j,:) for j = 1,...,K
x_hat_c = sign(Xsamples(1,:))';
p_star_c = x_hat_c'*W*x_hat_c;
for j=2:K

    test_x = sign(Xsamples(j,:))';
    test_p_star_c = test_x'*W*test_x;

    if (test_p_star_c < p_star_c)
        x_hat_c = test_x;
        p_star_c = test_p_star_c;
    end
end

%%%%%%%%%%% d-a: greedy improvement on SDP bound from random samples %%%%%%%%%%
% "For 11.23(d-a), please use 100 random starting points chosen
%  uniformly among 2n sequences in {+1, -1}^n, and choose the best among them."
% Interpretation: choose the best out of the initial K(=100) samples, then
% perform greedy bit swapping heuristic:

test_x = sign(rand(n,1)-0.5); % generates random vector {+1, -1}^n
p_star_da = test_x'*W*test_x;

for j=2:K

    test_x = sign(rand(n,1)-0.5); % generates random vector {+1, -1}^n
    test_p_star_da = test_x'*W*test_x;

    if (test_p_star_da < p_star_da)
        x_hat_da = test_x;
        p_star_da = test_p_star_da;
    end
end

% Greedy bit swapping heuristic:
[p_star_da, x_hat_da] = GreedyBitSwap(x_hat_da, p_star_da, W, n);

%%%%%%%%%%% d-b: greedy improvement on eigenvector heuristic %%%%%%%%%%
% Greedy bit swapping heuristic:
[p_star_db, x_hat_db] = GreedyBitSwap(x_hat_b, p_star_b, W, n);

%%%%%%%%%%% d-c: greedy improvement on randomized method %%%%%%%%%%
% "For 11.23(d-c), instead of following the instruction in the book, please use 100 random starting points
%  chosen according to the distribution defined in 11.23(c), do greedy search on all, and find
%  the best among them."

x_hat_dc = sign(Xsamples(1,:))'; % from 11.23c)
p_star_dc = x_hat_dc'*W*x_hat_dc;
for j=2:K

    test_x = sign(Xsamples(j,:))';
    test_p_star_dc = test_x'*W*test_x;

    % Now optimize via greedy search: 
    [test_p_star_dc, test_x] = GreedyBitSwap(test_x, test_p_star_dc, W, n);

    if (test_p_star_dc < p_star_dc)
        x_hat_dc = test_x;
        p_star_dc = test_p_star_dc;
    end
end

%%% For fun - test all possible binary combinations for W10:
Vs = repmat({[-1,1]},10,1); 
combs = allcomb(Vs{:}); %size 1024 x 10; source for allcomb: 
% http://www.mathworks.com/matlabcentral/fileexchange/10064-allcomb
p_star_10 = 999999;
x_star_10 = ones(10,1);
for i=1:1024
    test_x = combs(i,:)';
    p_star_10_test = test_x'*W10*test_x;
    if (p_star_10_test < p_star_10)
        x_star_10 = test_x;
        p_star_10 = p_star_10_test;
    end
end

