function y = scoreTestCheapDTW(TTemplate, TTest, accMax, gyroMax)
    testLen = size(TTest,1);
    
    Template = TTemplate;
    Template(:,1:3) = TTemplate(:,1:3)/accMax;
    Template(:,4:6) = TTemplate(:,4:6)/gyroMax;
    
    Test = TTest;
    Test(:,1:3) = TTest(:,1:3)/accMax;
    Test(:,4:6) = TTest(:,4:6)/gyroMax;
    
    templateLen = size(Template,1);
    scores = 9999999*ones(testLen-templateLen,1);
    
    windowSize = 2;
    
    for i=1:(testLen-templateLen)
       scores(i) = cheapDTW(Template, Test(i:i+templateLen,:), windowSize); 
    end
    
    y = scores;
    
end

function y = cheapDTW(TTemplate, Buffer, windowSize)
        score = 0; 
		len = size(TTemplate,1); % must be same length as userData
		BIG_NUMBER = 9999999999999; 
		testScore = BIG_NUMBER;
		thisScore = BIG_NUMBER;
		
		
		for i=1:len
			lowerLim = max(i-windowSize, 1);
			upperLim = min(i+windowSize, len);
			
			for j=lowerLim:upperLim
				testScore = norm(TTemplate(i,:) - Buffer(j,:));
				if (testScore < thisScore)
					thisScore = testScore;
                end
            end
			score = score + thisScore;
			thisScore = BIG_NUMBER;
        end
		
		y = score;
end