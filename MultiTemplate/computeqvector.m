% q = g*1 - 2*sum(ajk*Mjk'*Bjk)
% Precondition: n == numSubBlocks
function q = computeqvector(numAxes, numSubBlocks, gamma, ajk, Bjk, MiLengths, MjkMatrices)

    % lazy: takes whatever data buffer and recreates Bjk's. In application
    % code, should keep the appropriate data buffers as queues and update 

    q = gamma*ones(numSubBlocks,1); 
    
    t = zeros(numSubBlocks,1); 

    for j=1:numAxes
        for k=1:numSubBlocks
            t = t + ajk(j,k)*MjkMatrices{j,k}'*Bjk(MiLengths(k)+1:MiLengths(k+1),j);
        end
    end
    
    q = q - 2*t;
    
end