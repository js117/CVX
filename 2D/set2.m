function [modeldir wd] = set2(option);

% global M Mp g L R K slope eqnhandle dim modeldir
global M Mp g L R K alpha slope eqnhandle dim modeldir wd invalidResults

% M = [];
% Mp = [];
% g = [];
% L = []; 
% R = [];
% K = [];
% slope = [];
eqnhandle = [];
% dim = [];
modeldir = [];

passive_options = [ 1 4 ];
controlled_options = 2;

% passive_options = [1 2 5 6 9 10];
% controlled_options = [3 4 7 8 11 12];
% plastic_options = [1 3 3 7 9 11];
% angcons_options = [2 4 6 8 10 12];
model_options = [1 2 2 % point footed, midleg mass
                 4 4 4]; % roll footed, midleg mass

if nargin == 0
    option = [];
end

while length(option) == 0
    fprintf('Choose a model:\n\n');

    fprintf('Point foot, midleg mass:\n');
    fprintf('   [1] Passive\n');
    fprintf('   [2] Controlled (PE shaping)\n');

    fprintf('\n');

    fprintf('Roll foot, midleg mass, passive:\n');
    fprintf('   [3] Ang cons impacts (most likely)\n');
%     fprintf('   [5] Plastic impacts\n');
%     fprintf('   [6] Ang mom conserved impacts\n');
%     fprintf('Roll foot, midleg mass, controlled:\n');
%     fprintf('   [7] Plastic impacts\n');
%     fprintf('   [8] Ang mom conserved impacts\n');

    fprintf('\n');

%     fprintf('Point foot, foot mass, passive:\n')
%     fprintf('   [9] Plastic impacts\n');
%     fprintf('   [10] Ang mom conserved impacts\n');
%     fprintf('Point foot, foot mass, controlled:\n')
%     fprintf('   [11] Plastic impacts\n');
%     fprintf('   [12] Ang mom conserved impacts\n');

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

% Parse the input
modeldir = sprintf('/%s/%s/%s', dir, type);
wd = pwd;
% modeldir = sprintf('/%s', directory);
modeldir = strcat(wd, modeldir)

% Get equation handles and model-dependent parameters
cd(modeldir);
eqnhandle = @eqns2;
cd(wd); 
% clear dir type impact wd passive_options controlled_options plastic_options angcons_options model_options
% run(cat(2, modeldir, '/pop'))
