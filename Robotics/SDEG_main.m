% SDEG - Symbolic Dynamical Equation Generator
% 
% Explicitly creates the model M(p)p_dd + C(p,p_d)p_d + N(p,p_d)p = tau
% for an open link robotic manipulator with n degrees of freedom
%
% p - angular position vector; n x 1
% p_d, p_dd - 1st and 2nd time derivatives respectively; n x 1
% M - inertia matrix; n x n
% C - coriolis matrix (coriolis and centrifugal force terms); n x n
% N = gradV + beta*p_d - gravity and friction force vector; n x 1
% tau - externally applied joint torques, n x 1

% STEP 1 - specify twist axes e1,...,en



% STEP 2 - specify reference / stationary transforms to links at p = 0:
% e.g 
% gsl10 = ...; gsl20 = ...; gsl30 = ...; ... gsln0 = ...;



% STEP 3 - calculate body Jacobians
% e.g
% twists = [e1,e2,e3,...,en];
% Jbsl1 = BodyJacobianForLink(twists, gsl10); 
% Jbsli = BodyJacobianForLink(twists, gsli0);
% Jbsln = BodyJacobianForLink(twists, gsln0);



% STEP 4 - M(p)
% Mi = [mi,0,0;0,mi,0;0,0,mi;Ii,0,0;0,Ii,0;0,0,Ii]; for 1,...,n
% M = Jbsl1'*M1*Jbsl1
% M = M + Jbsl2'*M2*Jbsl2 ...
% M = M + Jbsln'*Mn*Jbsln