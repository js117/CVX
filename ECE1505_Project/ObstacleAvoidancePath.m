% Generate X-Y-Z constraints based on avoiding a single obstacle in the Y-Z
% plane. Obstacle is a sphere (circ in y-z plane) symmetric about its origin
% point p_yz.
%
% The generated path follows a very simple scheme (meant for the right
% arm): we bound the box, clear the distance outwards (y, to the right
%
% Assume (without loss of generality in application setting) that the 
% given obstacle to this function is not in contact with (y_init, z_init),
% because we would have seen it coming earlier and tried to take evasive
% action, or even stop. 
% ex: sphere [1.5;-0.4;1.2;] radius 0.8
% 
% Note that moving to the right is moving in the negative-y direction for 
% the robot in this project. 
function [Uz, Lz, Uy, Ly] = ObstacleAvoidancePath(y_init, z_init, theta_linspace, p_xyz, radius)
    % Definitions for the particular robot arm
    Y_MAX = 3;
    Y_MIN = -3;
    Z_MAX = 3;
    Z_MIN = -3;

    T = size(theta_linspace,2);
    
    % We start with the end-effector either completely above or 
    % completely below the obstacle. In either case, Y unconstrained:
    Uy_phase1 = Y_MAX;
    Ly_phase1 = Y_MIN;
    % Now constrain Z depending on start position:
    if (z_init > (p_xyz(3) + radius)) % starting above obst.
        Uz_phase1 = Z_MAX;
        Lz_phase1 = p_xyz(3) + radius;
    end
    if (z_init < (p_xyz(3) - radius)) % starting below obst.
        Uz_phase1 = p_xyz(3) - radius;
        Lz_phase1 = Z_MIN;
    end
    if (abs(z_init - p_xyz(3)) < radius) % uh oh
        disp('Error: end-effector already in contact with obstacle');
        Uz = 0; Lz = 0; Uy = 0; Ly = 0;
        return;
    end
    
    % Phase 2: we're either on the left or RIGHT of obs. Constrain Y
    % as we go up/down
    Uz_phase2 = Z_MAX;
    Lz_phase2 = Z_MIN;
    % Assuming we aim to go outside on the right:
    Uy_phase2 = p_xyz(2) - radius;
    Ly_phase2 = Y_MIN;
    
    % Phase 3: Constrain Z again, let Y be free, so we move sideways
    % to the target. Again, 2 cases based off initial position:
    Uy_phase3 = Y_MAX;
    Ly_phase3 = Y_MIN;
    if (z_init > (p_xyz(3) + radius)) % starting above obst.
        % And now we need to stay below obst
        Uz_phase3 = p_xyz(3) - radius;
        Lz_phase3 = Z_MIN;
    end
    if (z_init < (p_xyz(3) - radius)) % starting below obst.
        % And now we need to stay above obst
        Uz_phase3 = Z_MAX;
        Lz_phase3 = p_xyz(3) + radius;
    end
    if (abs(z_init - p_xyz(3)) < radius) % uh oh
        disp('Error: end-effector already in contact with obstacle');
        Uz = 0; Lz = 0; Uy = 0; Ly = 0;
        return;
    end
    
    % Put the path approximate path together. For simplicity, split up
    % into equal 1/3rds of time length. In general we can reinterpret
    % our solution to the 3 phases by stretching (interpolating) or
    % compressing them to re-scale. 
    Uz = zeros(T,1); Lz = zeros(T,1); Uy = zeros(T,1); Ly = zeros(T,1);
    for i=1:round(T/3)
        Uz(i) = Uz_phase1;
        Lz(i) = Lz_phase1;
        Uy(i) = Uy_phase1;
        Ly(i) = Ly_phase1;
    end
    for i=round(T/3)+1:round(2*T/3)
        Uz(i) = Uz_phase2;
        Lz(i) = Lz_phase2;
        Uy(i) = Uy_phase2;
        Ly(i) = Ly_phase2;
    end
    for i=round(2*T/3)+1:T
        Uz(i) = Uz_phase3;
        Lz(i) = Lz_phase3;
        Uy(i) = Uy_phase3;
        Ly(i) = Ly_phase3;
    end

end
