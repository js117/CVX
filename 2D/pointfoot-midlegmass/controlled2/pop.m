
%
% Just an easy way to get those default variables out.

global M Mp g L slope dim alpha mu

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
    mu = 0
    xi = [.01+(alpha-slope) 0+(alpha-slope) -.43 2.23 0.1]