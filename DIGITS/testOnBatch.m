% Return the absolute sum of errors / batchSize
function score = testOnBatch(W3,W2,W1,images,labels,batchSize,randomIdxs)

    score = 0;
    for i=1:batchSize
       idx = randomIdxs(i);
       x = images(:,idx);
       target = zeros(10,1); target(labels(idx)+1) = 1;
       
       y = roundOutput(feedForward(W3, W2, W1, x));

       if (abs(y - target) == 0)
           score = score + 1;
       end
       
    end

    score = score / batchSize;

end