% mimic MATLAB's conv(u,v,'same') function
% always returns column vec
function y = myConv(u_in, v_in)

%     for i=3:m-3
%            newVal = 0;
%            for k=-2:2
%                newVal = newVal + Gvec(k+3)*inputImage(i+k, j);
%            end
%            Y2(i,j) = newVal;
%         end
    len1 = length(u_in);
    len2 = length(v_in);
    
    if (len1 >= len2)
       u = u_in;
       v = v_in;
    else
       u = v_in;
       v = u_in;
    end
    
    % from here on: v is the shorter vector (len1 >= len2)
    
    len1 = length(u); 
    len2 = length(v); 
    maxLen = len1 + len2 - 1;
    
    ytemp = zeros(maxLen,1);
    
    % first part -- partial overlap
    for i=1:len2-1
        sum = 0;
        for j=1:i
           sum = sum + u(i-j+1)*v(j);
        end
        ytemp(i) = sum;
    end
    
    % main part -- complete overlap
    for i=len2:len1
        sum = 0;
        for j=1:len2
           sum = sum + u(i-j+1)*v(j);
        end
        ytemp(i) = sum;
    end
    
    % finally -- end portion
    for i=len1+1:maxLen
        %i-len1+1
        sum = 0;
        for j=i-len1+1:len2
           sum = sum + u(i-j+1)*v(j);
        end
        ytemp(i) = sum;
    end
    
    %y = ytemp;
    
    startIndex = round((maxLen - length(u_in))/2 + 1);
    y = ytemp(startIndex:startIndex+length(u_in)-1); 
    % ^ note: to match MATLAB's conv(u,v,'same'), the output length must be
    %   that of the first argument. 
end