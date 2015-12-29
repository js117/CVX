function [xafter, tafter, xbefore, tbefore] = step3(xin);
% STEP2   Simulate 1 step, and calculate the step after impact.
%
% [xafter, tafter, xbefore, tbefore] = step2(xin);
%
% xafter = state after impact
% tafter = time at impact
% xbefore = vector of the states at each integration time, up to impact.
% tbefore = vector of times for each state.
%
% Notice that ode45 outputs our variables in reverse order, compared to how
% we output our variables.
%

global M Mp g l w slope dim

tspan = [0 10];
options = odeset('Events', @guard3, 'AbsTol', 1e-6, 'RelTol', 1e-7); %, 'OutputFcn', @odeplot, 'OutputSel', [1 2]); 
[t x tcontact xcontact] = ode45(@eqns3, tspan, xin, options);

if (length(xcontact) == 0 | length(tcontact) == 0)
%     fprintf(1, '\nstep2 error: Guard does not trigger before %i secs. RESULTS ARE INCORRECT.\n\n', tspan(2));
%     xcontact = x(end, :);
    % I should put a return statement here, but I want the program to
    % terminate itself; and if called by walk2 then I want instability to
    % show itself!
    xafter = [];
    tafter = [];
    xbefore = [];
    tbefore = [];
    return
elseif length(tcontact) > 1 & size(xcontact) == [2 4]
    % The state after and before impact will trigger the event function, in
    % this case guard2, at time t = 0.00000000, but ode45 ignores this very
    % first event trigger and so we end up with a tcontact and xcontact
    % with more than 1 row, corresponding to multiple event triggers! This
    % seems bad. To do: double check ode45 code and verify that they ignore
    % triggers at the start of integration.
    tcontact = tcontact(2);
    xcontact = xcontact(2,:);
end

xafter = eqns3(xcontact, 'i')';
tafter = tcontact;
xbefore = x;
tbefore = t;
