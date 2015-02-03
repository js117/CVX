function right = ForwardKinRH(thetas)

    shoulderOffsetY = 0.098;%98/1000;
    elbowOffsetY = 0.015;%15/1000;
    upperArmLength = 0.105;%105/1000;
    shoulderOffsetZ = 0.100;%;100/1000;
    HandOffsetX = 0.05775;%57.75/1000;
    HandOffsetZ = 0.01231;%12.31/1000;
    LowerArmLength = 0.05595;%55.95/1000;

    t1 = thetas(1); t2 = thetas(2); t3 = thetas(3); t4 = thetas(4); t5 = thetas(5); 

          FWD = TranslationMatrix(0,-shoulderOffsetY,shoulderOffsetZ)* ...
          RotXYZMatrix(0,t1,0)* ...
          RotXYZMatrix(0,0,t2)* ...
          TranslationMatrix(upperArmLength, -elbowOffsetY,0)* ...
          RotXYZMatrix(t3,0,0)* ...
          RotXYZMatrix(0,0,t4)* ...
          TranslationMatrix(LowerArmLength,0,0)* ...
          RotXYZMatrix(t5,0,0)* ...
          TranslationMatrix(HandOffsetX,0,-HandOffsetZ);
      
    rotZ = atan2(FWD(2,1),FWD(1,1));
    rotY = atan2(-FWD(3,1),sqrt(FWD(3,2)^2 + FWD(3,3)^2));
    rotX = atan2(FWD(3,2),FWD(3,3));
    right = [FWD(1:3,4);rotX;rotY;rotZ];
    
end