% P is n x n matrix used in quadratic form (1/2)*x'*P*x + q'*x + r
% We rewrite as two matrices P = Pcvx + Pccv 
% Where the eigenvalues of Pcvx > 0 and eigenvalues of Pccv < 0
function [Pcvx, Pccv] = ConvexConcaveDecompose(P)

    eps = 1e-4;
    n = size(P,1);
    [U,S,V] = svd(P);
    [E, D] = eigs(P);
    
    Pcvx = zeros(size(P));
    Pccv = zeros(size(P));
    
    for i=1:n
        if D(i,i) > 0
            Di = zeros(n,n);
            Di(i,i) = D(i,i);
            Pcvx = Pcvx + U*Di*V';
        else 
            Di = zeros(n,n);
            Di(i,i) = abs(D(i,i));
            Pccv = Pccv + U*Di*V';
        end
    end
    % Ensure decomposition has eigs > 0 and < 0 strictly so we can do
    % Cholesky factorization
    % (Note that we still have P == Pcvx + Pccv)
    buffer = (min(abs(diag(D))) + eps)*eye(n,n);
    Pcvx = Pcvx + buffer;
    Pccv = Pccv - buffer;
    
end