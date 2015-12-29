function status = animate3(xcycle, style);
% ANIMATE3   Visualize the walker walking down a slope. May need to edit
% depending on the model.
%
% INPUT: 
% + xcycle = vector of the states at each integration step. See walk3.
%
% OUTPUT:
% + status = 1 if successful (usually is) and 0 otherwise. This feature
%   will change in the future, to pass out a handle/pointer to an avi/mpg
%   object.
%
% Original code of the UC Berkeley CHESS Bipeds research group.
% http://chess.eecs.berkeley.edu/bipeds
% Please direct bug reports and related inquiries to Eric Wendel, 
% ericdbw@berkeley.edu.
%

global w L slope modeldir wd

status = 0;
if nargin == 1
    style = 'xor';
end

% if strcmp(modeldir, 'C:\Documents and Settings\Eric Wendel\My Documents\research\dev\3D/pointfoot-midlegmass/controlled/nohip') ~= 1
if 1 == 0
    fprintf(1, 'The animation script currently only works for option 3.\n');
else

% Parse input
t = xcycle(:,1);
stance = xcycle(:,2);
nstance = xcycle(:,3);
% roll = xcycle(:,4);

% Translate the angles into locations in 3D Cartesian space
vect = [0 0 L]'; % The vector in the non/stance leg reference frames
Rs = zeros(3, 3);
Rns = zeros(3, 3);
Rr = eye(3, 3);
stanceleg = zeros(3, size(t,1));
nstanceleg = zeros(3, size(t,1));
impactpt = zeros(3, size(t,1));
j = 1;
for i=1:size(t,1)    
    % The following rotation matrices are from leg ref frame to world frame
    Rs = [1 0              0              
          0 cos(stance(i)) -sin(stance(i))
          0 sin(stance(i)) cos(stance(i))];
    Rns = [1 0                 0                 
           0 cos(nstance(i)) sin(nstance(i))
           0 sin(nstance(i)) -cos(nstance(i))];
%     Rr = [cos(roll(i))  0 sin(roll(i))
%           0             1 0
%           -sin(roll(i)) 0 cos(roll(i))];

    % Make sure the robot actually moves forward by saving the point of
    % impact with the ground.
    if i > 2
        if t(i) == t(i-1)
            impactpt(:,i) = nstanceleg(:,i-1);
            adjust(j) = i;
            j = j + 1;
        else
            impactpt(:,i) = impactpt(:,i-1);
        end
    end

    % Assemble points using rigid-body kinematics 
    stanceleg(:,i) = impactpt(:,i) + Rr*(Rs*vect);
    nstanceleg(:,i) = stanceleg(:,i) + Rr*(Rns*vect);
end

% Assemble the robot
sx = [impactpt(1,:)' stanceleg(1,:)'];
sy = [impactpt(2,:)' stanceleg(2,:)'];
sz = [impactpt(3,:)' stanceleg(3,:)'];
nsx = [stanceleg(1,:)' nstanceleg(1,:)'];
nsy = [stanceleg(2,:)' nstanceleg(2,:)'];
nsz = [stanceleg(3,:)' nstanceleg(3,:)'];
groundx = [nstanceleg(1,:)' impactpt(1,:)'];
groundy = [nstanceleg(2,:)' impactpt(2,:)'];
groundz = [nstanceleg(3,:)' impactpt(3,:)'];

% Create figure
screenSize = get(0, 'ScreenSize');
width = screenSize(3)/2;
xpos = screenSize(3)/4;
ypos = screenSize(4)/4;
height = screenSize(4)/3;
figure('Position', [xpos ypos width height])

% Create graphics objects
sleg = line(sx(1,:), sy(1,:), sz(1,:), 'EraseMode', style, 'Marker', '.', 'Color', 'b');
nsleg = line(nsx(1,:), nsy(1,:), nsz(1,:), 'EraseMode', style, 'Marker', '.', 'Color', [0 .5 0]);
ground = line(groundx(1,:), groundy(1,:), groundz(1,:), 'EraseMode', 'none', 'Marker', '.', 'Color', 'k');

% Adjust axes
xmin = min(groundx(i,:)) - 1; xmax = norm(groundx);
ymin = min(nsy(i,:)) - 2; ymax = norm(nsy(i,:)) + 2;
zmin = min(sz(i,:))-.1; zmax = norm(sz(i,:)) + .2;
axis([ xmin xmax ymin ymax zmin zmax ])
axis fill

% Set the 3D viewpoint
if strcmp(modeldir(size(wd,2)-1:size(wd,2)), '2D')
    view([-90 0])
elseif strcmp(modeldir(size(wd,2)-1:size(wd,2)), '3D')
    view([45 -30])
end

% Draw
xlabel('x')
ylabel('y')
zlabel('z')
for i=2:size(t,1)
    % Adjust axes on impact
    if length(find(adjust == i)) ~= 0
        set(ground, 'XData', groundx(i,:), 'YData', groundy(i,:), 'ZData', groundz(i,:))
        xmin = min(groundx(i,:)) - 1; xmax = norm(groundx(i,:)) + 5;
        ymin = min(nsy(i,:)) - 2; ymax = norm(nsy(i,:)) + 2;
        axis([ xmin xmax ymin ymax zmin zmax ])
        axis fill
    end
%     azi = linspace(30, -30, size(t,1));
%     el = linspace(-25, 25, size(t,1));
%     view([azi(i) el(i)])
    set(sleg, 'XData', sx(i,:), 'YData', sy(i,:), 'ZData', sz(i,:))
    set(nsleg, 'XData', nsx(i,:), 'YData', nsy(i,:), 'ZData', nsz(i,:))
    drawnow
end

end