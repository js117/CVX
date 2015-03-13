% Simplify expressions like cos(t1)*sin(t2)*cos(t3)*... using their
% 2nd-order Taylor approx.

% ex: sin(t1)*cos(t2)*cos(t3)

syms t1 t2 t3
syms a1 a2 a3 % for sin(t1)
syms b1 b2 b3 % for cos(t2)
syms c1 c2 c3 % for cos(t3)

sin1 = a1 + a2*t1 + a3*t1^2;
cos2 = b1 + b2*t2 + b3*t2^2;
cos3 = c1 + c2*t3 + c3*t3^2;

temp = sin1*cos2*cos3;
temp = expand(temp);

temp