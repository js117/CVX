% model_test - go through given data and run multi template matching
% algorithm. 
% Run "OrganizeData" first. 

numTests = size(TTest,2);
gamma = 0.1; 
n = numTemplates; 
B = zeros(maxRowCount,numAxes);
B = [B; zeros(30,numAxes)]; %for Java offset debugging
for i=1:numTests
    B = [B; TTest{i}];
end
% Normalization - see note in OrganizeData.m
% Note that the user data collection routine should do this in real-time
B(:,1:3) = B(:,1:3) / ACC_MAX;
B(:,4:6) = B(:,4:6) / GYRO_MAX;
 
numSamples = size(B,1);
fakeLim = 1000; % for testing
BBuffer = zeros(maxRowCount, numAxes); 
Xs = zeros(numSamples, n); % store solution vectors over time
%Qs = zeros(numSamples, n); % store q vectors over time (debugging)
Qs = zeros(fakeLim,n); % for testing other vectors 
optVals = zeros(numSamples, 1);
% store the actual norm residual that we will threshold

% simulate iterating over time:
skip = 4; % recommend setting this to around 4; will go faster, results roughly the same
% (which suggests our problem has good temporal continuity 
for t=1:skip:(numSamples-maxRowCount)
  % fill up buffer: 
  BBuffer = B(t:t+maxRowCount-1, :); % slide forward in time
  % will need ti implement this via a queue in application code

  % caculate q:
  
  q = computeqvector(numAxes, numTemplates, numSubBlocks, gamma, alphaWeights, BBuffer, MiLengths, MkLengths, MjkMatrices);

  %Optimize:
  cvx_begin quiet
     cvx_precision low
     variable x(n)
     minimize (0.5*x'*P*x + q'*x)
     subject to
        x >= 0
        ones(1,n)*x == 1

  cvx_end

  Xs(t,:) = x; 
  Qs(t,:) = q;
  
  optVals(t) = cvx_optval;

  if (mod(t,25) == 0) % make sure # * (skip+1) divides into this
     disp(strcat('% Complete on dataset: ',num2str(t/numSamples))); 
  end
end 

% plot results:
figure; plot(optVals);
