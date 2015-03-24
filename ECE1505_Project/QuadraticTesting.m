% Experiment optimizing over nonconvex quadratic forms

n = 5;

P1 = rand(n,n)-0.5; P1 = P1/2 + P1'/2;
P2 = rand(n,n)-0.5; P2 = P2/2 + P2'/2;
P3 = rand(n,n)-0.5; P3 = P3/2 + P3'/2;
P4 = rand(n,n)-0.5; P4 = P4/2 + P4'/2;
P5 = rand(n,n)-0.5; P5 = P5/2 + P5'/2;
P6 = rand(n,n)-0.5; P6 = P6/2 + P6'/2;
[E1, D1] = eigs(P1);
[E2, D2] = eigs(P2);
[E3, D3] = eigs(P3);
[E4, D4] = eigs(P4);
[E5, D5] = eigs(P5);
[E6, D6] = eigs(P6);
q1 = rand(n,1)-0.5;
q2 = rand(n,1)-0.5;
q3 = rand(n,1)-0.5;
q4 = rand(n,1)-0.5;
q5 = rand(n,1)-0.5;
q6 = rand(n,1)-0.5;
r1 = rand(1,1)-0.5;
r2 = rand(1,1)-0.5;
r3 = rand(1,1)-0.5;
r4 = rand(1,1)-0.5;
r5 = rand(1,1)-0.5;
r6 = rand(1,1)-0.5;
x = zeros(n,1);

f1 = x'*P1*x + q1'*x + r1;
f2 = x'*P2*x + q2'*x + r2;
f3 = x'*P3*x + q3'*x + r3;
f4 = x'*P4*x + q4'*x + r4;
f5 = x'*P5*x + q5'*x + r5;
f6 = x'*P6*x + q6'*x + r6;
