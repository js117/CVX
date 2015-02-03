% model_test - go through given data and run multi template matching
% algorithm. 
% Run "OrganizeData" first. 

numTests = size(TTest,2);
gamma = 0.5; 
n = numTemplates; 

for i=1:numTests
    
   B = [zeros(maxRowCount,numAxes); TTest{i}]; 
   numSamples = size(TTest{i},1);
   BBuffer = zeros(maxRowCount, numAxes); 
   Xs = zeros(numSamples, n); % store solution vectors over time
   optVals = zeros(numSamples, 1);
   % store the actual norm residual that we will threshold

   % simulate iterating over time:
   for t=1:numSamples
      % fill up buffer: 
      BBuffer = B(t:t+maxRowCount-1, :); % slide forward in time
      % will need ti implement this via a queue in application code
    
      % caculate q:
      q = computeqvector(numAxes, numSubBlocks, gamma, alphaWeights, BBuffer, MiLengths, MjkMatrices);

      % Optimize:
      cvx_begin quiet
         cvx_precision low
         variable x(n)
         minimize (0.5*x'*P*x + q'*x)
         subject to
            x >= 0
            ones(1,n)*x == 1

      cvx_end
      
      Xs(t,:) = x; optVals(t) = cvx_optval;
    
      if (mod(t,25) == 0)
         disp(strcat('% Complete on dataset: ',num2str(t/numSamples))); 
      end
   end 
    
   % plot results:
   figure; plot(Xs);
   figure; plot(optVals);
    
end