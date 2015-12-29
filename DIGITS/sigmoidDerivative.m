function y = sigmoidDerivative(x)
    y = sigmoid(x).*(1-sigmoid(x));
end