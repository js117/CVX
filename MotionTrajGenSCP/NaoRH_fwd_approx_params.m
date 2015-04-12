% These are the forward kinematics functions from the NaoRH
function [Hcvx_px, Hccv_px, g_px, Hcvx_py, Hccv_py, g_py, Hcvx_pz, Hccv_pz, g_pz ] = NaoRH_fwd_approx_params(thetas)

    shoulderOffsetY = 0.098*10;%98/1000;
    elbowOffsetY = 0.015*10;%15/1000;
    upperArmLength = 0.105*10;%105/1000;
    shoulderOffsetZ = 0.100*10;%;100/1000;
    HandOffsetX = 0.05775*10;%57.75/1000;
    HandOffsetZ = 0.01231*10;%12.31/1000;
    LowerArmLength = 0.05595*10;%55.95/1000;

    y1 = -shoulderOffsetY;
    z1 = shoulderOffsetZ;
    x2 = upperArmLength; 
    y2 = -elbowOffsetY;
    x3 = LowerArmLength;
    x4 = HandOffsetX;
    z4 = -HandOffsetZ;
    
    t1 = thetas(1); t2 = thetas(2); t3 = thetas(3); t4 = thetas(4); %t5 = 0; 

    % How to remove affect of t5: declare everything as syms, then:
    % px = subs(px, t5, 0)
    
    g_px =  [ - (21*cos(t2)*sin(t1))/20 - (1137*sin(t4)*(cos(t1)*sin(t3) - cos(t3)*sin(t1)*sin(t2)))/1000 - (1137*cos(t2)*cos(t4)*sin(t1))/1000
                     - (21*cos(t1)*sin(t2))/20 - (1137*cos(t1)*cos(t4)*sin(t2))/1000 - (1137*cos(t1)*cos(t2)*cos(t3)*sin(t4))/1000
                                                                  -(1137*sin(t4)*(cos(t3)*sin(t1) - cos(t1)*sin(t2)*sin(t3)))/1000
                           - (1137*cos(t4)*(sin(t1)*sin(t3) + cos(t1)*cos(t3)*sin(t2)))/1000 - (1137*cos(t1)*cos(t2)*sin(t4))/1000];
                       
    H_px = [[ (1137*sin(t4)*(sin(t1)*sin(t3) + cos(t1)*cos(t3)*sin(t2)))/1000 - (21*cos(t1)*cos(t2))/20 - (1137*cos(t1)*cos(t2)*cos(t4))/1000, (21*sin(t1)*sin(t2))/20 + (1137*cos(t4)*sin(t1)*sin(t2))/1000 + (1137*cos(t2)*cos(t3)*sin(t1)*sin(t4))/1000, -(1137*sin(t4)*(cos(t1)*cos(t3) + sin(t1)*sin(t2)*sin(t3)))/1000, (1137*cos(t2)*sin(t1)*sin(t4))/1000 - (1137*cos(t4)*(cos(t1)*sin(t3) - cos(t3)*sin(t1)*sin(t2)))/1000]
[                     (21*sin(t1)*sin(t2))/20 + (1137*cos(t4)*sin(t1)*sin(t2))/1000 + (1137*cos(t2)*cos(t3)*sin(t1)*sin(t4))/1000, (1137*cos(t1)*cos(t3)*sin(t2)*sin(t4))/1000 - (1137*cos(t1)*cos(t2)*cos(t4))/1000 - (21*cos(t1)*cos(t2))/20,                      (1137*cos(t1)*cos(t2)*sin(t3)*sin(t4))/1000,                     (1137*cos(t1)*sin(t2)*sin(t4))/1000 - (1137*cos(t1)*cos(t2)*cos(t3)*cos(t4))/1000]
[                                                                -(1137*sin(t4)*(cos(t1)*cos(t3) + sin(t1)*sin(t2)*sin(t3)))/1000,                                                                 (1137*cos(t1)*cos(t2)*sin(t3)*sin(t4))/1000,  (1137*sin(t4)*(sin(t1)*sin(t3) + cos(t1)*cos(t3)*sin(t2)))/1000,                                      -(1137*cos(t4)*(cos(t3)*sin(t1) - cos(t1)*sin(t2)*sin(t3)))/1000]
[                           (1137*cos(t2)*sin(t1)*sin(t4))/1000 - (1137*cos(t4)*(cos(t1)*sin(t3) - cos(t3)*sin(t1)*sin(t2)))/1000,                           (1137*cos(t1)*sin(t2)*sin(t4))/1000 - (1137*cos(t1)*cos(t2)*cos(t3)*cos(t4))/1000, -(1137*cos(t4)*(cos(t3)*sin(t1) - cos(t1)*sin(t2)*sin(t3)))/1000, (1137*sin(t4)*(sin(t1)*sin(t3) + cos(t1)*cos(t3)*sin(t2)))/1000 - (1137*cos(t1)*cos(t2)*cos(t4))/1000]
 ];       

    [Hcvx_px, Hccv_px] = ConvexConcaveDecompose(H_px);
    
    g_py = [                                                                                   0
 (21*cos(t2))/20 + (1137*cos(t2)*cos(t4))/1000 - (1137*cos(t3)*sin(t2)*sin(t4))/1000
                                                -(1137*cos(t2)*sin(t3)*sin(t4))/1000
                   (1137*cos(t2)*cos(t3)*cos(t4))/1000 - (1137*sin(t2)*sin(t4))/1000];
               
    H_py = [[ 0,                                                                                     0,                                    0,                                                                   0]
[ 0, - (21*sin(t2))/20 - (1137*cos(t4)*sin(t2))/1000 - (1137*cos(t2)*cos(t3)*sin(t4))/1000,  (1137*sin(t2)*sin(t3)*sin(t4))/1000, - (1137*cos(t2)*sin(t4))/1000 - (1137*cos(t3)*cos(t4)*sin(t2))/1000]
[ 0,                                                   (1137*sin(t2)*sin(t3)*sin(t4))/1000, -(1137*cos(t2)*cos(t3)*sin(t4))/1000,                                -(1137*cos(t2)*cos(t4)*sin(t3))/1000]
[ 0,                   - (1137*cos(t2)*sin(t4))/1000 - (1137*cos(t3)*cos(t4)*sin(t2))/1000, -(1137*cos(t2)*cos(t4)*sin(t3))/1000, - (1137*cos(t4)*sin(t2))/1000 - (1137*cos(t2)*cos(t3)*sin(t4))/1000]
 ];
    
    [Hcvx_py, Hccv_py] = ConvexConcaveDecompose(H_py);
    
    g_pz = [(1137*sin(t4)*(sin(t1)*sin(t3) + cos(t1)*cos(t3)*sin(t2)))/1000 - (21*cos(t1)*cos(t2))/20 - (1137*cos(t1)*cos(t2)*cos(t4))/1000
                     (21*sin(t1)*sin(t2))/20 + (1137*cos(t4)*sin(t1)*sin(t2))/1000 + (1137*cos(t2)*cos(t3)*sin(t1)*sin(t4))/1000
                                                                -(1137*sin(t4)*(cos(t1)*cos(t3) + sin(t1)*sin(t2)*sin(t3)))/1000
                           (1137*cos(t2)*sin(t1)*sin(t4))/1000 - (1137*cos(t4)*(cos(t1)*sin(t3) - cos(t3)*sin(t1)*sin(t2)))/1000
 ]; 

    H_pz = [[ (21*cos(t2)*sin(t1))/20 + (1137*sin(t4)*(cos(t1)*sin(t3) - cos(t3)*sin(t1)*sin(t2)))/1000 + (1137*cos(t2)*cos(t4)*sin(t1))/1000, (21*cos(t1)*sin(t2))/20 + (1137*cos(t1)*cos(t4)*sin(t2))/1000 + (1137*cos(t1)*cos(t2)*cos(t3)*sin(t4))/1000,  (1137*sin(t4)*(cos(t3)*sin(t1) - cos(t1)*sin(t2)*sin(t3)))/1000, (1137*cos(t4)*(sin(t1)*sin(t3) + cos(t1)*cos(t3)*sin(t2)))/1000 + (1137*cos(t1)*cos(t2)*sin(t4))/1000]
[                     (21*cos(t1)*sin(t2))/20 + (1137*cos(t1)*cos(t4)*sin(t2))/1000 + (1137*cos(t1)*cos(t2)*cos(t3)*sin(t4))/1000, (21*cos(t2)*sin(t1))/20 + (1137*cos(t2)*cos(t4)*sin(t1))/1000 - (1137*cos(t3)*sin(t1)*sin(t2)*sin(t4))/1000,                     -(1137*cos(t2)*sin(t1)*sin(t3)*sin(t4))/1000,                     (1137*cos(t2)*cos(t3)*cos(t4)*sin(t1))/1000 - (1137*sin(t1)*sin(t2)*sin(t4))/1000]
[                                                                 (1137*sin(t4)*(cos(t3)*sin(t1) - cos(t1)*sin(t2)*sin(t3)))/1000,                                                                -(1137*cos(t2)*sin(t1)*sin(t3)*sin(t4))/1000,  (1137*sin(t4)*(cos(t1)*sin(t3) - cos(t3)*sin(t1)*sin(t2)))/1000,                                      -(1137*cos(t4)*(cos(t1)*cos(t3) + sin(t1)*sin(t2)*sin(t3)))/1000]
[                           (1137*cos(t4)*(sin(t1)*sin(t3) + cos(t1)*cos(t3)*sin(t2)))/1000 + (1137*cos(t1)*cos(t2)*sin(t4))/1000,                           (1137*cos(t2)*cos(t3)*cos(t4)*sin(t1))/1000 - (1137*sin(t1)*sin(t2)*sin(t4))/1000, -(1137*cos(t4)*(cos(t1)*cos(t3) + sin(t1)*sin(t2)*sin(t3)))/1000, (1137*sin(t4)*(cos(t1)*sin(t3) - cos(t3)*sin(t1)*sin(t2)))/1000 + (1137*cos(t2)*cos(t4)*sin(t1))/1000]
 ];

    [Hcvx_pz, Hccv_pz] = ConvexConcaveDecompose(H_pz);
                                                                                        

end