% Data to be filtered are the columns of x
function y = HanningFilter(x)
    [m,n] = size(x);
    y = zeros(size(x));
    for i=1:n
       for j=3:m
          y(j,i) = 0.25*(x(j,i) + 2*x(j-1,i) + x(j-2,i));
       end
    end
end