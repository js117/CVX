function [value, isterminal, direction] = guard2(t, x);
%
% guard2 determines when the walker strikes the ground.
%

global M Mp g L R slope dim
value = R+L*cos(x(1)) - L*cos(x(2)) - R*cos(2*x(1)+x(2));
% value = x(1) + x(2) + 2*slope;
isterminal = 1;
direction = -1;