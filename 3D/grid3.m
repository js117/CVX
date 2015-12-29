
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gap = 1 / 10;
res = -pi / 2000;
% k_min = 1.3; k_max = 1.3;
slope_min = pi/60; slope_max = 0;
% slope_min = 0.03839724354388+res; slope_max = 0.00698131700798-res;
s_min = 0; s_max = pi/2;
% s_min = -pi/10; s_max = pi/10;
ns_min = 0; ns_max = pi/2;
% ns_min = -pi/10; ns_max = pi/10;
sdot_min = -2; sdot_max = 2;
% sdot_min = -.01; sdot_max = .01;
nsdot_min = -2; nsdot_max = 2;
% nsdot_min = -.01; nsdot_max = .01;
p_min = -pi/45; p_max = pi/45;
pdot_min = -2; pdot_max = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

XFix = [];
for slope = slope_min : res : slope_max
    for p = p_min : gap*pi : p_max
        for s = s_min : gap*pi : s_max
            for ns = ns_min : gap*pi : ns_max
                for pdot = pdot_min : gap : pdot_max
                    for sdot = sdot_min : gap : sdot_max
                        for nsdot = nsdot_min : gap : nsdot_max
                            xguess = [p s ns pdot sdot nsdot];
                            [slope xguess]
                            [xfix converged] = search3(xguess);
                            if converged == 1
                                XFix = [XFix ; slope xfix]
                                save 3dnohip.mat XFix
                            elseif length(converged) == 0
                                fprintf('grid3 error:   Something went wrong with the logic in search3.\n');
                                return  
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

