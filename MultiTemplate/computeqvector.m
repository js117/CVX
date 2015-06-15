% q = g*1 - 2*sum(ajk*Mjk'*Bjk)
% Precondition: n == numSubBlocks
function q = computeqvector(numAxes, numTemplates, numSubBlocks, gamma, ajk, Bjk, MiLengths, MkLengths, MjkMatrices)

    % lazy: takes whatever data buffer and recreates Bjk's. In application
    % code, should keep the appropriate data buffers as queues and update 

    t = zeros(numTemplates,1); 

    for j=1:numAxes
        for k=1:numTemplates
            
            bjkMatlab = Bjk(MiLengths(k)+1:MiLengths(k+1),j);
            
%             % TESTING
%             if (j == 1 && k == 13)
%                 size(bjkMatlab)
%                 q = bjkMatlab;
%                 return;
%             end
            
            addition = ajk(j,k)*MjkMatrices{j,k}'*bjkMatlab;
            t = t + addition;
            
            %disp('lims:')
            %MiLengths(k)+1
            %MiLengths(k+1)
            %addition'
            
            %if (size(Bjk(MiLengths(k)+1:MiLengths(k+1),j), 1) == 0)
            %    MiLengths(k)+1
            %    MiLengths(k+1)
            %end
            %bjk = Bjk(MiLengths(k)+1:MiLengths(k+1),j);
            %size(bjk)
            
        end
    end
    
    q = -2*t;
    
end