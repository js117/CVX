function y = firstDerivative(input,ACC_MAX,GYRO_MAX)
    x = input;
    x(:,1:3) = input(:,1:3)/ACC_MAX;
    x(:,4:6) = input(:,4:6)/GYRO_MAX;
    len = size(x,1); width = size(x,2);
    y = zeros(size(x));
    for i=2:len
       for j=1:width
           y(i,j) = x(i,j) - x(i-1,j); 
       end
    end
end