function [Ro] = TransAndRotXYZMatrix_Syms(xAngle,yAngle,zAngle, xTrans, yTrans, zTrans)
syms Ro Rx Ry Rz R
Rx = [1,                0,          0;
    0,                cos(xAngle), -sin(xAngle);
    0,                sin(xAngle), cos(xAngle);];

Ry = [cos(yAngle),       0,          sin(yAngle);
    0,                1,          0;
    -sin(yAngle),      0,          cos(yAngle);];

Rz = [cos(zAngle),       -sin(zAngle),0;
    sin(zAngle)        cos(zAngle), 0;
    0,                0,          1;];
R = Rx*Ry*Rz;

R = [R, [xTrans;yTrans;zTrans];
    [0,0,0],1];
Ro = R;
end

% e.g. BASE = TransAndRotXYZMatrix_Syms(0,0,0,0, -ShoulderOffsetY-ElbowOffsetY, ShoulderOffsetZ)
% TOOL = TransAndRotXYZMatrix_Syms(0,0,pi/2,0,0,0)*TransAndRotXYZMatrix_Syms(0,0,0,-HandOffsetX-LowerArmLength,0,0)*TransAndRotXYZMatrix_Syms(0,0,-pi,0,0,0)

% Should really be called "TransORRot.." because one might assume they can
% combine rot and trans into the same homogeneous matrix to mimic rot then
% trans, which is a different operation. 
