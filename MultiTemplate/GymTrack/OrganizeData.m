% Organize template data into appropriate data matrix for mixed-length
% multi-template matching. 

% To try out different features, change the data in these matrices 
% (and calculate the same features for user test data in TTest as well)
% Don't forget to set "numAxes" = to the number of features!

T1 = T_uprightrow_1; T2 = T_uprightrow_2; T3 = T_uprightrow_3;
T4 = T_squat_1; T5 = T_squat_2; T6 = T_squat_3;
T7 = T_skullcrusher_1; T8 = T_skullcrusher_2; T9 = T_skullcrusher_3;
T10 = T_shoulderpress_1; T11 = T_shoulderpress_2; T12 = T_shoulderpress_3;
T13 = T_pullover_1; T14 = T_pullover_2; T15 = T_pullover_3;
T16 = T_deadlift_1; T17 = T_deadlift_2; T18 = T_deadlift_3;
T19 = T_bicepcurl_1; T20 = T_bicepcurl_2; T21 = T_bicepcurl_3;
T22 = T_bentoverrow_1; T23 = T_bentoverrow_2; T24 = T_bentoverrow_3;
T25 = T_benchpress_1; T26 = T_benchpress_2; T27 = T_benchpress_3;
T28 = T_halfsquat_1; T29 = T_halfsquat_2; T30 = T_halfsquat_3;

T = {T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, ...
     T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, ...
     T21, T22, T23, T24, T25, T26, T27, T28, T29, T30};

%TTest = {HanningFilter(DaveTest)};

numAxes = 6;
numTemplates = size(T,2);

% Modify the template scaling. 
% Emperically we observe gyro having a max val of ~248 and acc having a max
% val of ~1.83 - across all trial data. Not normalizing heavily biases the
% algorithm to match crappy gyro noise in motions where gyro is less
% prominent (e.g. bench press). 
GYRO_MAX = 250;
ACC_MAX = 2; % use empirical vals from template dataset
for i=1:numTemplates
    T{i}(:,1:3) = T{i}(:,1:3) / ACC_MAX;
    T{i}(:,4:6) = T{i}(:,4:6) / GYRO_MAX;
end

% Step 1 - zero-pad rows to max length
rowCounts = zeros(numTemplates,1)';
for i=1:numTemplates
   rowCounts(i) = size(T{i}, 1); 
end
maxRowCount = max(rowCounts);
minRowCount = min(rowCounts);
[MiLengths, indicies] = sort(rowCounts);
MiLengths = [0, MiLengths]; % will be of length n+1 now

MkLengths = [];
for i=2:numTemplates+1
   diff = MiLengths(i)-MiLengths(i-1);
   if (diff > 0)
    MkLengths = [MkLengths; diff];
   end
end

j = 1;
while (j < numTemplates)
    %size(T{indicies(j)})
    j = j + 1;
end

MARKER = 0.000000001;
% Add the zeros as extra rows:
for i=1:numTemplates
    rowCount = size(T{i},1);
    for j=rowCount+1:maxRowCount
        T{i}(j,:) = T{i}(j-rowCount,:); % try repeating
    end
end

% Form the M matrices.
% Messy; creates numAxes matrices, where each matrix has columns
% corresponding to each template's data of that axis, and the cols are
% sorted from shortest to largest
MMatrices = cell(numAxes,1);
for i=1:numAxes
   MMatrices{i} = zeros(maxRowCount, numTemplates);
   for j=1:numTemplates
       MMatrices{i}(:,j) = T{indicies(j)}(:,i);
   end
end

n = numTemplates;
numSubBlocks = size(MkLengths,1); % Assuming all templates of different length. 
                  % Could be less but WLOG we can expect all different
                  % lengths (with negligible added overhead too)

% Mjk matrices: form subblocks which represent additional length in
% templates we don't wish to compare with previous shorter length templates
% but which we still want to match against a longer stream of user data.
MjkMatrices = cell(numAxes, numSubBlocks);
alphaweights = zeros(numAxes, n); % compute these guys too
for i=1:numAxes
    for j=1:numTemplates
        
        MjkMatrices{i,j} = MMatrices{i}(MiLengths(j)+1:MiLengths(j+1), :);
        
        for ii=1:size(MjkMatrices{i,j},1)
            jj = 1;
            while (MjkMatrices{i,j}(ii,jj) == MARKER)
               jj = jj + 1; 
               disp('yo')
            end
            
            MjkMatrices{i,j}(ii,1:jj-1) = mean(MjkMatrices{i,j}(ii,jj:end));
            %mean(MjkMatrices{i,j}(ii,jj:end))
            
        end
        
        alphaweights(i,j) = (1/numAxes) * (MiLengths(j+1) - MiLengths(j))/maxRowCount; 
        % as we see, we can do things like weight gyroY stream
        % higher/lower, weight the shorter blocks (end of longer templates)
        % in a decaying fashion, etc. 
        % sum(sum(alphaweights)) should be 1
    end
end

% Compute P matrix for QP, since it's done only once, offline. For q
% vectors, we need recompute every new data point.

P = zeros(n,n);
for j=1:numAxes
    for k=1:numTemplates
        P = P + alphaweights(j,k)*MjkMatrices{j,k}'*MjkMatrices{j,k};
    end
end
P = 2*P;

figure;
for i=1:numTemplates
    plot(1:length(T{i}),T{i}(:,1),1:length(T{i}),T{i}(:,2),1:length(T{i}),T{i}(:,3),1:length(T{i}),T{i}(:,4),1:length(T{i}),T{i}(:,5),1:length(T{i}),T{i}(:,6));
    hold on;
end

% left
%figure;plot(1:length(T{1}),T{1}(:,1),1:length(T{1}),T{1}(:,2),1:length(T{1}),T{1}(:,3),1:length(T{1}),T{1}(:,4),1:length(T{1}),T{1}(:,5),1:length(T{1}),T{1}(:,6)) 
% right
%figure;plot(1:length(T{5}),T{5}(:,1),1:length(T{5}),T{5}(:,2),1:length(T{5}),T{5}(:,3),1:length(T{5}),T{5}(:,4),1:length(T{5}),T{5}(:,5),1:length(T{5}),T{5}(:,6)) 

