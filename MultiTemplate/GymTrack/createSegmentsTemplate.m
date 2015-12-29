% Create segments template structure from a spliced recording B, size 
% numSamples x numAxes
function y = createSegmentsTemplate(B,accMax,gyroMax)
    B = HanningFilter(B); % PRE-SMOOTHING IS NECESSARY
    B(:,1:3) = B(:,1:3)/accMax;
    B(:,4:6) = B(:,4:6)/gyroMax;
    numAxes = size(B,2);
    y = cell(numAxes,1);
    for i=1:numAxes
       y{i} = findMonotonicSections(B(:,i)); 
    end
    % USAGE:
    % y{j}(i,1) gives the segment length for axis j, segment i 
    % (numSegments i_max differs per axis)
    % y{j}(i,2) -- segment(j,i) length
    % y{j}(i,3)-y{j}(i,4) gives segment(j,i)_max - segment(j,i)_min, i.e.
    % the spread
end