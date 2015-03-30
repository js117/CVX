% Obstacle 1: Cylinder
obs{1}.R = 0.1;
obs{1}.c = [0.5927; 0.0514; 2.5731];
obs{1}.rho0 = 0;
obs{1}.type = 'sph';
% Obstacle 2: Cylinder
obs{2}.R = 0;
obs{2}.c = [-0.2;-0.8];
obs{2}.rho0 = 1/4;
obs{2}.h = 0;
obs{2}.type = 'cyl';
% % Obstacle 3: Sphere %% THIS IS THE ACTUAL OBSTACLE WE'RE USING
obs{3}.R = 1;
obs{3}.c = [1;-0.1;1;];
obs{3}.rho0 = 0;
obs{3}.type = 'sph';
% % Obstacle 4: Sphere
% obs{4}.R = 1/16;
% obs{4}.c = [-0.2;-0.2;1.1;];
% obs{4}.rho0 = 1/4;
% obs{4}.type = 'sph';
% % Obstacle 5: Sphere
% obs{5}.R = 1/16;
% obs{5}.c = [0.1;0.1;0.5;];
% obs{5}.rho0 = 1/4;
% obs{5}.type = 'sph';
% % Obstacle 6: Sphere
% obs{6}.R = 1/16;
% obs{6}.c = [-0.1;-0.1;0.5;];
% obs{6}.rho0 = 1/4;
% obs{6}.type = 'sph';