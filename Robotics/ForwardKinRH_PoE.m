function g = ForwardKinRH_PoE(thetas)

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
    
    t1 = thetas(1); t2 = thetas(2); t3 = thetas(3); t4 = thetas(4); t5 = thetas(5); 
    M1 = exp_twist_theta_revolute(e1,t1);
    M2 = exp_twist_theta_revolute(e2,t2);
    M3 = exp_twist_theta_revolute(e3,t3);
    M4 = exp_twist_theta_revolute(e4,t4);
    M5 = exp_twist_theta_revolute(e5,t5);
    
    g = M1*M2*M3*M4*M5*g_st_0;
    
end