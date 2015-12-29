function [value, isterminal, direction] = guard3(t, x);
%
% guard3 determines when the walker strikes the ground. See ode45 help.
%
% Using the logic in this file, you cannot set direction equal to 1 or -1.
% Doing so will cause Matlab to detect false impacts if the foot position
% is numerically less than 1.
%

% global M Mp g L R K slope eqnhandle dim
global M Mp g l R K slope w alpha eqnhandle dim c

% x5 = x(2); x5dot = x(4);
% x6 = x(2); x6dot = x(5);
% x7 = x(3); x7dot = x(6);

% Copied from 3d-yx-eqns.nb using CForm
height = feval(eqnhandle, x, 'g');
q = x;
% traj = (l*q(3)*sin(q(1))) + l*q(4)*sin(q(2));
s = x(2); ns = x(3); sdot = x(5); nsdot = x(6);
traj = l*sin(ns)*nsdot-l*sin(s)*sdot;
% l*Sin(?ns(t))*Derivative(1)(?ns)(t) - l*Sin(?s(t))*Derivative(1)(?s)(t)

% traj = -(l*(cos(x(2)) - cos(x(3)))*x(6)*...
%       sin(x(1))) + ...
%    l*x(4)*(-(cos(x(1))*sin(x(2))) + ...
%       cos(x(2))*tan(slope)) + ...
%    l*x(5)*(cos(x(1))*sin(x(3)) - ...
%       cos(x(3))*tan(slope));
% trajectory = x5dot*(-(w*cos(x5)) - 2*l*sin(x5)*sin(x6 + x7/2.)*sin(x7/2.)) + ...
%    l*x7dot*(cos(x5)*sin(x6 + x7) + cos(x6 + x7)*tan(slope)) + ...
%    l*x6dot*(2*cos(x5)*cos(x6 + x7/2.)*sin(x7/2.) + ...
%       (-cos(x6) + cos(x6 + x7))*tan(slope));

if traj < 0 & ns > 0
    value = height;
else
    value = 1;
end
isterminal = 1;

direction = 0;
% direction = -1;

