%%%%%% Testing (debugging...) right hand FWD kin solution %%%%%%%%%%
% Developed by JS

Y = EndEffectorTestRef; X = JointAngleTestRef;
m = size(Y,1); n = size(X,1); T = size(Y,2);

% Convert to meters
shoulderOffsetY = 98/1000;
elbowOffsetY = 15/1000;
upperArmLength = 105/1000;
shoulderOffsetZ = 100/1000;
HandOffsetX = 57.75/1000;
HandOffsetZ = 12.31/1000;
LowerArmLength = 55.95/1000;
HipOffsetZ = 85/1000; 
HipOffsetY = 50/1000;
ThighLength = 100/1000;
TibiaLength = 102.90/1000;
FootHeight = 45.11/1000;
NeckOffsetZ = 126.5/1000;

z1 = 0.105; %in m 
z2 = LowerArmLength + HandOffsetX; 
y1 = -0.098; 

diffsPos = zeros(T,1);
diffsRot = zeros(T,1);
countOfBigErrorsPos = 0; countOfBigErrorsRot = 0;

for i=1:T

    thetas = X(:,i);
    
    t1 = thetas(1); % shoulder pitch (Y)
    t2 = thetas(2); % shoulder roll (Z)
    t3 = thetas(3); % elbow yaw (X)
    t4 = thetas(4); % elbow roll (Z)
    t5 = thetas(5); % wrist yaw (X)
    
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
    
    errorPos = mean(abs(Y(1:3,i)-right(1:3)));
    errorRot = mean(abs(Y(4:6,i)-right(4:6)));
    diffsPos(i) = errorPos;
    diffsRot(i) = errorRot;
    if (errorPos > 0.1)
        countOfBigErrorsPos = countOfBigErrorsPos + 1;
    end
    if (errorRot > 0.1)
        countOfBigErrorsRot = countOfBigErrorsRot + 1;
    end
    
end
figure; plot(diffsPos);
figure; plot(diffsRot);

disp(mean(diffsPos));
disp(mean(diffsRot));
disp(countOfBigErrorsPos);
disp(countOfBigErrorsRot);

% to help with debugging why angle errors occur:
time=linspace(1,T,T);figure;plot(time,X(1,:),time,X(2,:),time,X(3,:),time,X(4,:),time,X(5,:))





