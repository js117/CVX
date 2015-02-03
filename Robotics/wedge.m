% Form the "wedge" (matrix) of a 6D vector e = (v, w)
function Ehat = wedge(e_vector)
    w = e_vector(4:6);
    v = e_vector(1:3);
    w_hat = skew(w);
    Ehat = zeros(4,4);
    Ehat(1:3,1:3) = w_hat;
    Ehat(1:3,4) = v;
end