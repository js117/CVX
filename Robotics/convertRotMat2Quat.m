% Convert 3x3 rot mat to unit quaternion using angle-axis representation
function q = convertRotMat2Quat(R)

    t = acos((trace(R) - 1)/2);
    
    w = (1/(2*sin(t)))*[R(3,2)-R(2,3), R(1,3)-R(3,1), R(2,1)-R(1,2)]; 
    
    q = [cos(t/2), w*sin(t/2)];

end