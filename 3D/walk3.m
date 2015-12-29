
function [out1 out2] = walk3(xi, steps, graph);
% WALK3   Walk the robot for "steps", optionally graph or animate motion.
%
% [out1,out2] = walk2(xi, steps, graph);
%
% INPUT:
% + xi = the input state vector, angles and their velocites. Passed to
%   step3.
% + steps = specify the # of steps the walker should take.
% + graph = the display option. If graph = 0 or is null, nothing displayed.
%   If graph equals 1, then the walking is graphed. If graph is 2, the
%   walker is animated using animate3.
%
% OUTPUT:
% + out1 = If graph = 0, 1 or null, out1 is the state after impact on the 
%   last step. If graph = 2,  out1 is something to do with the output of 
%   animate3, although truth be told I haven't yet fixed this feature.
% + out2 = null if graph = 2, otherwise contains all the states beginning
%   from time = 0 to the time of the last point of contact w/ the slope.
%
% Note: Optionally allow the simulation to proceed if contact is not made 
% w/i 10 seconds by putting 'allow no contact' as the 2nd input to step3,
% by editing this function yourself.
%
% xafter = state after computing impact
% tafter = time at which the guard triggers
% xbefore = all states over time prior to computing impact
% tbefore = the corresponding times, always from 0 to tlast.
%             tbefore(end) = tafter
% tlast = the tbefore from the previous step
%

global M Mp g l R K slope w alpha eqnhandle dim modeldir wd c

if size(xi) ~= [1 dim]
    fprintf('walk3 error: Input state vector must have %i row and %i cols.\n', size(xi,1), size(xi,2));
    out1 = [];
    out2 = [];
    return
end

% Parse inputs ...
if nargin <= 2
    graph = 0;
end        

if length(M) == 0 | length(slope) == 0
    fprintf('Define your global variables first.');
    return
end

x = [];
t = [];
tlast = 0;
x0 = xi;
for step=1:steps
%     [xafter tafter xbefore tbefore] = step3(xi, 'allow no contact');
    [xafter tafter xbefore tbefore] = step3(xi);
    
    % Check if no contact made w/i 10 seconds. This check unnecessary if 
    % you specify 'allow no contact' in call to step3 above.
    if length(xafter) == 0 & length(tafter) == 0 & length(xbefore) == 0 & length(tbefore) == 0
        out1 = [];
        out2 = [];
        return
    end
 
    % We save the initial condition as tafter+tlast and xafter, so we
    % ignore the first value of tbefore and xbefore.
    t = [t ; tbefore(2:end)+tlast ; tafter+tlast];
    x = [x ; xbefore(2:end,:)     ; xafter];
    tlast = tafter+tlast;
    xi = xafter;
end
t = [0 ; t];
x = [x0 ; x];
out1 = x(end,:);
out2 = [t x];

switch (graph) 
case 1
    
    p = x(:,1);
    s = x(:,2);
    ns = x(:,3);
    pdot = x(:,4);
    sdot = x(:,5);
    nsdot = x(:,6);
    for i=1:length(t)
        guard(i) = feval(eqnhandle, x(i,:), 'g');
    end
% figure('Position', [left bottom width height])
screenSize = get(0, 'ScreenSize');
width = screenSize(3)/2;
ypos = screenSize(4)/2;
height = screenSize(4)/2.5;
% figure('Position', [width 0      width height])
figure(5)
    subplot(1,3,1)
    plot(s, sdot, 'r')
    subplot(1,3,2)
    plot(x(:,3), x(:,6), 'b')
    title({'Sdot vs. S (red), NSdot vs. N (blue), Pdot vs. P (black)';['slope =',num2str(slope)]});
    subplot(1,3,3)
    plot(x(:,1), x(:,4), 'k')
% figure('Position', [0     ypos width height])
figure(6)
    plot(t, x(:,2), 'r', t, x(:,3), 'b', t, x(:,1), 'k', t, guard, 'g')
    titleString = sprintf('%s\nS (red), NS (blue), pitch (black), guard (green)', modeldir(length(wd)+1:end));
    title(titleString);
% figure('Position', [width ypos width height])
%     plot(t, x(:,2)-x(:,3), 'go')
%     title('S-NS');
% figure('Position', [0     0      width height])
figure(7)
    plot(t, x(:,5), 'r', t, x(:,6), 'b', t, x(:, 4), 'k')
    title('Sdot (red), NSdot (blue), Pdot (black)');
clear t x;

case 2    
    
    out1 = animate3(out2);
    out2 = [];
    
case 3
        
    out1 = animate3(out2, 1);
    out2 = [];
    
case 4
    
    out1 = animate3(out2, 2);
    out2 = [];
    
case 5
    p = x(:,1);
    s = x(:,2);
    ns = x(:,3);
    pdot = x(:,4);
    sdot = x(:,5);
    nsdot = x(:,6);
%     tic;
%     for i=1:length(t)
%         guard(i) = feval(eqnhandle, x(i,:), 'g');
%     end
%     toc
    
screenSize = get(0, 'ScreenSize');
% figure('Position', [screenSize(3)/2 0                   screenSize(3)/2     screenSize(4)/2.5])

figure(5)
hold on
    subplot(1,2,1)
    hold on 
    plot(s, sdot, 'r', ns, nsdot, 'b')
    title('Sdot vs. S (red), NSdot vs. N (blue)'); %['slope =',num2str(slope)]});
    subplot(1,2,2)
    hold on
    plot(p, pdot, 'k')
    title('Pdot vs. P (black)');
% figure('Position', [0               screenSize(4)/2     screenSize(3)/2     screenSize(4)/2.5])

figure(6)
hold on
    plot(t, s, 'r', t, ns, 'b', t, p, 'k') %, t, guard, 'g')
%     titleString = sprintf('%s\nS (red), NS (blue), pitch (black), guard (green)', modeldir(length(wd)+1:end));
    title('S (red), NS (blue), pitch (black), guard (green)');
% figure('Position', [screenSize(3)/2 screenSize(4)/2     screenSize(3)/2     screenSize(4)/2.5])

% figure(3)
% hold on
%     plot(t, s-ns, 'gx')
%     title('S-NS');
% figure('Position', [0               0                   screenSize(3)/2     screenSize(4)/2.5])

figure(7)
hold on
    plot(t, sdot, 'r', t, nsdot, 'b', t, pdot, 'k')
    title('Sdot (red), NSdot (blue), Pdot (black)');
    
end
