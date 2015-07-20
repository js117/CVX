% Example usage: 
% [scoresBP, scoresSP, bestScoreDiff, axisWeights] = scoreTestCheapDTW(T_benchpress_1, T_shoulderpress_1, [Af_benchpress; Af_shoulderpress], 2, 250);
function [y1, y2, y3, y4] = scoreTestCheapDTW(TTemplate1, TTemplate2, TTest, accMax, gyroMax)
    testLen = size(TTest,1);
    
    Template1 = TTemplate1;
    Template1(:,1:3) = TTemplate1(:,1:3)/accMax;
    Template1(:,4:6) = TTemplate1(:,4:6)/gyroMax;
    
    Template2 = TTemplate2;
    Template2(:,1:3) = TTemplate2(:,1:3)/accMax;
    Template2(:,4:6) = TTemplate2(:,4:6)/gyroMax;
    
    
    Test = TTest;
    Test(:,1:3) = TTest(:,1:3)/accMax;
    Test(:,4:6) = TTest(:,4:6)/gyroMax;
    
    templateLen = size(Template1,1);
    
    windowSize = 1;
    bestScoreDiff = 999999999999999;
    lastScoreDiff = 0; % for max-min
    
    scores1 = 9999999*ones(testLen-templateLen,1);
    scores2 = 9999999*ones(testLen-templateLen,1);
    
    %%%%%%%%%%%%%% BRUTE FORCE: FIND THE BEST WEIGHTS TO SEPARATE %%%%%%%%%
    lims = [8, 8, 8, 5, 1, 5];
    bestAxisWeights = zeros(size(lims));
    for i1=1:lims(1)
        for i2=1:lims(2)
            disp('% complete: ');
            disp(num2str((i1-1)*10 + i2));
            for i3=1:lims(3)
                for i4=1:lims(4)
                    for i5=1:lims(5)
                        for i6=1:lims(6)
    
                            axisWeights = [i1, i2, i3, i4, i5, i6];

                            for i=1:(testLen-templateLen)
                               scores1(i) = cheapDTW(Template1, axisWeights, Test(i:i+templateLen,:), windowSize); 
                               scores2(i) = cheapDTW(Template2, axisWeights, Test(i:i+templateLen,:), windowSize); 
                            end

                            diff = abs(scores1 - scores2);
                            thisScore = min(diff);
                            %if (diff < bestScoreDiff)
                            if (thisScore > lastScoreDiff)
                               bestScoreDiff = thisScore; %diff;
                               bestScore1s = scores1;
                               bestScore2s = scores2;
                               bestAxisWeights = axisWeights;
                               lastScoreDiff = thisScore;
                            end
                            
                        end
                    end
                end
            end
        end
    end
    
    y1 = bestScore1s;
    y2 = bestScore2s;
    y3 = bestScoreDiff;
    y4 = bestAxisWeights;
end

% axisWeights: [weightAx, weightAy, ..., weightGz] 6-tuple
function y = cheapDTW(TTemplate, axisWeights, Buffer, windowSize)
        score = 0; 
		len = size(TTemplate,1); % must be same length as userData
		BIG_NUMBER = 9999999999999; 
		testScore = BIG_NUMBER;
		thisScore = BIG_NUMBER;
		
		
		for i=1:len
			lowerLim = max(i-windowSize, 1);
			upperLim = min(i+windowSize, len);
			
			for j=lowerLim:upperLim
				%testScore = norm(TTemplate(i,:) - Buffer(j,:));
                testScore = 0;
                for k=1:length(axisWeights)
                   testScore = testScore + axisWeights(k)*abs(TTemplate(i,k) - Buffer(j,k)); 
                end
				if (testScore < thisScore)
					thisScore = testScore;
                end
            end
			score = score + thisScore;
			thisScore = BIG_NUMBER;
        end
		
		y = score;
end