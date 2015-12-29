% Q = (q0, q1, q2, q3)
% Given vec = (q1, q2, q3) known to be a unit quaternion, convert to
% a rotation matrix via Rodrigues' Formula
function [w,t] = convertPartialQuat2AxisAngle(vec)

    % The math:
    % q0^2 + q1^2 + q2^2 + q3^2 = 1
    % Q = (cos(t/2), w*sin(t/2)) 
    % representing a rotation of t radians about unit vector w

    q0_plus = sqrt(1 - (vec(1)^2 + vec(2)^2 + vec(3)^2));
    %q0_minus = sqrt(1 - (vec(1)^2 + vec(2)^2 + vec(3)^2)); % needed?
    q0 = q0_plus;
    
    t = 2*acos(q0);
    w = zeros(size(vec));
    if (t ~= 0)
        w = vec/sin(t/2);
    end

end