function [xnew cnvrg] = search3(xs)
% SEARCH3   Find stable limit cycles.
%
% Start simulation of the 3D walker and find stable limit cycles.
% Takes in an initial condition, then runs the limit cycle searcher on it.
% The limit cycle code calls step3.m, which calls the function eqns3.dll.
%

global M Mp g l R K mu slope w eqnhandle dim modeldir

debug = 1;

% xtest = walk3(xs,30);
% close all
% xs = xtest;

xtest = walk3(xs,30);
if length(xtest) == 0
    xnew = [];
    cnvrg = 0;
    return
end
xs = xtest;

% Kuo's fixed point algorithm, w/ some modifications
gamma = 1E-5;
delta = gamma;
% fprintf(1, 'Searching for fixed point...\n');
enew = 0; e = 1;
while max(abs(e)) > 1e-10
    y = zeros(dim,dim);
    temp1 = step3(xs);
    if length(temp1) == 0
        xnew = [];
        cnvrg = 0;
        return
    end
    y1 = temp1-xs;
    for i=1:dim
        x = xs; x(i) = x(i) - delta;
        temp2 = step3(x);
        if length(temp2) == 0
            xnew = [];
            cnvrg = 0;
            return
        end
        y(:,i) = (temp2-x)'-y1';
    end
    y;
    J = y / delta;
    inv(J);
    abs(eig(J));
    %   dx = J \(-y1')
    %   xs = xs + dx'*1
    dx = inv(J)*(-y1');
    xs = xs - dx';
    eold = y1;
    temp3 = step3(xs);
    if length(temp3) == 0
        xnew = [];
        cnvrg = 0;
        return
    end
    enew = temp3-xs;
    e = enew;
%     fprintf(1, '  e = %g\n', max(abs(e)));
    %   pause
    if max(abs(enew))  > max(abs(eold))
        cnvrg = 0;
%         fprintf(1,' could not converge\n');
        %     xs = xs - dx';
        break
    end
    cnvrg = 1;
    %   e = enew;
    %   fprintf(1, '  e = %g\n', max(abs(e)));
end

xnew = xs;

