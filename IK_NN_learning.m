% test script

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

% recalculate data sizes
m = size(Y,1);
T = size(Y,2);

% form features
n = 25; % number of features
t1 = zeros(T,1); t2 = zeros(T,1); t3 = zeros(T,1); t4 = zeros(T,1); t5 = zeros(T,1);
t6 = zeros(T,1); t7 = zeros(T,1); t8 = zeros(T,1); t9 = zeros(T,1); t10 = zeros(T,1);
t11 = zeros(T,1); t12 = zeros(T,1); t13 = zeros(T,1); t14 = zeros(T,1); t15 = zeros(T,1);
t16 = zeros(T,1); t17 = zeros(T,1); t18 = zeros(T,1); 

t19 = ones(T,1);
t20 = ones(T,1);
t21 = ones(T,1);
t22 = ones(T,1);
t23 = ones(T,1);
t24 = ones(T,1);
t25 = ones(T,1);

%t19 = zeros(T,1); t20 = zeros(T,1);
%t21 = zeros(T,1); t22 = zeros(T,1); t23 = zeros(T,1); t24 = zeros(T,1); t25 = zeros(T,1);
%t26 = zeros(T,1); t27 = zeros(T,1); t28 = zeros(T,1); %t24 = zeros(T,1); t25 = zeros(T,1);

for i=1:T
   t1(i) = sin(X(1,i)); 
   t2(i) = sin(X(2,i));
   t3(i) = sin(X(3,i));
   t4(i) = sin(X(4,i));
   t5(i) = sin(X(5,i));
   t6(i) = cos(X(1,i));
   t7(i) = cos(X(2,i));
   t8(i) = cos(X(3,i));
   t9(i) = cos(X(4,i));
   t10(i) = cos(X(5,i)); 
   t11(i) = sin(X(1,i)+X(2,i));
   t12(i) = sin(X(2,i)+X(3,i));
   t13(i) = sin(X(3,i)+X(4,i));
   t14(i) = sin(X(4,i)+X(5,i));
   t15(i) = cos(X(1,i)+X(2,i));
   t16(i) = cos(X(2,i)+X(3,i));
   t17(i) = cos(X(3,i)+X(4,i));
   t18(i) = cos(X(4,i)+X(5,i));
   
 
end

X = [t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,t21,t22,t23,t24,t25]';%,t19,t20,t21,t22,t23,t24,t25,t26,t27,t28]';

disp('Problem sizes: ');
m
n
T

cvx_begin
    variable W0(m,n)    
    minimize norm(Y - W0*X, 2)
cvx_end
optval1 = cvx_optval;

H = (W0*X);

cvx_begin
    variable W1(m,m)    
    minimize norm(Y - W1*H, Inf)
cvx_end
optval2 = cvx_optval;

Z = W1*H;

cvx_begin
    variable W2(m,m)    
    minimize norm(Y - W2*Z, Inf)
cvx_end
optval3 = cvx_optval;

optval1
optval2
optval3

avg_error = 0;
for i=1:T
    d = norm(Y(:,i)-W2*W1*(W0*X(:,i)),2);
    avg_error = avg_error + d;
    %if (d > 0.6)
    %    d
    %    i
    %end
end
avg_error = avg_error/T