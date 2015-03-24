

deg = pi/180;

% NAO constants (in mm)
NeckOffsetZ = 126.50/100;
ShoulderOffsetY = 98.00/100;
ElbowOffsetY = 15.00/100;
UpperArmLength = 105.00/100;
LowerArmLength = 55.95/100;
ShoulderOffsetZ = 100.00/100;
HandOffsetX = 57.75/100;
HipOffsetZ = 85.00/100;
HipOffsetY = 50.00/100;
ThighLength = 100.00/100;
TibiaLength = 102.90/100;
FootHeight = 45.19/100;
HandOffsetZ = 12.31/100;

NaoRH = SerialLink( [
    Revolute('d', 0, 'alpha', -pi/2, 'a', 0, 'modified')
    Revolute('d', 0, 'alpha', pi/2,  'a', 0, 'offset', pi/2, 'modified')
    Revolute('d', -UpperArmLength, 'alpha', -pi/2, 'a', 0, 'modified')
    Revolute('d', 0, 'alpha', pi/2,  'a', 0, 'modified')
    ], ...
    'base', transl(0, -ShoulderOffsetY-ElbowOffsetY, ShoulderOffsetZ), ...
    'tool', trotz(pi/2)*transl(-HandOffsetX-LowerArmLength, 0, 0)*trotz(-pi), ...
    'plotopt', plotopts, ...
    'name', 'right arm', 'manufacturer', 'Aldabaran');


q = [0, 0, 0, 0];

subplot(3,1,1); plot(q(:,1)); xlabel('Time (s)'); ylabel('Joint 1 (rad)');
subplot(3,1,2); plot(q(:,2)); xlabel('Time (s)'); ylabel('Joint 2 (rad)');
subplot(3,1,3); plot(q(:,3)); xlabel('Time (s)'); ylabel('Joint 3 (rad)');

% This joint space trajectory can now be animated
clf
NaoRH.plot(q, 'workspace', 3*[-1 1 -1 1 -1 1]);
