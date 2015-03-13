% cosTestSetup

k = 4; % pi limits
[X,Y] = meshgrid(-k*pi:0.05:k*pi); 

a1 = 1; % convention: sort (and divide) such that a1 == 1
a2 = 0.5;
Zcos = a1*cos(X) + a2*cos(Y);

Z = zeros(size(Z));

for i=1:size(Z,1)
    for j = 1:size(Z,2)
        x = X(i,j);
        y = Y(i,j);
        if abs((a1+a2)/a1*x) + abs(a2*y) <= pi
            Z(i,j) = 1;
        end
    end
end

figure; 
mesh(X,Y,Z);