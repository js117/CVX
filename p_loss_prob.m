% given constants for gaussian distributions R1, R2
u1 = 8; sigma1 = 6; u2 = 20; sigma2 = 17.5; rho = -0.25;
n = 100;
rmin = -30; rmax = 70;

r = linspace(rmin,rmax,n)'; %create a col vector of n uniformly spaced values b/w rmin and rmax

% the following is roughly equivalent to linspace:
% rtest = zeros(n,1);
% incr = (rmax-rmin)/(n-1);
% rtest = rmin + (0:n-1)'.*incr;

p1 = exp(-(r-u1).^2/(2*sigma1^2)); p1 = p1/sum(p1);
p2 = exp(-(r-u2).^2/(2*sigma2^2)); p2 = p2/sum(p2);

r1p = r*ones(1,n); r2p = ones(n,1)*r';
loss_mask = r1p + r2p; %matrix with all possible ri + rj values
% cool thing: 2d matrix value "heatmap": figure; imagesc(X);
for i=1:n
    for j=1:n
        if (loss_mask(i,j) > 0)
            loss_mask(i,j) = 0;
        else
            loss_mask(i,j) = 1; %indicator matrix for ri + rj <= 0
                               
        end
    end
end

loss_mask_vec = loss_mask(:); % concatenates column vectors into single long vector

P_convert_ones = zeros(n, n*n); %this is the matrix A s.t. p1 == A*P_vec (vector)
P_convert_ones_2 = zeros(n, n*n); %this is the matrix A s.t. p2 == A*P_vec (vector)
P_convert_r = zeros(n, n*n); %this is the matrix A s.t. r'Pr == r'*A*P_vec (scalar)
for i=1:n
   start_lim = n*(i-1)+1; 
   % e.g. min: 100*(0)+1 == 1; max: 100*(99)+1 == 9901
   end_lim = n*i; 
   % e.g. min: 100; max: 10000
   
   for j=start_lim:end_lim
       P_convert_ones(i,j) = 1;
       P_convert_r(i,j) = r(mod(j-1,n)+1); % tricky indexing to get r vector in there as we iterate over j
   end
   
   lim2 = n*n;
   j = 1;
   while j < lim2 %obviously we can go a bit faster by combining part of this loop with above.. but a bit messy
        P_convert_ones_2(i,j+i-1) = 1;
        j = j + 100;
   end
   
end

% Optimization routine
cvx_begin

    variable P_vec(n*n);
    
    minimize (-1*loss_mask_vec'*P_vec);
    
    subject to 
        P_vec >= 0;
        P_convert_ones*P_vec == p1;
        P_convert_ones_2*P_vec == p2;
        r'*P_convert_r*P_vec - u1*u2 == rho*sigma1*sigma2;
    
cvx_end

opt_val = -1*cvx_optval;

% My own vec2mat
P_mat = zeros(n,n);
for i=1:n
    for j=1:n
        P_mat(i,j) = P_mat(i,j) + P_vec((i-1)*n + j);
    end
end

figure; plot(P_vec);
figure; mesh(r1p, r2p, P_mat');
figure; contour(r1p, r2p, P_mat');
