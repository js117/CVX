% axisWeights: [weightAx, weightAy, ..., weightGz] 6-tuple
function y = cheapDTW(TTemplate, Buffer, windowSize, axisWeights)
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