function y = countRepsFromScores(scores, templateLength, threshold)
    len = length(scores);
    numReps = 0;
    isBelowThreshold = 0;
    for i=1:len
        isBelowThreshold = sign(threshold - scores(i));
        if (isBelowThreshold == 1 && prevCheck == 1) % may get rid of prevCheck since we're adding increments anyways
            numReps = numReps + 1/templateLength; 
        end
        prevCheck = isBelowThreshold;
    end
    y = round(numReps);
end