% Every repeated convolution with this kernel multiplies effective sigma by
% sqrt(2)
function [Y1, Y2] = testConvolveTime(inputImage)
    [m,n] = size(inputImage);

    % casting...
    inputImage = cast(inputImage, 'single');
    
    Gvec = [1 4 6 4 1]; % sigma=1;
    
    Y1 = zeros(size(inputImage)); % modify it
    Y2 = zeros(size(inputImage)); % modify it
    
    
    %%%%%%%%%%%%%%%%%%% MATLAB CONV %%%%%%%%%%%%%%%%%%%%%
    t1 = cputime;
    
    for i=1:m
        Y1(i,:) = conv(inputImage(i,:),Gvec,'same');
    end
    
    for j=1:n
        Y1(:,j) = conv(inputImage(:,j),Gvec','same');
    end
          
    Y1 = round(Y1 / 16);
    e1 = cputime - t1
    
    %%%%%%%%%%%%%%%%%%% HAND-CODED CONV %%%%%%%%%%%%%%%%%%%%%
    t2 = cputime;
    
    for i=1:m
        Y2(i,:) = myConv(inputImage(i,:),Gvec)';
    end
    
    for j=1:n
        Y2(:,j) = myConv(inputImage(:,j),Gvec');
    end
          
    Y2 = round(Y2 / 16);
    e2 = cputime - t2
    
end