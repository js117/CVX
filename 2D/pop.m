
%
% Just an easy way to get those default variables out.  

if exist('modeldir') == 0
%     global M Mp g L R K alpha slope eqnhandle modeldir dim wd
    global M Mp g L R K alpha slope eqnhandle modeldir wd dim invalidResults
    [modeldir wd] = set2;
end
run(strcat(modeldir, '/pop'))

% xi = [ S NS Sdot NSdot ];

% % Goswami
% if option == 1
%     M = 5
%     Mp = 10
%     g = 9.8
%     L = 1
%     R = 0
%     K = 0
%     slope = pi/50-1E-6
%     dim = 4
%     xi = [.01 0 -.43 2.23]
% elseif option == 2

%     g = 9.8
% Roll-feet
%     M = 2.5
%     Mp = 5
%     L = 1
%     R = .1;
%     dim = 4
%     slope = 0.00698131700798
%     xi = [0.00556137646600   0.00960849133013   0.01173207581952   0.01407672551396]
%     xi = [0.05583000315134   0.09619054554064   0.11673187107259   0.13917209394136]
%     xi = [0.05583000315134   0.09619054554063   0.11673187107254   0.13917209394130]

% Model of interest    
%     M = 2.5
%     Mp = 5
%     g = 9.8
%     L = 1
%     dim = 4
%     K0 = g*(M+Mp)
%     K = K0
%     slope = 0
%     xi = [0 0 -.6 1]