function y = feedForward(W3, W2, W1, x) 

    h1 = W1*[x;1];
    h2 = W2*[h1;1];
    y = W3*[h2;1];
    
end