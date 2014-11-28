function [Trans] = TranslationMatrix(x,y,z)
    Trans = eye(4,4);
    Trans(1,4) = x;
    Trans(2,4) = y;
    Trans(3,4) = z;
end