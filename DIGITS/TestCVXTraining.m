% Test training

% 1. Define network sizes
numImages = size(images,2);
n1 = size(images,1); % e.g. 784, input size
n2 = 30;           % size of next layer
n3 = 150;           % size of next layer
n4 = 10;                 % final layer, i.e. digit classifier

W1 = (rand(n2,n1+1) - 0.5)/n1; % the +1 are for bias values
W2 = (rand(n3,n2+1) - 0.5)/n2;
W3 = (rand(n4,n3+1) - 0.5)/n3;
gamma = 0.001; % regularization constant

% Try a basic feedforward:
x = images(:,1);
h1 = W1*[x;1];
h2 = W2*[h1;1];
y = W3*[h2;1];

y = feedForward(W3, W2, W1, images(:,1));
y = roundOutput(y);
% Try a round of training:

target = zeros(10,1); target(labels(1)+1) = 1;

% hold other values constant:
% x = images(:,1);
% h1 = W1*[x;1];
% h2 = W2*[h1;1]; 
% cvx_begin
% 
%     variable W3(n4,n3+1)
%     variable y(n4)
%     
%     minimize norm(y - target, Inf) + gamma*norm(W3,1)
%     subject to
%                 y == W3*[h2;1]
%                 sum(y) == 1
%                 y >= 0
% cvx_end

% Create and train on a batch:
batchSize = 200;
randomIdxs = round(numImages*rand(batchSize,1));

x = zeros(n1,batchSize);
h1 = zeros(n2,batchSize);
h2 = zeros(n3,batchSize);
W3old = W3;

disp('Pre-train test score:')
numTests = size(images_test,2);
score = testOnBatch(W3,W2,W1,images_test,labels_test,numTests,1:numTests)

cvx_begin

    variable W3(n4,n3+1)
    variable y(n4,batchSize)
    cost = 0;
    for i=1:batchSize
       idx = randomIdxs(i);
       x(:,i) = images(:,idx);
       h1(:,i) = W1*[x(:,i);1];
       h2(:,i) = W2*[h1(:,i);1];
       target = zeros(10,1); target(labels(idx)+1) = 1;
       cost = cost + norm(y(:,i) - target, Inf); 
    end
    minimize cost + gamma*norm(W3,1)
    subject to
                for i=1:batchSize
                    y(:,i) == W3*[h2(:,i);1]
                    sum(y(:,i)) == 1
                    y(:,i) >= 0
                end
cvx_end

% Update rule: should we step all the way? Here is an example interpolation
scores = zeros(batchSize,1);
for i=1:batchSize
   alpha = i/batchSize;
   alpha
   W3test = W3old + alpha*(W3 - W3old);
end

disp('Post-train test score:')
score = testOnBatch(W3,W2,W1,images_test,labels_test,numTests,1:numTests)

figure;plot(scores);