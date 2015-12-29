


%velocities [-1,1]
%anles [0,pi]


XFix = [];
xguess = [0.2291   -0.3687   -1.1393   -0.2163]
% for s = 0:pi/4000:pi/30
for s = pi/45:-pi/4000:0

slope = s
n = 2
pgap = pi/(n)
for i = 0:pgap:pi/2
    for j = 0:-pgap:-pi/2
        for k = -2:1/(n):1
            for l = -2:1/(n):1
                [slope, xguess]
                [xfix,co] = search2(xguess);
                xguess = [i, j , k, l];
                if co == 1
                    XFix = [XFix; slope, xfix];
                    close all
                    walkgraph(xfix,20)
                    slope = slope -pi/4000
                    xguess = xfix
                end
                XFix
            end
        end
    end
end

end


for p = 1:length(XFix(:,1))
    slope = XFix(p,1)
    xftest = XFix(p,2:5)
    walkgraph(xftest,20)
    pause
    close all
end
