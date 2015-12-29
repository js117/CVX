% rotX * rotY * rotZ
% x,y,z in radians
function R = rotXrotYrotZ(x,y,z)
    Rx = [1, 0, 0;
          0, cos(x), -sin(x);
          0, sin(x), cos(x)];
      
    Ry = [cos(y), 0, sin(y);
          0,      1,      0;
          -sin(y),0, cos(y)];
      
    Rz = [cos(z), -sin(z), 0;
          sin(z), cos(z),  0;
          0,         0,    1];
      
    R = Rx*Ry*Rz;  
      
end