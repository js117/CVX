% Returns the 4 possible inverse kinematic solutions of the Nao RH
% each thetasi is a vector of joint angles, [t1_i, t2_i, t3_i, t4_i, t5_i]
function [thetas1, thetas2, thetas3, thetas4] = InverseKinRH_PoE(target)

    shoulderOffsetY = 0.098;%98/1000;
    elbowOffsetY = 0.015;%15/1000;
    upperArmLength = 0.105;%105/1000;
    shoulderOffsetZ = 0.100;%;100/1000;
    HandOffsetX = 0.05775;%57.75/1000;
    HandOffsetZ = 0.01231;%12.31/1000;
    LowerArmLength = 0.05595;%55.95/1000;

    y1 = -shoulderOffsetY;
    z1 = shoulderOffsetZ;
    x2 = upperArmLength; 
    y2 = -elbowOffsetY;
    x3 = LowerArmLength;
    x4 = HandOffsetX;
    z4 = -HandOffsetZ;
    
    % The following definitions were used to build twist axis 
    % e_i = { -q_i x w_i; w_i }
    %
    %     w1 = [0,1,0]'; q1 = [0,y1,z1]';
    %     w2 = [0,0,1]'; q2 = [0,y1,z1]';
    %     w3 = [1,0,0]'; q3 = [x2,y1+y2,z1]';
    %     w4 = [0,0,1]'; q4 = [x2,y1+y2,z1]';
    %     w5 = [1,0,0]'; q5 = [x2+x3,y1+y2,z1]';
    %
    % For theta=0 matrix, we have 
    % g_st_0 = [I(3,3), p0; 0(1,3), 1]
    % with p0 = [x2+x3+x4, y1+y2, z1+z4]'
    
    e1 = [-0.1,0,0,0,1,0]';
    e2 = [-0.098,0,0,0,0,1]';
    e3 = [0,0.1,0.113,1,0,0]';
    e4 = [-0.113,-0.105,0,0,0,1]';
    e5 = [0,0.1,0.113,1,0,0]';         

    p0 = [0.2187, -0.1130, 0.0877]';
    g_st_0 = [eye(3), p0; zeros(1,3), 1];
    
    % Convert target (px,py,pz,rx,ry,rz) to matrix equivalent:
    px = target(1); py = target(2); pz = target(3);
    rx = target(4); ry = target(5); rz = target(6);
    gd = RotXYZMatrix(0,0,rz)*RotXYZMatrix(0,ry,0)*RotXYZMatrix(rx,0,0); %e.g. R(ZYX) yaw/pitch/roll representation
    
    %[px, py, pz]
    
    gd(1:3,4) = [px,py,pz]';
    
    % Solving IK: define "special points" and solve subproblems. 
    g1 = gd*inv(g_st_0);
    
    p_e = [x2, y1+y2, z1, 1]'; % q3/q4, i.e. intersection of twist axes 3,4,5
    right = g1*p_e; right = right(1:3);
    r1 = [0,y1,z1]'; %r1 needs to be intersection of w1 and w2, which happens to be q1/q2
    [t11, t21, t12, t22] = SolveSubproblem2(e1, e2, p_e, right, r1);
    
    % Now have have two possible solutions for t1, t2. For each pair
    % (t11,t21) and (t12,t22), solve for the t3's, t4's
    
    p34 = [x2+x3, y1+y2, z1, 1]';
    right3 = exp_twist_theta_revolute(-e2,t21)*exp_twist_theta_revolute(-e1,t11)*g1*p34; right3 = right3(1:3);
    right4 = exp_twist_theta_revolute(-e2,t22)*exp_twist_theta_revolute(-e1,t12)*g1*p34; right4 = right4(1:3);
    
    r34 = p_e; % is a common intersection point for e3, e4
    [t31, t41, t32, t42] = SolveSubproblem2(e3, e4, p34, right3, r34);
    [t33, t43, t34, t44] = SolveSubproblem2(e3, e4, p34, right4, r34);
    
    % Now we have 4 solution pairs for (t1, t2, t3, t4):
    % [t11,t21,t31,t41] / [t11,t21,t32,t42] / [t12,t22,t33,t43] / [t12,t22,t34,t44]
    % For each of these tuples, we find t5(1,2,3,4), and return our 4
    % solutions
    
    p5 = p_e + 0.5*[0,1,1,1]'; % we need any point NOT on w5=[1,0,0]'
    
    right51 = exp_twist_theta_revolute(-e4,t41)*exp_twist_theta_revolute(-e3,t31)*exp_twist_theta_revolute(-e2,t21)*exp_twist_theta_revolute(-e1,t11)*g1*p5;
    right51 = right51(1:3);
    right52 = exp_twist_theta_revolute(-e4,t42)*exp_twist_theta_revolute(-e3,t32)*exp_twist_theta_revolute(-e2,t21)*exp_twist_theta_revolute(-e1,t11)*g1*p5;
    right52 = right52(1:3);
    right53 = exp_twist_theta_revolute(-e4,t43)*exp_twist_theta_revolute(-e3,t33)*exp_twist_theta_revolute(-e2,t22)*exp_twist_theta_revolute(-e1,t12)*g1*p5;
    right53 = right53(1:3);
    right54 = exp_twist_theta_revolute(-e4,t44)*exp_twist_theta_revolute(-e3,t34)*exp_twist_theta_revolute(-e2,t22)*exp_twist_theta_revolute(-e1,t12)*g1*p5;
    right54 = right54(1:3);
    
    r5 = r34; % also happens to be on axis of w5
    t51 = SolveSubproblem1(e5, p5, right51, r5);
    t52 = SolveSubproblem1(e5, p5, right52, r5);
    t53 = SolveSubproblem1(e5, p5, right53, r5);
    t54 = SolveSubproblem1(e5, p5, right54, r5);
    
    % Return possible solutions: 
    thetas1 = [t11,t21,t31,t41,t51]';
    thetas2 = [t11,t21,t32,t42,t52]';
    thetas3 = [t12,t22,t33,t43,t53]';
    thetas4 = [t12,t22,t34,t44,t54]';

end