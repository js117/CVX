n = 10;

m = 45;

m_test = 45;

sigma= 0.250;

train=[1 2 1;
1 3 1;
1 4 1;
1 5 1;
1 6 1;
1 7 1;
1 8 1;
1 9 1;
1 10 1;
2 3 -1;
2 4 -1;
2 5 -1;
2 6 -1;
2 7 -1;
2 8 -1;
2 9 -1;
2 10 -1;
3 4 1;
3 5 -1;
3 6 -1;
3 7 1;
3 8 1;
3 9 1;
3 10 1;
4 5 -1;
4 6 -1;
4 7 1;
4 8 1;
4 9 -1;
4 10 -1;
5 6 1;
5 7 1;
5 8 1;
5 9 -1;
5 10 1;
6 7 1;
6 8 1;
6 9 -1;
6 10 -1;
7 8 1;
7 9 1;
7 10 -1;
8 9 -1;
8 10 -1;
9 10 1;
];

test=[1 2 1;
1 3 1;
1 4 1;
1 5 1;
1 6 1;
1 7 1;
1 8 1;
1 9 1;
1 10 1;
2 3 -1;
2 4 1;
2 5 -1;
2 6 -1;
2 7 -1;
2 8 1;
2 9 -1;
2 10 -1;
3 4 1;
3 5 -1;
3 6 1;
3 7 1;
3 8 1;
3 9 -1;
3 10 1;
4 5 -1;
4 6 -1;
4 7 -1;
4 8 1;
4 9 -1;
4 10 -1;
5 6 -1;
5 7 1;
5 8 1;
5 9 1;
5 10 1;
6 7 1;
6 8 1;
6 9 1;
6 10 1;
7 8 1;
7 9 -1;
7 10 1;
8 9 -1;
8 10 -1;
9 10 1;
];

% S = sparse(i,j,s,m,n): S(i(k), j(k)) = s(k)
% i.e. i,j are index vectors, s is value at those indices
A = sparse(1:m,train(:,1),train(:,3),m,n) + ...
    sparse(1:m,train(:,2),-train(:,3),m,n);
% adding makes sense because no games are double-counted in original data

cvx_begin
    variable a(n);
    variable x(m);
    maximize sum(log_normcdf((1/sigma)*x));
    subject to
        x == A*a;
        0 <= a <= 1;
cvx_end

% Now use the vector a to predict the test outcomes:
numPredictedRight = 0;
for i=1:m
   team1 = test(i,1); team2 = test(i,2); result = test(i,3);
   jBetter = a(team1) > a(team2);
   if (jBetter && result == 1) numPredictedRight = numPredictedRight + 1; end
   if (jBetter==0 && result == -1) numPredictedRight = numPredictedRight + 1; end
end

testAccuracy = numPredictedRight / m; %86.7%

ifUsingOldAccuracy = 1 - nnz(test(:,3)-train(:,3))/m; %75.6%

