% Given matrix:
%
% [0, -az, ay
%  az, 0, -ax
%  -ay, ax, 0]
%
% return w = [ax, ay, az]'

function w = deskew(M)
    w = [M(3,2), M(1,3), M(2,1)]';
end