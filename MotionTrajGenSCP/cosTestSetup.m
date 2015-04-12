% cosTestSetup

k = 2; % pi limits
[X,Y] = meshgrid(-k*pi:0.08:k*pi); 

a1 = 1; % convention: sort (and divide) such that a1 == 1
a2 = 0.5;
d = 0; % sum(coses) >= d
Z = a1*cos(X) + a2*sin(Y);

Zpos = Z;
Zpos_orig = cos(X) + cos(Y); % compare to (1,1) solution

Z_pnorm_approx = zeros(size(Z));
p = max([a1, a2]) / min([a1,a2]);
lim = pi;

lim_x = a1/(a1+a2) * pi;
lim_y = a1 * pi;

for i=1:size(Z,1)
    for j = 1:size(Z,2)
        if Zpos(i,j) > d
            Zpos(i,j)= 1;
        else
            Zpos(i,j) = 0;
        end
        if Zpos_orig(i,j) < 0
            Zpos_orig(i,j) = 0;
        else
            Zpos_orig(i,j) = 1; 
        end
        % try making approximate convex set mask:
        powy = a1;
        powx = (a1 + a2) / a2;
        pnorm_point = (a1*abs(X(i,j))^p + abs(a2*Y(i,j))^p)^(1/p);
        p_x = abs(X(i,j));
        p_y = abs(Y(i,j));
        if (pnorm_point < lim)
            Z_pnorm_approx(i,j) = 1;
        end
        
    end
end

figure; 
mesh(X,Y,Zpos);
%figure;
%mesh(X,Y,Z_pnorm_approx);