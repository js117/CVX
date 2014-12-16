%%%%%% Testing (debugging...) right hand INV KIN solution %%%%%%%%%%
% Developed by JS

Y = EndEffectorTestRef; X = JointAngleTestRef;
m = size(Y,1); n = size(X,1); T = size(Y,2);

diffs = zeros(T,1);
countOfBigErrors = 0; countOfBigErrorsRot = 0;

for i=1:T

    targetPose = Y(:,i);
    
    [thetas1, thetas2, thetas3, thetas4] = InverseKinRH_PoE(targetPose);
    allThetas = [thetas1, thetas2, thetas3, thetas4];
    % testing which thetas_i to take
    jointData = X(:,i);
    test = ones(4,1);
    test(1) = mean(abs(jointData - thetas1));
    test(2) = mean(abs(jointData - thetas2));
    test(3) = mean(abs(jointData - thetas3));
    test(4) = mean(abs(jointData - thetas4));
    
    % TODO - we can also discount solutions based on angular possibilities
    [val, chosenIndex] = min(test);
    thetas = allThetas(:,chosenIndex);

    error = mean(abs(X(:,i)-thetas(:)));
    
    %X(:,i)
    %thetas(:)
    
    diffs(i) = error;
    if (error > 0.5)
        countOfBigErrors = countOfBigErrors + 1;
%         targetPose
%         X(:,i)
%         allThetas
    end
    
    
end
figure; plot(diffs);

disp(mean(diffs));
disp(countOfBigErrors);

y = diffs;
figure;
hist(y,30); 


% to help with debugging why angle errors occur:
%time=linspace(1,T,T);figure;plot(time,X(1,:),time,X(2,:),time,X(3,:),time,X(4,:),time,X(5,:))





