% Testing "Log Map Product of Exponentials" inverse kin solution

% Returns the 4 possible inverse kinematic solutions of the Nao RH
% each thetasi is a vector of joint angles, [t1_i, t2_i, t3_i, t4_i, t5_i]
function [thetas] = InverseKinRH_LogMapPoE(target)

    thetas = zeros(5,9); % will return 5 possible solutions, 1 per column

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
    g1 = gd*inv(g_st_0);
    
    % Limits on the joint angles
    Xmax = [2.0857, 0.3142, 2.0857, 1.5446, 1.8238]';
    Xmin = [-2.0857, -1.3265, -2.0857, 0.0349, -1.8238]';
    
    % From the equation:
    % exp(E1hat*t1)*exp(E2hat*t2)*exp(E3hat*t3)*exp(E4hat*t4)*exp(E5hat*t5)= g1
    % We take the log map of both sides, yielding the following:
    % E1hat*t1 + E2hat*t2 + E3hat*t3 + E4hat*t4 + E5hat*t5 = logMap(g1)
    % Which is a really-easy-to-solve Ax=b equation. In fact we can get
    % interesting variants on solutions via norm minimization ||Ax - b||,
    % some of which may be better numerically conditioned.
    %
    % Regarding multiple solutions, we note that logMap(g1) is not unique
    % for the SE(3) group; for log[R,p;0,1] we need to compute log(R)
    % given by 2cos(t)+1 = tr(R) and what = 1/(2sin(t))*(R-R'). The
    % multiple solutions for cost = #, # +/- 2*pi*k, so we arccos the #
    % with a few surrounding +/-2*pi*k solutions (how many? e.g. 2 on each side)
    
    Acol1 = wedge(e1); %Acol1 = Acol1(:);
    Acol2 = wedge(e2); %Acol2 = Acol2(:);
    Acol3 = wedge(e3); %Acol3 = Acol3(:);
    Acol4 = wedge(e4); %Acol4 = Acol4(:);
    Acol5 = wedge(e5); %Acol5 = Acol5(:);
    %A = [Acol1, Acol2, Acol3, Acol4, Acol5];
    
    Acol1
    Acol2
    Acol3
    Acol4
    Acol5
    
    %for k=-4:4
    k = 0;
        
        b = logMap(g1, k); 
        %b = b(:);
        
        cvx_begin
            variable x(5); %thetas
            minimize norm(Acol1*x(1) + Acol2*x(2) + Acol3*x(3) + Acol4*x(4) + Acol5*x(5) - b, 1)
            subject to 
                Xmin <= x <= Xmax;
                
        cvx_end      
        
        thetas(:,k+5) = x;
        
        Acol1
        b
        x
        
    %end
    
    
end