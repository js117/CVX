function out = animate2(xcycle);
%
% ANIMATE2   Visualize the walker walking down a slope. May need to edit
% depending on the model.
%

% global M Mp g L R K slope eqnhandle dim
% global M Mp g L R K alpha gamma slope eqnhandle modeldir dim wd
global M Mp g L R K alpha slope eqnhandle dim invalidResults

t = xcycle(:,1);
s = xcycle(:,2);
ns = xcycle(:,3);

fig=figure;
set(fig,'DoubleBuffer','on');
set(gca,'xlim',[-80 80],'ylim',[-80 80],...
   'NextPlot','replace','Visible','off')
movieName = strcat('movie.avi');
% robotMovie = avifile('movie.avi');

ground = [0 0
          0 0];          
refPoint = [0 0];
steps = 0;
lastNsPoint = refPoint(1);
for i=1:length(t)
    
    % Switch stance, nonstance legs
    if i >= 2 & s(i) == ns(i-1)
%         fprintf('Impact made.\n');
        ground = [0           0
                  nsPoint(1)  nsPoint(2)];
        refPoint = nsPoint;
        steps = steps + 1;
%         pause
    end
    
    % Determine the hip and feet positions in 2D space
    hipPoint = refPoint + [L*sin(-s(i)) L*cos(s(i))];
    nsPoint = hipPoint - [L*sin(-ns(i)) L*cos(ns(i))];
    x = [refPoint(1) hipPoint(1) nsPoint(1)];
    y = [refPoint(2) hipPoint(2) nsPoint(2)];
    hold off
    plot(x, y)
    
    hold on
    
    % Draw fancy-lookin x's, and the ground.
    plot(hipPoint(1), hipPoint(2), 'x', refPoint(1), refPoint(2), 'x', nsPoint(1), nsPoint(2), 'x', ground(:,1), ground(:,2), 'k')
 
    if i == 1
        ymax = hipPoint(2)+.5;
        ymin = -ymax;
        xmin = 0;
    end
    
    xmax = max([nsPoint(1)+1, refPoint(1)+1]);
    if xmin >= xmax
        xmin = min(x);
        xmax = max(x);
    end
    
    axis([xmin      xmax ...
          ymin      ymax])
    axis equal
%     axis([ground(1,1)-.5 ground(2,1)+.5 ground(1,2)-.5 ground(2,2)+.5])
%     axis equal

%     set(h,'EraseMode','xor');
    domo_origato(i) = getframe(gca);
%     robotMovie = addframe(robotMovie, domo_origato(i));
%     value = guard2(t, xcycle(i,2:end));
%     pause
end

if exist('robotMovie') ~= 0
    status = close(robotMovie);
    if status == 0
        out = [];
    else
        out = 1;
    end
else
    out = [];
end