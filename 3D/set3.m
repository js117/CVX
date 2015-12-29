function [modeldir wd] = set3(option);

global M Mp g l R K slope w eqnhandle dim modeldir invalidResults

eqnhandle = [];
modeldir = [];

passive_options = [1 2]; %[1 2 5 6 9 10];
controlled_options = [3];
hip_options = [1];
nohip_options = [2 3];
% plastic_options = [1 3 5 7 9 11];
% angcons_options = [2 4 5 8 10 12];
model_options = [1 2 3]; % point footed, midleg mass

if nargin == 0
    option = [];
end

while length(option) == 0
    fprintf('Choose a model:\n\n');
    
    fprintf('Point foot, midleg mass, passive:\n');
    fprintf('   [1] Hipped\n');
    fprintf('   [2] No hip\n');
    fprintf('Point foot, midleg mass, controlled:\n');
    fprintf('   [3] No hip\n');

    fprintf('\n');
    option = input('Make a choice: ');
end

if length(find(option == model_options(1, :))) ~= 0
    dir = 'pointfoot-midlegmass';
elseif length(find(option == model_options(2, :))) ~= 0
    dir = 'rollfoot-midlegmass';
elseif length(find(option == model_options(3, :))) ~= 0
    dir = 'pointfoot-footmass';
else
    fprintf('Choose one of the options above.\n');
    return
end    

if length(find(option == passive_options)) ~= 0
    type = 'passive';
elseif length(find(option == controlled_options)) ~= 0
    type = 'controlled';
else
    fprintf('Choose one of the options above.\n');
    return
end

if length(find(option == hip_options)) ~= 0
    type2 = 'hip';
elseif length(find(option == nohip_options)) ~= 0
    type2 = 'nohip';
else
    fprintf('Choose one of the options above.\n');
    return
end

% Parse the input
modeldir = sprintf('/%s/%s/%s', dir, type, type2);
wd = feval('pwd');
modeldir = strcat(wd, modeldir)

% Get equation handles and model-dependent parameters
cd(modeldir);
eqnhandle = @eqns3;
cd(wd);