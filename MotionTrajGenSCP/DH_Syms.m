% Input t is a sym, output T is transformation matrix
function T = DH_Syms(d, alpha, a, t, o) %o is offset...
syms T
ca = round((cos(alpha)*10000))/10000;
sa = round((sin(alpha)*10000))/10000;
co = round((cos(o)*10000))/10000;
so = round((sin(o)*10000))/10000;
T =    [    (cos(t)*co-sin(t)*so)      -(sin(t)*co+cos(t)*so)     0   a
                    (sin(t)*co+cos(t)*so)*ca   (cos(t)*co-sin(t)*so)*ca   -sa -sa*d
                    (sin(t)*co+cos(t)*so)*sa   (cos(t)*co-sin(t)*so)*sa   ca  ca*d
                    0       0       0   1];
end
%FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
%
% e.g. for the Nao Right Arm:
%
% T1 = DH_Syms(0,-pi/2,0,t1,0)
% 
% T2 = DH_Syms(0,pi/2,0,t2,pi/2)
%
% T3 = DH_Syms(-UpperArmLength,-pi/2,0,t3,0)
%
% T4 = DH_Syms(0,pi/2,0,t4,0)
%
% 
%
%
%