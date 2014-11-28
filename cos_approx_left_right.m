% return approximate cosine from -pi to 0, and 0 to pi
function [y_left, y_right] = cos_approx_left_right(x)
    %x_feats = [x, x.^2, x.^4, x.^6, x.^8, x.^10, x.^12]; 
    %W0_left = [1.0000,    0.0000,   0.5000,    0.0417,   0.0014,    0.0000,   0.0000];
    
    x_feats = [x, x.^4, x.^6, x.^8];
    
    %W0_right = [1.0000,   -0.0000,   -0.5000,    0.0417,   -0.0014,    0.0000,  -0.0000];
    
end