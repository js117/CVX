function [out1 out2] = walk2(xi, steps, graph);
% WALK2   Walk the robot for "steps", optionally graph or animate motion.
%
% [out1,out2] = walk2(xi, steps, graph);
%
% INPUT:
% + xi = the input state vector, angles and their velocites. Passed to
%   step2.
% + steps = specify the # of steps the walker should take.
% + graph = the display option. If graph = 0 or is null, nothing displayed.
%   If graph equals 1, then the walking is graphed. If graph is 2, 3, or 4,
%   the walker is animated using animate3. If graph is 5, the walker is
%   reconstructed into 3 dimensions.
%
% OUTPUT:
% + out1 = If graph = 0, 1 or null, out1 is the state after impact on the 
%   last step. If graph = 2,  out1 is something to do with the output of 
%   animate3, although truth be told I haven't yet fixed this feature.
% + out2 = null if graph = 2, otherwise contains all the states beginning
%   from time = 0 to the time of the last point of contact w/ the slope.
%
% Note: Optionally allow the simulation to proceed if contact is not made 
% w/i 10 seconds by putting 'allow no contact' as the 2nd input to step2,
% by editing this function yourself.
%
% xafter = state after computing impact
% tafter = time at which the guard triggers
% xbefore = all states over time prior to computing impact
% tbefore = the corresponding times, always from 0 to tlast.
%             tbefore(end,:) = tafter
% tlast = the tbefore from the previous step
%

% global M Mp g l R K slope w eqnhandle dim modeldir wd
% global M Mp g L R K alpha gamma slope eqnhandle modeldir dim wd
global M Mp g L R K alpha slope mu eqnhandle modeldir dim wd invalidResults

if size(xi) ~= [1 dim]
    fprintf('walk2 error: Input state vector must have %i row and %i cols.\n', size(xi)*[1 0]', size(xi)*[0 1]');
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
for step=1:steps
    [xafter tafter xbefore tbefore] = step2(xi, 'allow no contact');
%     [xafter tafter xbefore tbefore] = step2(xi);
    
    % Check if no contact made w/i 10 seconds. This check unnecessary if 
    % you specify 'allow no contact' in call to step2 above.
    if length(xafter) == 0 & length(tafter) == 0 & length(xbefore) == 0 & length(tbefore) == 0
        out1 = [];
        out2 = [];
        return
    end
 
%     t = [t ; tbefore+tlast ; tafter+tlast]
%     x = [x ; xbefore       ; xafter]
    t = [t ; tbefore+tlast];
    x = [x ; xbefore];
    tlast = tafter+tlast;
    xi = xafter;
%     if length(t) <= 24 | length(t) >= 19
%         step
%         t(end-3:end,:)
%         x(end-3:end,:)
%     end
end
out1 = x(end,:);
out2 = [t x];

if graph == 1
    
% figure('Position', [left bottom width height])
screenSize = get(0, 'ScreenSize');
figure('Position', [screenSize(3)/2 0                   screenSize(3)/2     screenSize(4)/2])
% figure
    subplot(1,2,1)
    plot(x(:,1), x(:,3), 'r')
    title({'S vs. Sdot';['slope =',num2str(slope)]});
    subplot(1,2,2)
    plot(x(:,2), x(:,4), 'b')
    title({'NS vs. NSdot';['slope =',num2str(slope)]});
figure('Position', [0               screenSize(4)/2     screenSize(3)/2     screenSize(4)/2])
% figure
    plot(t, x(:,1), 'r', t, x(:,2), 'b', t, x(:,1)+x(:,2)+2*slope, 'g')
    titleString = sprintf('%s\nS (red), NS (blue), guard (green)', modeldir(length(wd)+1:end));
    title(titleString);
figure('Position', [screenSize(3)/2 screenSize(4)/2     screenSize(3)/2     screenSize(4)/2])
    plot(t, x(:,2)-x(:,1), 'gx')
    title('S-NS');
figure('Position', [0               0                   screenSize(3)/2     screenSize(4)/2])
    plot(t, x(:,3), 'r', t, x(:,4), 'b')
    title('Sdot (red), NSdot (blue)');
    
elseif graph == 2
    
    out1 = animate3(out2);
    out2 = [];
    
elseif graph == 3

    out1 = animate3(out2, 1);
    out2 = [];

elseif graph == 4

    out1 = animate3(out2, 2);
out2 = [];
    
elseif graph == 5
    
    reconstruct2(out2, 0)
    
end

% function [out1, out2] = walk2(xi, steps, graph);
% % WALK2   Walk the robot for steps, optionally choose to graph or animate 
% % the walker.
% %
% % [out1, out2] = walk2(xi, steps, graph);
% % 
% % If graph equals 1, 0 or null then out1 and out2 are xlast and xcycle.
% % If graph equals 2 then out1 is a movie output from animate2, and out2 is
% % null.
% %
% % xafter = state after computing impact
% % tafter = time at which the guard triggers
% % xbefore = all states over time prior to computing impact
% % tbefore = the corresponding times, always from 0 to tlast.
% %             tbefore(end,:) = tafter
% % tlast = the tbefore from the previous step
% %
% % out1 = the state after the very last step is completed
% % out2 = all of the states from 
% 
% %
% % global M Mp g L R K slope eqnhandle dim
% global M Mp g L R K slope eqnhandle modeldir wd dim
% 
% % Parse inputs ...
% if nargin <= 2
%     graph = 0;
% end        
% 
% if length(M) == 0 | length(slope) == 0
%     fprintf('Define your global variables first.');
%     return
% end
% % ... end parse inputs.
% 
% t = [];
% x = [];
% tlast = 0;
% for step=1:steps
%     [xafter tafter xbefore tbefore] = step2(xi);
%     
%     % Check outputs
%     if length(tafter) == 0 | length(xafter) == 0
%         fprintf(1, 'walk2 error: Foot did not make contact.\n');
% %         xlast = [];
% %         xcycle = [];
% %         out1 = [];
% %         out2 = [];
% %         break
%         xafter = xbefore(end,:);
%         tafter = tbefore(end,:);
%     elseif length(tafter) ~= 1
% %         step;
% %         xafter;
% %         tafter;
% %         fprintf(1, 'walk2 msg: Why does the guard trigger more than once?\n');
% %         fprintf(1, 'tlast length: %i, new value: %g.\n', length(tafter), max(tafter));
%         tafter = max(tafter);
%     end
%     
%     t = [t ; tbefore+tlast ; tafter+tlast];
%     x = [x ; xbefore       ; xafter];
%     tlast = tafter+tlast;
%     xi = xafter;
% end
% 
% xlast = x(end,:);
% xcycle = [t x];
% out1 = xlast;
% out2 = xcycle;
% 

