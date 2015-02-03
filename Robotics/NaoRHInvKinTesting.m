%%%%%% Testing right hand INV KIN solution %%%%%%%%%%
% Developed by JS

% Test with random thetas in range
Xmax = [2.0857, 0.3142, 2.0857, 1.5446, 1.8238]';
Xmin = [-2.0857, -1.3265, -2.0857, 0.0349, -1.8238]';
T = 5000;
X = GenerateRandomX(Xmin, Xmax, T);
Y = zeros(6,T);
for i=1:T
    Y(:,i) = ForwardKinRH_explicit(X(:,i)); % ForwardKinRH(X(:,i));
end

% Uncomment to test on actual collected data from the Nao robot (requires
% workspace):
%Y = EndEffectorTestRef; X = JointAngleTestRef;
%m = size(Y,1); n = size(X,1); T = size(Y,2);

diffs = zeros(T,1);
countOfBigErrors = 0; countOfBigErrorsRot = 0;

for i=1:T

    targetPose = Y(:,i);
    jointData = X(:,i);
    
    %%%%%%%%%%%%%% Using Geometric Hand-craft PoE IK Sln %%%%%%%%%%%%%%%%%%
    [thetas1, thetas2, thetas3, thetas4] = InverseKinRH_PoE(targetPose);
    allThetas = [thetas1, thetas2, thetas3, thetas4];
    % testing which thetas_i to take
    test = ones(4,1);
    test(1) = mean(abs(jointData - thetas1));
    test(2) = mean(abs(jointData - thetas2));
    test(3) = mean(abs(jointData - thetas3));
    test(4) = mean(abs(jointData - thetas4));
    % TODO - we can also discount solutions based on joint angle limits
    [val, chosenIndex] = min(test);
    thetas = allThetas(:,chosenIndex);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%% Code below is invalid, do not use.
    %%%%%%%%%% Testing with Log Map CVX solution %%%%%%%%%
%     [thetas] = InverseKinRH_LogMapPoE(targetPose);
%     numSols = size(thetas,2);
%     test = ones(numSols,1);
%     for ii=1:numSols
%        test(ii) = mean(abs(jointData - thetas(:,ii))); 
%     end
%     [val, chosenIndex] = min(test);
%     thetas = thetas(:,chosenIndex);
%     X(:,i)
%     thetas
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %error = mean(abs(X(:,i)-thetas(:)));
    
    error = mean(abs(targetPose - ForwardKinRH_explicit(thetas))); % error via computed ee 
    
    diffs(i) = error;
    if (error > 0.5)
        countOfBigErrors = countOfBigErrors + 1;
         %targetPose
         %ForwardKinRH_PoE(X(:,i))
        %ForwardKinRH_PoE(thetas)
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





