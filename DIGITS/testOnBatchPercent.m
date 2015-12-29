% Return the absolute sum of errors / batchSize
function score = testOnBatchPercent(W2, W1, W0, b2, b1, b0, images, labels, batchSize)
    
    score = 0;
    
    for i=1:batchSize
        
       x = images(:,i);
       target = zeros(10,1); target(labels(i)+1) = 1;
       
       y = roundOutput(feedForward(W2, W1, W0, b2, b1, b0, x));

       %score = score + norm(y - target);
       
       if (abs(y - target) == 0)
           score = score + 1;
       end
       
    end

    score = score / batchSize;

end