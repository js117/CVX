% Export MjkMatrices to Java var

OUT = [];

for j=1:numAxes
   
   for k=1:numTemplates 
       OUT(j,k) = MjkMatrices{j,k}';
       
   end
end