% Test QuadraticToSOC constraints
clear P1 P2 P3 P4 P5 P6
% Create a few constraints 
n = 100;

P1 = rand(n,n)-0.5; P1 = P1/2 + P1'/2; P1 = P1 + n*eye(n); % ensures P1 >= 0
P2 = rand(n,n)-0.5; P2 = P2/2 + P2'/2; P2 = P2 + n*eye(n);
P3 = rand(n,n)-0.5; P3 = P3/2 + P3'/2; P3 = P3 + n*eye(n);
P4 = rand(n,n)-0.5; P4 = P4/2 + P4'/2; P4 = P4 + n*eye(n);
P5 = rand(n,n)-0.5; P5 = P5/2 + P5'/2; P5 = P5 + n*eye(n);
P6 = rand(n,n)-0.5; P6 = P6/2 + P6'/2; P6 = P6 + n*eye(n);

q1 = rand(n,1)-0.5;
q2 = rand(n,1)-0.5;
q3 = rand(n,1)-0.5;
q4 = rand(n,1)-0.5;
q5 = rand(n,1)-0.5;
q6 = rand(n,1)-0.5;

r1 = rand(1,1)-0.5 - n;
r2 = rand(1,1)-0.5 - n;
r3 = rand(1,1)-0.5 - n;
r4 = rand(1,1)-0.5 - n;
r5 = rand(1,1)-0.5 - n;
r6 = rand(1,1)-0.5 - n;

c = rand(n,1);

% Test program with quadratic constraints
cvx_begin
    variable x(n)
    minimize (c'*x);
    subject to
        0.5*x'*P1*x + q1'*x + r1 <= 0;
        0.5*x'*P2*x + q2'*x + r2 <= 0;
        0.5*x'*P3*x + q3'*x + r3 <= 0;
        0.5*x'*P4*x + q4'*x + r4 <= 0;
        0.5*x'*P5*x + q5'*x + r5 <= 0;
        0.5*x'*P6*x + q6'*x + r6 <= 0;
        ones(1,n)*x == 1;
cvx_end

opt_1 = cvx_optval;
x_1 = x;

% Now convert to SOC constraints and re-test:

[Bk0_1, dk0_1, bk1_1, dk1_1] = QuadraticToSOC(P1, q1, r1);
[Bk0_2, dk0_2, bk1_2, dk1_2] = QuadraticToSOC(P2, q2, r2);
[Bk0_3, dk0_3, bk1_3, dk1_3] = QuadraticToSOC(P3, q3, r3);
[Bk0_4, dk0_4, bk1_4, dk1_4] = QuadraticToSOC(P4, q4, r4);
[Bk0_5, dk0_5, bk1_5, dk1_5] = QuadraticToSOC(P5, q5, r5);
[Bk0_6, dk0_6, bk1_6, dk1_6] = QuadraticToSOC(P6, q6, r6);

cvx_begin
    variable x(n)
    minimize (c'*x);
    subject to
        norm(Bk0_1*x + dk0_1, 2) <= bk1_1*x + dk1_1;
        norm(Bk0_2*x + dk0_2, 2) <= bk1_2*x + dk1_2;
        norm(Bk0_3*x + dk0_3, 2) <= bk1_3*x + dk1_3;
        norm(Bk0_4*x + dk0_4, 2) <= bk1_4*x + dk1_4;
        norm(Bk0_5*x + dk0_5, 2) <= bk1_5*x + dk1_5;
        norm(Bk0_6*x + dk0_6, 2) <= bk1_6*x + dk1_6;
        ones(1,n)*x == 1;
cvx_end

opt_2 = cvx_optval;
x_2 = x;

figure; plot(norm(x_1 - x_2));
norm(opt_1 - opt_2)

% Good to go!

