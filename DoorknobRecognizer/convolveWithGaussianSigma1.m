% Every repeated convolution with this kernel multiplies effective sigma by
% sqrt(2)
function Y = convolveWithGaussianSigma1(inputImage)
    [m,n] = size(inputImage);

    % casting...
    inputImage = cast(inputImage, 'single');
    
    Gvec = [1 4 6 4 1]; % sigma=1; /16 
    Gmat = Gvec'*Gvec;
    
    Y = zeros(size(inputImage)); % modify it
    
    % efficient implementation: convolve the rows, then the columns
    % (associative in the dimensions)
    
    for i=1:m
        Y(i,:) = conv(inputImage(i,:),Gvec,'same');
%         for j=3:n-3
%            newVal = 0;
%            for k=-2:2
%                newVal = newVal + Gvec(k+3)*cast(inputImage(i, j+k), 'uint32');
%                
%            end
%            Y(i,j) = newVal;
%         end
    end
    
    for j=1:n
        Y(:,j) = conv(inputImage(:,j),Gvec','same');
    end
    
    % convention: leave outer 2 rectangles of pixels alone
%     for i=3:m-3
%         for j=3:n-3 % inclusive indicies
%             
%             newVal = 0; % to replace image(i,j)
%             
%             for ii=-2:2
%                 for jj=-2:2 % using: (length(Gmat[0])-1)/2
%                     
%                     newVal = newVal + Gmat(ii+3,jj+3)*inputImage(i+ii,j+jj);
%                     % +3 to transform loop indicies to 1,2,...,5
%                     % i-2,...,i+2 (same for j) is corresponding pixel range
%                     % in image
%                     
%                 end
%             end
%             Y(i,j) = newVal;
%         end
%         disp(i);
%     end
          
      Y = round(Y / 16);

end