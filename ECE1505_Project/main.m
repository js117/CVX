% Force Trajectory Design for Inverted Pendulum with Partially Observed
% State

% Dynamics derivation from here: http://ctms.engin.umich.edu/CTMS/index.php?example=InvertedPendulum&section=SystemModeling

% All in SI units:
M = 5; % mass of base cart
m = 3; % mass of upper portion of pendulum
b = 0.1; % F = -b*x_dot is friction coeff
I = 0.1; % inertia 
g = 9.8; % gravity
l = 0.5; % length from center of base cart to center of mass, along pend.

% Composite variables and state space model:
p = I*(M+m)+M*m*l^2; %denominator for the A and B matrices

A = [0      1              0           0;
     0 -(I+m*l^2)*b/p  (m^2*g*l^2)/p   0;
     0      0              0           1;
     0 -(m*l*b)/p       m*g*l*(M+m)/p  0];
B = [     0;
     (I+m*l^2)/p;
          0;
        m*l/p];
C =  [0 0 1 0]; % modified - we only measure the angle deviation from equilibrium
D = 0; 

% for STATE = [x, x_dot, phi, phi_dot]';

% Create discrete model:
T = 0.02; % e.g. 20ms discrete time intervals
Ad = expm(A*T);
Bd = inv(A)*(expm(A*T) - 1); % for A nonsingular

%%%%%%%%%%%%%% Simulations %%%%%%%%%%%%%%%%%%%

% 1. Move forward a distance D from rest: 
z0 = [0, 0, 0, 0]';
D = 0.1; % go 10cm forward
zN = [D, 0, 0, 0];








