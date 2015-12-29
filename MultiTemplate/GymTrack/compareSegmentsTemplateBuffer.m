% Single axis scoring, i.e. y{j} from createSegmentsTemplate
% bufferSegments will be longer than templateSegments (and shifted like a
% queue)
% SEGMENTS OBJECT USAGE:
    % y{j}(i,1) gives the segment length for axis j, segment i 
    % (numSegments i_max differs per axis)
    % y{j}(i,2) -- segment(j,i) length
    % y{j}(i,3)-y{j}(i,4) gives segment(j,i)_max - segment(j,i)_min, i.e.
    % the spread
function y = compareSegmentsTemplateBuffer(templateSegments, bufferSegments)
    
    numSegmentsTemplate = size(templateSegments,1);
    numSegmentsBuffer = size(bufferSegments,1); 
    
    rawScore = 999999; % accumulate errors 
    
    %%%%%%% TODO: put this in outer script/loop (offline) and pass as args
    alphaSum = 0; betaSum = 0;
    %%%%%%% used for weighting coefficients (do offline, waste of compute):
    for i=1:numSegmentsTemplate
        alphaSum = alphaSum + templateSegments(i,2);
        betaSum = betaSum + (templateSegments(i,3) - templateSegments(i,4));
    end
    %%%%%%% end waste
    
    % Fix lengths with zero padding:
    lengthDiff = numSegmentsTemplate - numSegmentsBuffer;
    if (lengthDiff > 0)
       for i=1:(numSegmentsTemplate-numSegmentsBuffer)
           bufferSegments = [bufferSegments; zeros(1,4)]; 
       end
    end
    
    if (lengthDiff < 1)
        lengthDiff = 1;
    end
    %for k=1:lengthDiff % does the right thing if negative (i.e. nothing)
        thisScore = 0;
        for i=1:(numSegmentsTemplate-max(lengthDiff,0))
           % get weighting coefficients for this segment:
           alpha = templateSegments(i,2);
           beta = templateSegments(i,3) - templateSegments(i,4); 
           % main metric: can do stuff like diff of max's, min's, etc.
           % (old) i + k - 1 in the bufferSegments
           mainMetric = abs(templateSegments(i,3)-bufferSegments(i,3)) + abs(templateSegments(i,4)-bufferSegments(i,4));
           thisScore = thisScore + mainMetric*(alpha/alphaSum)*(beta/betaSum);
        end
        if (thisScore < rawScore)
           rawScore = thisScore;  
        end
    %end
    
    y = rawScore;
end