function domo_origato = animate2(xcycle);
% ANIMATE2   Visualize the walker walking down a slope. May need to edit
% depending on the model.
%

global M Mp g L R slope dim

t = xcycle(:,1);
s = xcycle(:,2);
ns = xcycle(:,3);

figure(1)

refPoint = [0 0];
for i=1:length(t)
    if i >= 2 & xcycle(i, 2) == xcycle(i-1, 3)
        refPoint = nsPoint;
    end
    hipPoint = refPoint + [L*sin(-s(i)) L*cos(s(i))];
    nsPoint = hipPoint - [L*sin(-ns(i)) L*cos(ns(i))];
    x = [refPoint(1) hipPoint(1) nsPoint(1)];
    y = [refPoint(2) hipPoint(2) nsPoint(2)];
    hold off
    plot(x, y)
    ground = [refPoint(1)-1 refPoint(1)+1];
    line(ground, slope.*ground)
    hold on
    plot(hipPoint(1), hipPoint(2), 'x', refPoint(1), refPoint(2), 'x', nsPoint(1), nsPoint(2), 'x')
    axis([nsPoint(1)-1 nsPoint(1)+1 -.5 1.1])
    axis equal
    domo_origato(i) = getframe;
    value = guard2(t, xcycle(i,2:3));
%     pause
end

% movie(roboto_san, 1, 10)
