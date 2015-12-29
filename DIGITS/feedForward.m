% 3 layer network with rectified linear units
function [a2, s2, a1, s1, s0, a0] = feedForward(W2, W1, W0, b2, b1, b0, x) 

    
    s0 = W0*x + b0;
    a0 = sigmoid(s0); %max(0, s0);
    s1 = W1*a0 + b1;
    a1 = sigmoid(s1); %max(0, s1);
    s2 = W2*a1 + b2; 
    a2 = sigmoid(s2); %max(0, s2);
    
end