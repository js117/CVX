%%%%%% Testing right hand FWD kin solution %%%%%%%%%%
% source: https://github.com/kouretes/NAOKinematics/blob/master/Matlab/fRightHandH25.m
% and: https://github.com/kouretes/NAOKinematics/tree/master/Matlab
% and: http://www.intelligence.tuc.gr/~nikofinas//Projects/KofinasThesis.pdf 

Y = EndEffectorTestRef; X = JointAngleTestRef;
m = size(Y,1); n = size(X,1); T = size(Y,2);

% Convert to meters
shoulderOffsetY = 98/1000;
elbowOffsetY = 15/1000;
upperArmLength = 105/1000;
shoulderOffsetZ = 100/1000; %100/1000; %original is 100
HandOffsetX = 57.75/1000;
HandOffsetZ = 12.31/1000;
LowerArmLength = 55.95/1000;
HipOffsetZ = 85/1000; 
HipOffsetY = 50/1000;
ThighLength = 100/1000;
TibiaLength = 102.90/1000;
FootHeight = 45.11/1000;
NeckOffsetZ = 126.5/1000;

diffsPos = zeros(T,1);
diffsRot = zeros(T,1);
countOfBigErrorsPos = 0; countOfBigErrorsRot = 0;

for i=1:T

    thetas = X(:,i);
    
    base = eye(4,4);
    base(2,4) = -shoulderOffsetY;
    base(3,4) = shoulderOffsetZ;

    T1 = DH(0,-pi/2,0,thetas(1));
    T2 = DH(0,pi/2,0,thetas(2)+pi/2); %To -pi/2 to afinoume panta !!!
    T3 = DH(-elbowOffsetY,pi/2,upperArmLength,thetas(3));
    T4 = DH(0,-pi/2,0,thetas(4));
    %% THIS is the correct but the other is equivelant
    %T5 = T(0,pi/2,LowerArmLength,thetas(5));
    %Tend1 = eye(4,4);
    %Tend1(1,4) = HandOffsetX;
    %Tend1(3,4) = -HandOffsetZ;
    %% This is to help us with the inverse kinematics, does not change ANYTHING
    %% at all.
    T5 = DH(0,pi/2,0,thetas(5));
    Tend1 = eye(4,4);
    Tend1(1,4) = LowerArmLength + HandOffsetX;
    Tend1(3,4) = -HandOffsetZ;
    %end of fix

    R = RotXYZMatrix(-pi/2,0,-pi/2);
    Tend = R*Tend1;
    Tendend = base*T1*T2*T3*T4*T5*Tend;

    rotZ = atan2(Tendend(2,1),Tendend(1,1));
    rotY = atan2(-Tendend(3,1),sqrt(Tendend(3,2)^2 + Tendend(3,3)^2));
    rotX = atan2(Tendend(3,2),Tendend(3,3));
    right = [Tendend(1:3,4);rotX;rotY;rotZ];
    
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

disp(shoulderOffsetZ);
disp(mean(diffsPos));
disp(mean(diffsRot));
disp(countOfBigErrorsPos);
disp(countOfBigErrorsRot);