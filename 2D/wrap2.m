%
% Wrapper script for simulations
%

clear

global M Mp g L C slope dim

% M = 5; %.16; 
% Mp = 10; %0.68; 
% g = 9.8;
% L = 1; 
% C = 0.645;
% dim = 4;
% 
% % xi = [ S NS Sdot NSdot ];
% xi = [.01 0 -.43 2.23]
% delta = 1E-4;
% slope = pi/50; %-delta*10:delta:pi/50+delta*10
% % walk2(xi, 4);

pop

count = 20;
delta = 1E-3;

gamma = slope

j = 1;
fixed_point = [];
for jj=1:count
    xtry = xi;
    its = 1;
    for ii=1:4
        for i=1:length(gamma)
            slope = gamma(i);
            [xnew converge] = search2(xtry);
            if converge
                if (isnan(xnew) == [1 1 0 0])
                    fprintf(1, 'Not saving fixed point ... it DNE.\n');
                    continue
                end
                for c=1:5
                    if c == 5
                        fixed_point(j,5) = slope;
                    else
                        fixed_point(j,c) = xnew(c);
                    end
                end
                j = j + 1;
            end
        end
        if (length(fixed_point) ~= 0)
            fixed_point
        end
        fprintf(1, '\nFixing x(%i) of known fixed point, perturbing others.\n', ii);
        xtry = xi;
%         xtry(ii) = -xi(ii) +2*rand;
        xtry = xi + delta*(-1.5+3*rand);
        xtry(ii) = xi(ii);
        its = its + 1;
    end
end
% fprintf(1, '\nWalk 3 steps.');
% walk2(fixed_point(1,1:end-1), 3)
