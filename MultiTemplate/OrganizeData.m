% Organize template data into appropriate data matrix for mixed-length
% multi-template matching. 

T1 = Matt_TEMPLATE;
T2 = Jarred_TEMPLATE;
T3 = Ethan_TEMPLATE;
T4 = Aaron_TEMPLATE;

T = {T1, T2, T3, T4};
TTest = {Matt_ALL, Jarred_ALL, Ethan_ALL, Aaron_ALL};

numAxes = 6;
numTemplates = 4;

% Step 1 - zero-pad rows to max length
rowCounts = [size(T1,1),size(T2,1),size(T3,1),size(T4,1)];
maxRowCount = max(rowCounts);
minRowCount = min(rowCounts);
[MiLengths, indicies] = sort(rowCounts);
MiLengths = [0, MiLengths]; % will be of length n+1 now

% Add the zeros as extra rows:
for i=1:numTemplates
    rowCount = size(T{i},1);
    for j=rowCount+1:maxRowCount
        T{i}(j,:) = zeros(numAxes,1);
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
numSubBlocks = n; % Assuming all templates of different length. 
                  % Could be less but WLOG we can expect all different
                  % lengths (with negligible added overhead too)

% Mjk matrices: form subblocks which represent additional length in
% templates we don't wish to compare with previous shorter length templates
% but which we still want to match against a longer stream of user data.
MjkMatrices = cell(numAxes, numSubBlocks);
alphaWeights = zeros(numAxes, n); % compute these guys too
for i=1:numAxes
    for j=1:numSubBlocks
        
        MjkMatrices{i,j} = MMatrices{i}(MiLengths(j)+1:MiLengths(j+1), :);
        
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
    for k=1:numSubBlocks
        P = P + alphaWeights(j,k)*MjkMatrices{j,k}'*MjkMatrices{j,k};
    end
end
P = 2*P;
