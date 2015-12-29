function y1 = findMonotonicSections(b)
    
    lim = length(b) - 1;
    
    % Increasing == 1, Decreasing == -1
    currFlag = 1;
    prevFlag = 0; % initialize as neither
    
    % Each entry will be [a,b,c,d]
    % a: direction (1 is increasing, 0 is decreasing)
    % b: length
    % c: max peak
    % d: min peak
    segmentBuffer = [];
    
    LARGE_NUMBER = 99999999;
    currMin = b(1);
    currMax = b(1);
    segmentLength = 1; % assume b(1) starts a segment
    
    for i=1:lim
       if (b(i+1) > b(i)) % function increasing
           
          currFlag = 1;
          if (currFlag ~= prevFlag && segmentLength > 1) % starting new segment; log old one
              % old segment is over, log data:
              % (last one must have been decreasing)
              currMin = b(i); % log the last min for the decreasing section
              entry = [-1, segmentLength, currMax, currMin];
              segmentBuffer = [segmentBuffer; entry];
              % reset values for new segment:
              currMin = b(i+1); % starting a new increasing segment, so 1st new point is min
              segmentLength = 0;
          end
          segmentLength = segmentLength + 1;
          
          
       elseif (b(i+1) < b(i)) % function decreasing
          currFlag = -1; 
           
          if (currFlag ~= prevFlag && segmentLength > 1) % starting new segment; log old one
              % old segment is over, log data:
              % (last one must have been increasing)
              currMax = b(i); % log the last max for the increasing section
              entry = [1, segmentLength, currMax, currMin];
              segmentBuffer = [segmentBuffer; entry]; 
              % reset values for new segment:
              currMax = b(i+1); % analogous to above
              segmentLength = 0;
          end
          segmentLength = segmentLength + 1;
              
       else % b(i+1)==b(i), just keep adding to current segment
          currFlag = prevFlag;
          segmentLength = segmentLength + 1;
       end
       prevFlag = currFlag;
    end
    
    % log last entry:
    if (segmentLength > 1)
        entry = [currFlag, segmentLength, currMax, currMin];
        segmentBuffer = [segmentBuffer; entry]; 
    end
    
    y1 = segmentBuffer;
    
end