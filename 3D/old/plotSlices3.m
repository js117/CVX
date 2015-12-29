
XFix = XFixed(1:200,:);

vectorLength = length(XFix(:,1));


for i=1:vectorLength
    xNaught = XFix(i, 2:end);
    slope = XFix(i, 1);
    [xlast xcycle] = walk2(xNaught, 1, false);
    if length(xcycle) == 0 
        continue
    end
    subplot(1,2,1)
    hold on
    plot3(xcycle(:,1), xcycle(:,3), slope*ones(length(xcycle(:,1))))
    subplot(1,2,2)
    hold on
    plot3(xcycle(:,2), xcycle(:,4), slope*ones(length(xcycle(:,1))))
end
    

xlabel('NS')
ylabel('NSdot')
zlabel('Slope')