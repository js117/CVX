function domo_origato = animate3(xcycle);
%
% ANIMATE2   Visualize the walker walking down a slope. May need to edit
% depending on the model.
%

global M Mp g l R K slope w eqnhandle dim modeldir wd

t = xcycle(:,1);
p = xcycle(:,2);
s = xcycle(:,3);
ns = xcycle(:,4);

figure

ground = [0 0 0
          0 0 0];
refPoint = [0 0 0];
v_s = [0 0 l];
v_ns = [0 w l];
% v_hip = [0 w 0];

for i=1:length(t)
    % Get the transformation matrices
    R_roll = [1 0           0
              0 cos(p(i))  sin(p(i))
              0 -sin(p(i)) cos(p(i)) ];
    R_s = [0          1 0
           cos(s(i))  0 sin(s(i))
           -sin(s(i)) 0 cos(s(i)) ];
    R_ns = [0           1 0
            cos(ns(i))  0 sin(ns(i))
            -sin(ns(i)) 0 cos(ns(i)) ];
    R = R_s*R_roll;
    vs = R'*v_s'
    R = R_ns*R_roll;
    vns = R'*v_ns';
%     vns = vs+v_hip';
    
    plot3([refPoint(1) vs(1)], [refPoint(2) vs(2)], [refPoint(3) vs(3)], 'r') %, [refPoint(1) vns(1)], [refPoint(2) vns(2)], [refPoint(3) vns(3)])
%     hold on
    axis([-2 2 -2 2 -2 2])
    grid
%     axis equal
%     hold on
%     plot3([0 vns(1)], [0 vns(2)], [0 vns(3)])
    
    % Switch stance, nonstance legs
    if i >= 2 & ns(i) == -ns(i-1)
%         ground = [0           0
%                   nsPoint(1)  nsPoint(2)];
        refPoint = vns;
    end
    
    % Determine the hip and feet positions in 2D space
%     hipPoint = refPoint + [L*sin(-s(i)) L*cos(s(i))];
%     nsPoint = hipPoint - [L*sin(-ns(i)) L*cos(ns(i))];
%     x = [refPoint(1) hipPoint(1) nsPoint(1)];
%     y = [refPoint(2) hipPoint(2) nsPoint(2)];
%     hold off
%     plot(x, y)
%     
%     hold on
    
    % Draw fancy-lookin x's, and the ground.
%     plot(hipPoint(1), hipPoint(2), 'x', refPoint(1), refPoint(2), 'x', nsPoint(1), nsPoint(2), 'x', ground(:,1), ground(:,2), 'k')
%     if i == 1
%         ymax = hipPoint(2)+.5;
%         ymin = -ymax;
%         xmin = 0;
%     end
%     
%     axis([xmin      max(nsPoint(1)+1, refPoint(1)+1) ...
%           ymin      ymax])
%     axis equal
%     axis([ground(1,1)-.5 ground(2,1)+.5 ground(1,2)-.5 ground(2,2)+.5])
%     axis equal
    
    domo_origato(i) = getframe;
%     value = guard2(t, xcycle(i,2:end));
%     pause
end

