% FIT BETWEEN ANGULAR FEATURES AND END-EFFECTOR POSITION DATA

% TESTING WITH REAL DATA (overwriting test data)
Y = EndEffectorTestRef; X = JointAngleTestRef;
Y(4,:) = tan(Y(4,:));
Y(5,:) = tan(Y(5,:));
Y(6,:) = tan(Y(6,:));
	
ssFactor = 4; %subsample factor
ssFactorTransition = 10; %subsample factor
Xss = zeros(n,floor(T/ssFactor)); Xtr = zeros(n,floor(T/ssFactorTransition));
Yss = zeros(m,floor(T/ssFactor)); Ytr = zeros(n,floor(T/ssFactorTransition));
for i=1:T
   if (mod(i,ssFactor) == 0)
       Yss(:,i/ssFactor) = Y(:,i); %subsample data 
       Xss(:,i/ssFactor) = X(:,i); %subsample data
   end
   %if (mod(i,ssFactorTransition) == 0)
   %    Ytr(:,i/ssFactorTransition) = Y(:,i); %subsample data 
   %    Xtr(:,i/ssFactor) = X(:,i); %subsample data
   %end
   % TODO - use deleted rows as test values
end
X = Xss; Y = Yss;
t1 = X(1,:)';
t2 = X(2,:)';
t3 = X(3,:)';
t4 = X(4,:)';
t5 = X(5,:)';
T2 = ceil(T/ssFactorTransition);
T = size(Y,2); 
k = T; %update after the sampling
bias = ones(k,1);
Zbias = zeros(k,1);


% FEATURES
f1 = zeros(k,1); f1tr = zeros(T2,1);
f2 = zeros(k,1); f2tr = zeros(T2,1);
f3 = zeros(k,1); f3tr = zeros(T2,1);
f4 = zeros(k,1); f4tr = zeros(T2,1); 
f5 = zeros(k,1); f5tr = zeros(T2,1);
f6 = zeros(k,1); f6tr = zeros(T2,1);
f7 = zeros(k,1); f7tr = zeros(T2,1);
f8 = zeros(k,1); f8tr = zeros(T2,1);
f9 = zeros(k,1); f9tr = zeros(T2,1);
f10 = zeros(k,1); f10tr = zeros(T2,1);
f11 = zeros(k,1); f11tr = zeros(T2,1);
f12 = zeros(k,1); f13 = zeros(k,1); f14 = zeros(k,1); f15 = zeros(k,1); f16 = zeros(k,1);
f17 = zeros(k,1); f18 = zeros(k,1); f19 = zeros(k,1); f20 = zeros(k,1); f21 = zeros(k,1);
f22 = zeros(k,1); f23 = zeros(k,1); f24 = zeros(k,1); f25 = zeros(k,1); f26 = zeros(k,1);
for i=1:T
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
   
   % Below: terrible features to help the angle matching...
%    f12(i) = sin(t5(i))*sin(t4(i))*cos(t3(i))*sin(t2(i))*cos(t1(i));
%    f13(i) = sin(t5(i))*cos(t4(i))*sin(t3(i))*cos(t2(i))*sin(t1(i));
%    f14(i) = sin(t5(i))*sin(t4(i))*cos(t3(i))*cos(t2(i))*cos(t1(i));
%    f15(i) = sin(t5(i))*cos(t4(i))*sin(t3(i))*sin(t2(i))*sin(t1(i));
%    f16(i) = sin(t5(i))*sin(t4(i))*cos(t3(i))*sin(t2(i))*cos(t1(i));
%    f17(i) = sin(t5(i))*cos(t4(i))*sin(t3(i))*cos(t2(i))*sin(t1(i));
%    f18(i) = sin(t5(i))*sin(t4(i))*cos(t3(i))*cos(t2(i))*cos(t1(i));
%    f19(i) = sin(t5(i))*cos(t4(i))*sin(t3(i))*sin(t2(i))*sin(t1(i));
%    f20(i) = sin(t5(i))*sin(t4(i))*cos(t3(i))*sin(t2(i))*cos(t1(i));

end

%%%%%%%%%%%%%% Features based on actual forward kinematics %%%%%%%%%%%%%%%%
z1 = 0.105; %in m 
z2 = 0.1138; 
y1 = -0.05; %5 cm

