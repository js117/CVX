% Return the absolute sum of errors / batchSize
function score = testOnBatchCostFunction(W2, W1, W0, b2, b1, b0, images, labels, batchSize)
    
    score = 0;
    
    for i=1:batchSize
        
       x = images(:,i);
       target = zeros(10,1); target(labels(i)+1) = 1;
       
       y = feedForward(W2, W1, W0, b2, b1, b0, x);

       score = score + 0.5*norm(y - target,2)^2;

    end

    score = score / batchSize;

end