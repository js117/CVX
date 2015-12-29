
load rollfeetFixedPoints.mat


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gap = 1 / 100;
% res = -pi / 4000;
% k_min = 1.3; k_max = 1.3;
% slope_min = pi/45; slope_max = 0;
% % slope_min = 0.03839724354388+res; slope_max = 0.00698131700798-res;
% s_min = 0; s_max = pi/2;
% ns_min = 0; ns_max = pi/2;
% sdot_min = -2; sdot_max = 2;
% nsdot_min = -2; nsdot_max = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gap = 1 / 100;
res = -pi / 4000;
s_min = -pi/5; s_max = pi/5;
ns_min = -pi/5; ns_max = pi/5;s
sdot_min = -1; sdot_max = 1;
nsdot_min = -1; nsdot_max = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

XFixed = [];
XGuess = [];
params = [s_min gap*pi s_max
          ns_min gap*pi ns_max
          sdot_min gap sdot_max
          nsdot_min gap nsdot_max];
for row = 1:length(XFix)
    for i = 1:4
        x_min = params(i, 1);
        dist = params(i, 2);
        x_max = params(i, 3);
        for x = x_min : dist : x_max
            perturb = zeros(1,4);
            perturb(i) = x;
            xguess = XFix(row, 2:end) + perturb;
            slope = XFix(row, 1);
            [xfix converged] = search2(xguess);
            if converged
                XGuess = [XGuess ; xguess];
                XFixed = [XFixed ; XFix(row, :)];
            end
        end
    end
end
        
    