f1 = ones(k,1);
f2 = z2*(sin(t4).*(sin(t1).*sin(t3) - cos(t1).*cos(t3).*sin(t2)) + cos(t1).*cos(t2).*cos(t4)) - z1*cos(t1).*cos(t2);
f3 = y1 + z2*(cos(t4).*sin(t2) + cos(t2).*cos(t3).*sin(t4)) - z1*sin(t2); 
f4 = -z2*(sin(t4).*(cos(t1).*sin(t3) + cos(t3).*sin(t1).*sin(t2)) - cos(t2).*cos(t4).*sin(t1)) - z1.*cos(t2).*sin(t1);
f5 = atan(-(sin(t5).*(cos(t4).*(cos(t1).*sin(t3) + cos(t3).*sin(t1).*sin(t2)) + cos(t2).*sin(t1).*sin(t4)) + cos(t5).*(cos(t1).*cos(t3) - sin(t1).*sin(t2).*sin(t3)))./(sin(t4).*(cos(t1).*sin(t3) + cos(t3).*sin(t1).*sin(t2)) - cos(t2).*cos(t4).*sin(t1)));
f6 = atan((cos(t5).*(cos(t4).*(cos(t1).*sin(t3) + cos(t3).*sin(t1).*sin(t2)) + cos(t2).*sin(t1).*sin(t4)) - sin(t5).*(cos(t1).*cos(t3) - sin(t1).*sin(t2).*sin(t3)))./((sin(t4).*(cos(t1).*sin(t3) + cos(t3).*sin(t1).*sin(t2)) - cos(t2).*cos(t4).*sin(t1)).^2 + (sin(t5).*(cos(t4).*(cos(t1).*sin(t3) + cos(t3).*sin(t1).*sin(t2)) + cos(t2).*sin(t1).*sin(t4)) + cos(t5).*(cos(t1).*cos(t3) - sin(t1).*sin(t2).*sin(t3))).^2).^(1/2));
f7 = atan(-(cos(t5).*(sin(t2).*sin(t4) - cos(t2).*cos(t3).*cos(t4)) - cos(t2).*sin(t3).*sin(t5))./(cos(t5).*(cos(t4).*(sin(t1).*sin(t3) - cos(t1).*cos(t3).*sin(t2)) - cos(t1).*cos(t2).*sin(t4)) - sin(t5).*(cos(t3).*sin(t1) + cos(t1).*sin(t2).*sin(t3))));

% these features don't work much better either, even though they come
% straight from fwd kin...

F = [f1, f2, f3, f4, f5, f6, f7]';
%Ftr = [f1tr, f2tr, f3tr, f4tr, f5tr, f6tr, f7tr, f8tr, f9tr, f10tr, f11tr]';
T = k;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fit end effector %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Y1 = Y(1,:);
m = size(Y,1);
n = size(F,1);
Diff = zeros(m,m); %create a matrix to minimize ||Z(t) - Z(t-1)||, the
% transition amount
% if z = (z1, z2, z3, z4, z5, z6)', Diff*z = (z1, z1, z2, z3, z4, z5)
Diff(1,1) = 1;
for i=2:m
    Diff(i,i-1) = 1;
end
tau = 0; % the amount (%) of first samples we don't care about
start = ceil(tau*T2);
if (start < 1) start = 1; end
start = 2; %override
cvx_begin
    variable W0(m,n)
    variables Z(m,T)
    %variables Ztr(m,T2) Zdiff(m,T2)
    
    minimize norm(Y - Z, 2) %+ 0.15*norm(Ztr(:,start:T2)-Zdiff(:,start:T2),2)
    subject to 
            Z == W0*F
            %Ztr == W0*Ftr
            %Zdiff == Diff*Ztr
    
cvx_end
figure; plot(Y(1,:)); figure; plot(Z(1,:));
for i=1:6
    figure;plot(abs(Y(i,:)-Z(i,:))); %error
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% solve for py %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Y2 = Y(2,:);
% m = size(Y2,1);
% n = size(F,1);
% cvx_begin
%     variable W2(m,n)
%     variables Z2(m,T)
%     %variables Ztr(m,T2) Zdiff(m,T2)
%     
%     minimize norm(Y2 - Z2, 2) %+ 0.15*norm(Ztr(:,start:T2)-Zdiff(:,start:T2),2)
%     subject to 
%             Z2 == W2*F
%             %Ztr == W0*Ftr
%             %Zdiff == Diff*Ztr
%     
% cvx_end
% figure; plot(Y2(1,:)); figure; plot(Z2(1,:));
% figure;plot(abs(Y2(1,:)-Z2(1,:))); %error
