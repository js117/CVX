
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gap = 1 / 10;
res = -pi / 4000;
k_min = 1.3; k_max = 1.3;
slope_min = pi/45; slope_max = slope_min;
gamma_min = 0; gamma_max = gamma_min;
% slope_min = 0.03839724354388+res; slope_max = 0.00698131700798-res;
r_min = .01; r_max = r_min; % r_min = .01; r_max = .5;
s_min = 0; s_max = pi/3;
% s_min = -pi/10; s_max = pi/10;
ns_min = 0; ns_max = pi/3;
% ns_min = -pi/10; ns_max = pi/10;
sdot_min = -1.5; sdot_max = 1.5;
% sdot_min = -.01; sdot_max = .01;
nsdot_min = -1.5; nsdot_max = 1.5;
% nsdot_min = -.01; nsdot_max = .01;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpha = pi/45

XFix = [];
points = 1;
leave = 0;
for slope = slope_min : res : slope_max
    for gamma = gamma_min : gap*pi : gamma_max
        for R = r_min : gap : r_max
            for s = s_min : gap*pi : s_max
                for ns = ns_min : gap*pi : ns_max
                    for sdot = sdot_min : gap : sdot_max
                        for nsdot = nsdot_min : gap : nsdot_max
                            xguess = [s ns sdot nsdot];
                            [xfix converged] = search2(xguess);
                            if converged
                                if length(R) ~= 0
                                    XFix = [XFix ; slope R xfix]
                                else
                                    XFix = [XFix ; slope xfix]
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

% Make a movie of the walking
% fig = figure;
% set(fig, 'DoubleBuffer', 'on');
% rollfeet = avifile('rollfeet.avi')
% rollfeet.Quality = 100;
% for i=1:length(XFix)
%     slope = XFix(i, 1);
%     titleString = sprintf('slope = %g, xi = [%g %g %g %g]', slope, XFix(i, 2:end));
%     title(titleString)
%     walk2(XFix(i, 2:end), 6, 2);
%     roboto_san(i) = getframe;
%     rollfeet = addframe(rollfeet, roboto_san);
% end
% rollfeet = close(rollfeet);

