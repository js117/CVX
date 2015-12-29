% Script to test the full Variable Length Template Comparison algorithm

%%%%%%%%%%%%%%%%%%%%%%%%% USER TEST DATA SETUP %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TTest = {Af_benchpress, Af_bentoverrow, Af_bicepcurl, Af_deadlift, Af_halfsquat, ...
%         Af_pullover, Af_shoulderpress, Af_skullcrusher, Af_squat, Af_uprightrow, ...
%         };
 
TTest = { UpperCut10Reps, Cross10Reps };

% For reference:
% TTest_Bicepcurl_Fast = [bicepcurlfast; rand(10,6)-0.5; bicepcurlfast; rand(10,6)-0.5; bicepcurlfast; rand(10,6)-0.5; bicepcurlfast; rand(10,6)-0.5; bicepcurlfast; rand(10,6)-0.5; bicepcurlfast; rand(10,6)-0.5; bicepcurlfast; rand(10,6)-0.5; bicepcurlfast; rand(10,6)-0.5; bicepcurlfast; rand(10,6)-0.5; bicepcurlfast; rand(10,6)-0.5;]
% TTest_Bicepcurl_Fast = TTest_Bicepcurl_Fast + 0.1*(rand(300,6)-0.5);     

%TTest = {Af_benchpress, Af_bicepcurl};
     
numTests = size(TTest,2);
numAxes = size(TTest{1},2);
B = zeros(1,numAxes);
for i=1:numTests
    B = [B; TTest{i}];
end
maxRowCount = size(B,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% TEMPLATE DATA SETUP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TEMPLATE = bicepcurlfast; %UpperCutTemplate;
ACC_MAX = 16;
GYRO_MAX = 2000;
templateSegments = createSegmentsTemplate(TEMPLATE,ACC_MAX,GYRO_MAX); 
templateDataRawLength = size(TEMPLATE(:,1),1);

userBufferLength = 2*templateDataRawLength; % multiply by max expected 
                                            % slow down in template
                                            % (e.g. *2 for half speed)
BBuffer = zeros(userBufferLength, numAxes);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% DATA SCORE TESTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
skip = 1; % recommend setting this to around 4; will go faster, results 
% roughly the same, which suggests our problem has good temporal continuity 
optVals = zeros(maxRowCount,1);
for t=1:skip:(maxRowCount-userBufferLength-1)
  % fill up buffer: 
  BBuffer = B(t:t+userBufferLength, :); % slide forward in time
  
  
  
  %%%%%%%%%% USE DIFFERENT ALGORITHM: %%%%%%%%%%%%%%5
  % myScore = testMyAlgorith(BBuffer, Template);
  % optVals(t) = myScore; 
  
  
  
  
  
  %%%%%%%%%%%%%%%%%%
  %bufferSegments = createSegmentsTemplate(BBuffer,ACC_MAX,GYRO_MAX); 
  % ^ can probably be done much more efficiently as a queue in real-time
  % (how to do filtering with new point in O(1) time?)

  %rawScore = 0;
  %for j=1:numAxes
  %   rawScore = rawScore + compareSegmentsTemplateBuffer(templateSegments{j}, bufferSegments{j});
  %end
  %%%%%%%%%%%%%%%%%%%%%%
  
  %optVals(t) = rawScore;

  optVals(t) = cheapDTW(UpperCutTemplate, BBuffer, 1, [1,1,1,1,1,1]);
  
  if (mod(t,25) == 0) % make sure # * (skip+1) divides into this
     disp(strcat('% Complete on dataset: ',num2str(t/maxRowCount))); 
  end
end 

% plot results:
figure; plot(optVals);
