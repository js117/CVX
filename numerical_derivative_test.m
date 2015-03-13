% test

T = 100;
N = 100000;
h = 1; %T/N;
test = zeros(T,1);
dtest = zeros(T,1);
ddtest = zeros(T,1);

for i=1:T
    j = i - T/2;
   test(i) = cos(j);
end

for i=2:T-1
   dtest(i) = 1/h * (test(i+1) - test(i-1));
   ddtest(i) = 1/(h*h) * (test(i+1) - 2*test(i) + test(i-1));
end
dtest(T) = 1/h * (test(T) - test(T-1));
ddtest(T) = 1/(h*h) * (test(T) - 2*test(T-1) + test(T-2));

t = 1:T;
figure; plot(t,test,t,dtest,t,ddtest);