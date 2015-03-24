% ECOS testing - verify that we can use ECOS to solve a problem in the same
% manner as we would solve one with CVX. 
% Source paper: https://web.stanford.edu/~boyd/papers/pdf/ecos_ecc.pdf

% Solve a SOCP of the form:
% (http://www.seas.ucla.edu/~vandenbe/236C/lectures/conic.pdf slide 14-7)
%
% minimize c'*x
% subject to 
%            ||Bk0*x + dk0||2 <= Bk1*x + dk1, k = 1,...,r
%
% We first have to learn how to put into the form:
%
% minimize c'*x
% subject to 
%            Ax = b
%            Gx + s = h, s ? K,
% K = Q(m1) x Q(m2) x ... x Q(mM)
%
% ... that is compatible with ECOS. 
%
% Define Q(m) == {(u0, u1) in R x R(m-1) | u0 >= ||u1||2 }
% The order of the cone K = Q(m1) x Q(m2) x ... x Q(mM) is:
% M = sum(i=1,..,r)[mi]
% e.g. for r = 5 SOC constraints in x, variable x of dim 100 (don't care),
% and mi = [15, 14, 13, 12, 10], (mi is dim of each SOC constraint)
% M = 14 + 13 + 12 + 11 + 9 = 59
% (however note that size of x directly affects G and h matrix/vector)

n = 10;
mi_vec = [15, 14, 13, 12, 11];
r = size(mi_vec, 2);
M = sum(mi_vec - 1);

c = rand(n,1);
Bk0_mat = cell(r,1); % each of size (mi_vec(i)-1) x n
dk0_vec = cell(r,1); % (mi - 1) x 1
Bk1_vec = cell(r,1); % each is 1 x n 
dk1_scalar = cell(r,1); % each is 1 x 1

for i=1:r
    Bk0_mat{i} = rand(mi_vec(i)-1, n);
    dk0_vec{i} = rand(mi_vec(i)-1, 1);
    Bk1_vec{i} = rand(1,n);
    dk1_scalar{i} = rand(1,1) + n; % so our random data will probably give a feasible result
    % e.g. we make the norm constraint "easy" to handle on average.
end

% Construct h and G as per slide 14-7, http://www.seas.ucla.edu/~vandenbe/236C/lectures/conic.pdf
numRows = 0;
for i=1:r
    numRows = numRows + (mi_vec(i) - 1) + 1; % useless algebra meant to be symbolic of what we're actually doing
end

h = zeros(numRows,1);
G = zeros(numRows,n);

% Now fill 'em:
jStart = 1;
for i=1:r
   % oh lord the indexing
   mi = mi_vec(i);
   % Compute end for current concat:
   jStop = jStart + mi - 2;
   
   %h(jStart : jStop) = dk0_vec{i};
   %h(jStop + 1) = dk1_scalar{i};
   h(jStart) = dk1_scalar{i};
   h(jStart + 1 : jStop + 1) = dk0_vec{i};
   
   %G(jStart : jStop, :) = -Bk0_mat{i};
   %G(jStop + 1, :) = -Bk1_vec{i}; 
   G(jStart, :) = -Bk1_vec{i};
   G(jStart + 1 : jStop + 1, :) = -Bk0_mat{i};
   
   
   % Compute start for the next concat:
   jStart = jStop + 2;
end

% Solve problem instance with CVX: 

cvx_begin
    variable x(n)
    minimize (c'*x) 
    subject to
        for i=1:r
           norm(Bk0_mat{i}*x + dk0_vec{i}, 2) <= Bk1_vec{i}*x + dk1_scalar{i} 
        end
        ones(1,n)*x == 1
cvx_end

p_star_cvx = cvx_optval;
x_star_cvx = x;

% Try with ECOS:
% Reference: https://www.embotech.com/ECOS/Matlab-Interface/Matlab-Native

A = ones(1,n);
b = 1;
dims.l = 0;
dims.q = mi_vec;
opts = struct(); % don't need?

[x_star_ecos,y_star_ecos,info,s,z] = ecos(c,sparse(G),h,dims,sparse(A),b);
p_star_ecos = info.pcost;


% Moment of truth: can two solvers give us the same answer?
