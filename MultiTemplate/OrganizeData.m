% Organize template data into appropriate data matrix for mixed-length
% multi-template matching. 

% To try out different features, change the data in these matrices 
% (and calculate the same features for user test data in TTest as well)
% Don't forget to set "numAxes" = to the number of features!

T1 = HanningFilter(Matt_TEMPLATE_Bicepcurl);
T2 = HanningFilter(Jarred_TEMPLATE_Bicepcurl);
% T3 = HanningFilter(Ethan_TEMPLATE_Bicepcurl);
% T4 = HanningFilter(Aaron_TEMPLATE_Bicepcurl);
% T5 = HanningFilter(Aaron_TEMPLATE_Benchpress);
% T6 = HanningFilter(Ethan_TEMPLATE_Benchpress);
% T7 = HanningFilter(TEMPLATE_Shoulderpress1);
% T8 = HanningFilter(TEMPLATE_Shoulderpress2);
% T9 = HanningFilter(TEMPLATE_Shoulderpress3);
% T10 = HanningFilter(TEMPLATE_Shoulderpress4);
% T11 = HanningFilter(Aaron_TEMPLATE_Squats);
% T12 = HanningFilter(Ethan_TEMPLATE_Squats);
% T13 = HanningFilter(Jarred_TEMPLATE_Squats);
% T_NEW_TEMPLATES: already filtered
T3 = T_NEW_TEMPLATE_BENCH;
T4 = T_NEW_TEMPLATE_BENCH_2;
T5 = T_NEW_TEMPLATE_SHOULDER_PRESS;
T6 = T_NEW_TEMPLATE_SHOULDER_PRESS_2;
T7 = T_NEW_TEMPLATE_SQUAT;
T8 = T_NEW_TEMPLATE_SQUAT_2;

T = {T1, T2, T3, T4, T5, T6, T7, T8};

TTest = {Matt_ALL_Bicepcurl, Jarred_ALL_Bicepcurl, Ethan_ALL_Bicepcurl, Aaron_ALL_Bicepcurl, ...
         Aaron_ALL_Benchpress, Ethan_ALL_Benchpress, ALL_Shoulderpress1, ALL_Shoulderpress2, ...
         ALL_Shoulderpress3, ALL_Shoulderpress4, Aaron_ALL_Squats, Ethan_ALL_Squats, ...
         Jarred_ALL_Squats};

numAxes = 6;
numTemplates = size(T,2);

% Modify the template scaling. 
% Emperically we observe gyro having a max val of ~248 and acc having a max
% val of ~1.83 - across all trial data. Not normalizing heavily biases the
% algorithm to match crappy gyro noise in motions where gyro is less
% prominent (e.g. bench press). 
GYRO_MAX = 248;
ACC_MAX = 1.83; % use empirical vals from template dataset
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

MARKER = -987;
% Add the zeros as extra rows:
for i=1:numTemplates
    rowCount = size(T{i},1);
    for j=rowCount+1:maxRowCount
        T{i}(j,:) = MARKER*ones(numAxes,1);
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
alphaWeights = zeros(numAxes, n); % compute these guys too
for i=1:numAxes
    for j=1:numTemplates
        
        MjkMatrices{i,j} = MMatrices{i}(MiLengths(j)+1:MiLengths(j+1), :);
        
        for ii=1:size(MjkMatrices{i,j},1)
            jj = 1;
            while (MjkMatrices{i,j}(ii,jj) == MARKER)
               jj = jj + 1; 
            end
            
            MjkMatrices{i,j}(ii,1:jj-1) = mean(MjkMatrices{i,j}(ii,jj:end));
            
        end
        
        alphaWeights(i,j) = (1/numAxes) * (MiLengths(j+1) - MiLengths(j))/maxRowCount; 
        % as we see, we can do things like weight gyroY stream
        % higher/lower, weight the shorter blocks (end of longer templates)
        % in a decaying fashion, etc. 
        % sum(sum(alphaWeights)) should be 1
    end
end

% Compute P matrix for QP, since it's done only once, offline. For q
% vectors, we need recompute every new data point.

P = zeros(n,n);
for j=1:numAxes
    for k=1:numTemplates
        P = P + alphaWeights(j,k)*MjkMatrices{j,k}'*MjkMatrices{j,k};
    end
end
P = 2*P;
