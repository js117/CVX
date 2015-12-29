
%
% Just an easy way to get those default variables out.

global M Mp g L slope dim alpha c mu

% xi = [ S NS Sdot NSdot ];

% pointfoot-midlegmass\passive\angcons\pop
    M = 5
    Mp = 10
    g = 9.8
    L = 1
%     dim = 4
    
    % Controlled symmetries (Bullo)
%     slope = 0
%     alpha = pi/50  % A slope that we know leads to stable walking for the xi below.
%     gamma = 0      % Any desired slope, but we want flat-ground walking.
%     xi = [.01+(alpha-slope) 0+(alpha-slope) -.43 2.23]
%     xi = [.01 0 -.43 2.23]

    % Nonlinear control
    dim = 5
    slope = 0
    alpha = pi/50
    c = 8
    mu = 0
%     xi = [-0.28837554101423+(alpha-slope)   0.28837554101421+(alpha-slope)  -1.60106756456786  -1.97493565192215   .2]
%     xi = [.01+(alpha    -slope) 0+(alpha-slope) -.43 2.23 0.2]
%     xi = [  -0.28837554101423   0.28837554101421  -1.60106756456786  -1.97493565192215   0.00000000000002]
%     xi = out2(end-1)
%     xi = [  -0.28835512700040   0.28835512700038  -1.60086713450182  -1.97621192360482   0.00000006550260 ]
    xi = [-.2884 .2884 -1.6009 -1.9762 -.2]