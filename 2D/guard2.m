function [value, isterminal, direction] = guard2(t, x);
%
% guard2 determines when the walker strikes the ground.
%

% global M Mp g L R K slope eqnhandle dim
% global M Mp g L R K alpha gamma slope eqnhandle modeldir dim wd
global M Mp g L R K alpha slope eqnhandle dim invalidResults
l = L;
% value = eqns2(x, 'g');
% 
height = feval(eqnhandle, x, 'g');
s = x(1); ns = x(2); sdot = x(3); nsdot = x(4);
traj = l*sin(ns)*nsdot-l*sin(s)*sdot;
% value = value(1);
% value = x(1) + x(2) + 2*slope;
% value = R+L*cos(x(1)) - L*cos(x(2)) - R*cos(2*x(1)+x(2));
% if x(2) > 0 | x(4) > 0
%     isterminal = 1;
% else 
%     isterminal = 0;
% end
% direction = -1;

if traj < 0 & ns > 0 
    value = height;
else
    value = 1;
end
isterminal = 1;

% direction = -1;
direction = 0;  