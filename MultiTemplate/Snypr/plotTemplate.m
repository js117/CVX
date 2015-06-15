% m x n matrix
% m timestamps/rows, n=6 columns (ax, ay, az, gx, gy, gz)
function plotTemplate(T,accMax,gyroMax)
    figure;plot(1:length(T),T(:,1)/accMax,1:length(T),T(:,2)/accMax,1:length(T),T(:,3)/accMax,1:length(T),T(:,4)/gyroMax,1:length(T),T(:,5)/gyroMax,1:length(T),T(:,6)/gyroMax);
end