% the "hat" operation: b --> a x b <---> a x b = (a)^b
function y = vec2SSMat(v)
    y = [0, -v(3), v(2);
         v(3), 0, -v(1);
         -v(2), v(1), 0];
end