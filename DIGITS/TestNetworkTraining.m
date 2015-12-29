% Test training

% 1. Define network sizes
numImages = size(images,2);
n = size(images,1); % e.g. 784, input size
m0 = 30;           % size of next layer
m1 = 30;           % size of next layer
m2 = 10;                 % final layer, i.e. digit classifier

W0 = (rand(m0,n) - 0.5)*0.01;
W1 = (rand(m1,m0) - 0.5)*0.01;
W2 = (rand(m2,m1) - 0.5)*0.01;
b0 = zeros(m0,1); %(rand(m0, 1) - 0.5);
b1 = zeros(m1,1); %(rand(m1, 1) - 0.5);
b2 = zeros(m2,1); %(rand(m2, 1) - 0.5);
delta = 3; % gradient descent constant

% Try a basic feedforward:
x = images(:,1);

y = feedForward(W2, W1, W0, b2, b1, b0, x);
y = roundOutput(y);
% Try a round of training:

target = zeros(10,1); target(labels(1)+1) = 1; %+1 is offset for zero 
% now the vector target is comparable to output prediction y

%return;

disp('Pre-train test score (first X):')
numTests = 50;
score = testOnBatchPercent(W2,W1,W0,b2,b1,b0,images_test(:,1:numTests),labels_test(1:numTests),numTests)
preScore = score;

%return;

%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN TRAINING ROUTINE %%%%%%%%%%%%%%%%%%%%%%%%%%
numItrs = 100000;
numTraining = 60000;
batchSize = 1;

for itrs=1:numItrs
    
   %%%%%%%%%%%%%%%%%%%%% STAGE 1: FEEDFORWARD ON BATCH

   idx = GetRandInRange(1,numTraining);
   x = images(:,idx);
   [y, s2, a1, s1, s0, a0] = feedForward(W2, W1, W0, b2, b1, b0, x);
   target = zeros(10,1); target(labels(idx)+1) = 1;
   batchErrorVector = y - target; % each of y,target will have a single non-zero element equal to 1
    
   %batchErrorVector
   
   %%%%%%%%%%%%%%%%%%%%% STAGE 1: BACKPROP ON PARAMS
   error2 = batchErrorVector .* sigmoidDerivative(s2); %diag(sigmoidDerivative(s2))*batchErrorVector;
   dW2 = error2*a1';
   db2 = error2;
   error1 = (W2'*error2) .* sigmoidDerivative(s1); %diag(sigmoidDerivative(s1))*W2'*error2;
   dW1 = error1*a0';
   db1 = error1;
   error0 = (W1'*error1) .* sigmoidDerivative(s0); %diag(sigmoidDerivative(s0))*W1'*error1;
   dW0 = error0*x';
   db0 = error0;
   
   W2 = W2 - delta*dW2;
   W1 = W1 - delta*dW1;
   W0 = W0 - delta*dW0;
   b2 = b2 - delta*db2;
   b1 = b1 - delta*db1;
   b0 = b0 - delta*db0;
   
   
   %norm(batchErrorVector) %should decrease with more iterations
   if (mod(itrs,100) == 0)
      numTestsVal = 50;
      testScore = testOnBatchCostFunction(W2,W1,W0,b2,b1,b0,images_test(:,1:numTestsVal),labels_test(1:numTestsVal),numTestsVal);
      disp('itrs: '); disp(itrs); disp(' // ');
      disp('avg test cost function: '); disp(testScore);
   end
   
end

disp('Pre-train test score:')
preScore
disp('Post-train test score:')
score = testOnBatchPercent(W2,W1,W0,b2,b1,b0,images_test(:,1:numTests),labels_test(1:numTests),numTests)

