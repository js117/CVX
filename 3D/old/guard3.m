function [value, isterminal, direction] = guard2(t, x);
%
% guard2 determines when the walker strikes the ground.
%

global M Mp g l w slope dim
value = -w*sin(x(1))+2*l*cos(x(1))*sin(x(2)+x(3)/2)*sin(x(3)/2);
% value = R+L*cos(x(1)) - L*cos(x(2)) - R*cos(2*x(1)+x(2));
% value = x(1) + x(2) + 2*slope;
isterminal = 1;
direction = -1;