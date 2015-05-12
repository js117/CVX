function y = roundOutput(yin)
    % Get the most likely guess to compare to target
    [val,idx] = max(yin);
    y = zeros(length(yin),1);
    y(idx) = 1;
end