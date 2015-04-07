% Returns a version of theta_new_matrix that:
% 1. doesn't have as many redundant points (e.g. repeated zeros)
% 2. is stretched by a factor, i.e. extrapolated, for smoother motion
% theta_new_matrix is n x T
function [Y, countsUnique] = GenerateSmoothTrajectory(theta_new_matrix, stretchFactor)

    [n,T] = size(theta_new_matrix);
    FLAG = -3; % some value that will be easy to "chop off"
    theta_stretched_matrix = FLAG*ones(n,T);

    % Step 1: figure out which of the n trajectories has the most "unique"
    % points. 
    countsUnique = zeros(n,1);
    tol = 1e-5; % if difference in values is < tol, assume they're the same
    for i=1:n
       sequence = theta_new_matrix(i,:);
       idx = 1;
       for j=1:T-1 
           theta_stretched_matrix(i,idx) = sequence(j);
           
           if (abs(sequence(j+1) - sequence(j)) > tol)
               idx = idx + 1;
               idx
           end
       end
       theta_stretched_matrix(i,idx) = sequence(j+1);
       countsUnique(i) = idx;
    end
    
    
    Y = theta_stretched_matrix;

end