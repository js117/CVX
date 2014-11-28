% GENERALIZED FUNTION APPROXIMATION BY FEATURES

% Fit (t1, t2, t3, t4) --> (a list of products of cos and sin of the ti's)

k = 250; % #of discrete domain points

t1 = zeros(k,1);
t2 = zeros(k,1);
t3 = zeros(k,1);
t4 = zeros(k,1);

t11 = zeros(k,1); 
t12 = zeros(k,1); 
t21 = zeros(k,1); 
t22 = zeros(k,1); 
t31 = zeros(k,1); 
t32 = zeros(k,1); 
t41 = zeros(k,1); 
t42 = zeros(k,1); 

% create all the necessary sum variables:
s1 = zeros(k,1); s2 = zeros(k,1); s3 = zeros(k,1); s4 = zeros(k,1);
% at worst, we have 43 combos for all 11 features

f1 = zeros(k,1);
f2 = zeros(k,1);
f3 = zeros(k,1);
f4 = zeros(k,1);
f5 = zeros(k,1);
f6 = zeros(k,1);
f7 = zeros(k,1);
f8 = zeros(k,1);
f9 = zeros(k,1);
f10 = zeros(k,1);
f11 = zeros(k,1);

% Limits below pertain to NAO H25 Humanoid Robot
% R SHOULDER PITCH
llim1 = -120*(pi/180); % set as desired
ulim1 = 120*(pi/180);
% R SHOULDER ROLL
llim2 = -76*(pi/180); % set as desired
ulim2 = 18*(pi/180);
% R ELBOW YAW
llim3 = -120*(pi/180); % set as desired
ulim3 = 120*(pi/180);
% R ELBOW ROLL
llim4 = 2*(pi/180); % set as desired
ulim4 = 89*(pi/180);


for i=1:k
    
   t1(i) = llim1 + (ulim1-llim1)*(i-1)/(k-1);% the linspace
   t2(i) = llim2 + (ulim2-llim2)*(i-1)/(k-1);% the linspace
   t3(i) = llim3 + (ulim3-llim3)*(i-1)/(k-1);% the linspace
   t4(i) = llim4 + (ulim4-llim4)*(i-1)/(k-1);% the linspace
   
end
% Creating "real" theta data: randomly shuffle the arrays:
%p = randperm(k);
%t1 = t1(p); t2 = t2(p); t3 = t3(p); t4 = t4(p);

% TESTING WITH REAL DATA (overwriting test data)
Y = E_simple; X = J_simple;
m = size(Y,1); n = size(X,1); T = size(Y,2);
ssFactor = 3; %subsample factor
Xss = zeros(n,floor(T/ssFactor));
Yss = zeros(m,floor(T/ssFactor));
for i=1:T
   if (mod(i,ssFactor) == 0)
       Yss(:,i/ssFactor) = Y(:,i); %subsample data 
       Xss(:,i/ssFactor) = X(:,i); %subsample data
   end
   % TODO - use deleted rows as test values
end
X = Xss; Y = Yss;
t1 = X(1,:)';
t2 = X(2,:)';
t3 = X(3,:)';
t4 = X(4,:)';
T = size(Y,2);
k = T; %update after the sampling
bias = ones(k,1);
Zbias = zeros(k,1);

% FEATURES
for i=1:k
   % pure cos/sin not really useful 
   t11(i) = sin(t1(i));
   t12(i) = cos(t1(i));
   t21(i) = sin(t2(i));
   t22(i) = cos(t2(i));
   t31(i) = sin(t3(i));
   t32(i) = cos(t3(i));
   t41(i) = sin(t4(i));
   t42(i) = cos(t4(i));
   
   s1(i) = sin(t1(i) + t2(i) - t4(i));
   s2(i) = sin(t1(i) - t2(i) + t4(i));
   s3(i) = sin(t1(i) + t2(i) + t4(i));
   s4(i) = sin(t1(i) - t2(i) - t4(i));
   
end

% TARGETS
for i=1:k
   f1(i) = sin(t4(i))*sin(t1(i))*sin(t3(i));
   f2(i) = sin(t4(i))*cos(t1(i))*cos(t3(i))*sin(t2(i));
   f3(i) = cos(t1(i))*cos(t2(i))*cos(t4(i));
   f4(i) = cos(t1(i))*cos(t2(i));
   f5(i) = cos(t4(i))*sin(t2(i));
   f6(i) = cos(t2(i))*cos(t3(i))*sin(t4(i));
   f7(i) = sin(t2(i));
   f8(i) = sin(t4(i))*cos(t1(i))*sin(t3(i));
   f9(i) = sin(t4(i))*cos(t3(i))*sin(t1(i))*sin(t2(i));
   f10(i) = cos(t2(i))*cos(t4(i))*sin(t1(i));
   f11(i) = cos(t2(i))*sin(t1(i));
end

% Optimization Routine below

X = [s1, s2, s3, s4]';
Y = [f10]';

T = k;
m = size(Y,1);
n = size(X,1);

cvx_begin
    variable W0(m,n)
    minimize norm(Y - W0*X, Inf)
cvx_end

avg_error = 0;
for i=1:T
    d = norm(Y(:,i)-W0*X(:,i),2);
    avg_error = avg_error + d;
    %if (d > 0.6)
    %    d
    %    i
    %end
end
avg_error = avg_error/T

% SECOND TEST - using CVX approx of 1-layer NN

% Matrix to represent all inner-angle additions of cosine arguments
M4 = [[1,1,1,1,0.1,0.1,0.1,0.7];
      [1,1,1,-1,0.2,0.2,0.2,0.4];
      [1,1,-1,1,0.3,0.3,0.3,0.1];
      [1,1,-1,-1,0.1,0.2,0.1,0.6];
      [1,-1,1,1,0.2,0.3,0.4,0.1];
      [1,-1,1,-1,0.4,0.18,0.1,0.32];
      [1,-1,-1,1,0.11,0.22,0.4,0.47];
      [1,-1,-1,-1,0.09,0.06,0.8,0.05]];
%M4_test = M4(:,1:4);
M4(:,5:8) = 0; %scratch that

% Only the first 4 columns matter at all, the last 4 are to make it square
% and invertible. E.g.
% theta = (t1, t2, t3, t4, 1, 1, 1, 1)
% When recovering inverse solutions, we only care for theta(1:4)

X = cos(M4*[t1, t2, t3, t4, Zbias, Zbias, Zbias, Zbias]');
Y = [(f2), Zbias, Zbias, Zbias, Zbias, Zbias, Zbias, Zbias]'; % product of 4 sin/cos terms --> sum of 8 cos (via identity)

T = k;
m = size(Y,1);
n = size(X,1);

cvx_begin
    variable W0(m,n)
    variables Z(m,T)
    
    minimize norm(Y - Z, 2)
    subject to 
            Z == W0*X
            %W0 == semidefinite(n)
            norm(W0) <= 1
            
    
cvx_end
figure; plot(Y(1,:)); figure; plot(Z(1,:));

% "Learned" the feature. Now we need to invert.
%W0(2:n,:) = 0;
pW0 = pinv(W0);
maxP = max(max(abs(pW0)));
temp = zeros(n,T);
for i=1:T
   temp(:,i) = pW0(:,1)*Y(1,i)/maxP;
   temp(:,i) = acos(temp(:,i));
   temp(:,i) = pinv(M4)*temp(:,i);
end
% want something like figure; plot(pM4(1,1)*acos(pW0(1,1)*Y(1,:)/maxP))
figure; plot(temp(1,:));