%element by element
function y = sigmoidVector(x)
    len = length(x);
    y = zeros(size(x,1),size(x,2)); 
    for i=1:len
        y(i) = sigmoid(x(i));
    end
end

function y = sigmoid(x)
    y = 1 / (1 + exp(-x)); 
end

