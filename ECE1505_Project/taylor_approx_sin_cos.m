% plot 2nd-order taylor approx to sinx:

n=1000;
t=1:n;
sinx = zeros(n,1);
cosx = zeros(n,1);
sinxTaylor2 = zeros(n,1);
cosxTaylor2 = zeros(n,1);

theta0 = pi/4;

for i=1:n
    theta = (i/n) * 2*pi - pi;
    sinx(i) = sin(theta);
    cosx(i) = cos(theta);
    
    sa = sin(theta0) - theta0*cos(theta0) - 0.5*theta0*theta0*sin(theta0);
    sb = cos(theta0) + theta0*sin(theta0);
    sc = -0.5*sin(theta0);
    
    ca = cos(theta0) + theta0*sin(theta0) - 0.5*theta0*theta0*cos(theta0);
    cb = -sin(theta0) + theta0*cos(theta0);
    cc = -0.5*cos(theta0);
    
    sinxTaylor2(i) = sa + sb*theta; % + sc*theta*theta;
    cosxTaylor2(i) = ca + cb*theta; % + cc*theta*theta;
end

figure; plot(sinx); figure; plot(sinxTaylor2);