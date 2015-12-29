
#include "math.h"
#include "mdefs.h"
#include "mex.h"
#include "string.h"

void mexFunction( int nlhs, mxArray *plhs[], 
                    int nrhs, const mxArray *prhs[] ) {

/* ****************************** */
/* Declare pointers and variables */
/* ****************************** */
    const int dim = 4;
    int rows, cols;
    double M, Mp, g, L, slope, guard, R; /* The constants ... */
    mxArray *M_ptr, *Mp_ptr, *g_ptr, *L_ptr, *slope_ptr, *R_ptr; /* ... and their counterparts. */
    char flag;
    double q1, q2; /* Angles */
    double q1dot, q2dot, q1dotnew, q2dotnew; /* Angle velocities */
    double q1dotdot, q2dotdot; /* Angle accels */
    plhs[0] = mxCreateDoubleMatrix(4, 1, mxREAL);
    
/* ************ */
/* Parse inputs */
/* ************ */      
    if (mxGetM(prhs[0]) == dim || mxGetN(prhs[0]) == dim) {
        q1 = mxGetPr(prhs[0])[0];
        q2 = mxGetPr(prhs[0])[1];
        q1dot = mxGetPr(prhs[0])[2];
        q2dot = mxGetPr(prhs[0])[3];
        if (nrhs == 2) {
            if (mxIsChar(prhs[1])) {
                flag = *mxGetChars(prhs[1]);
            } else {
                mexErrMsgTxt("If the 1st input is the state vector, the 2nd must be the flag 's' or 'i'.");
            }
        } else if (nrhs == 1) {
            flag = 's';
        } else {
            mexErrMsgTxt("If the 1st input is the state vector, you can only have 2 inputs and the 2nd must be the flag 's' or 'i'.");
        }
    } else if (mxGetM(prhs[1]) == dim || mxGetN(prhs[1]) == dim) {
        q1 = mxGetPr(prhs[1])[0]; 
        q2 = mxGetPr(prhs[1])[1]; 
        q1dot = mxGetPr(prhs[1])[2]; 
        q2dot = mxGetPr(prhs[1])[3];
        if (nrhs == 2) {
            flag = 's';
        } else if (nrhs == 3) {
            if (mxIsChar(prhs[1])) {
                flag = *mxGetChars(prhs[1]);
            } else {
                mexErrMsgTxt("If the 1st input is time, from ode45, and the 2nd is the state vector, then the 3rd must be the flag 's' or 'i'.");
            }
        } else {
            mexErrMsgTxt("If the 2nd input is the state vector, you can only have 3 inputs and the 3rd must be the flag 's' or 'i'. The 1st can be anything.");
        }
    } else {
        mexErrMsgTxt("The input state vector must be either the 1st or the 2nd argument, only.");
    }
    
    /* Are the global variables defined appropriately? */ 
    M_ptr = mexGetVariable("global", "M"); 
    Mp_ptr = mexGetVariable("global", "Mp"); 
    g_ptr = mexGetVariable("global", "g"); 
    L_ptr = mexGetVariable("global", "L"); 
    R_ptr = mexGetVariable("global", "R"); 
    slope_ptr = mexGetVariable("global", "slope");

    if (M_ptr == NULL || Mp_ptr == NULL || g_ptr == NULL || L_ptr == NULL || slope_ptr == NULL || R_ptr == NULL) {
        mexErrMsgTxt("The global workspace must contain the variables M, Mp, g, L and slope.");
    } else {    
        M = mxGetScalar(M_ptr);
        Mp = mxGetScalar(Mp_ptr);
        g = mxGetScalar(g_ptr);
        L = mxGetScalar(L_ptr);
	R = mxGetScalar(R_ptr);
        slope = mxGetScalar(slope_ptr);
    }
    
    /* Make sure that we know what it is we're supposed to be doing. */
    if (flag != 's' && flag != 'i' && flag != 'g') {
        flag = 's';
        mexPrintf("\n Bad inputs! Calculating equations of state by default. \n");
    }
           
/* ******************* */
/* Solve for new state */
/* ******************* */
    if (flag == 'i') {
        
/* mexPrintf("Computing state after impact."); */
/* ********************************************************************* */
        q1dotnew = ((-1 + 2*L)*M*q2dot*(1 - 2*R*Cos(q1 + q2) + 2*R*Cos(2*(q1 + q2))) + 2*q1dot*(M*Power(R,2) + R*(M + 2*(M + Mp)*R)*Cos(q1) + R*(M + 2*L*M + 2*L*Mp - 3*M*R - 2*Mp*R)*Cos(2*q1) - L*M*Cos(q1 - q2) - 2*Power(L,2)*Mp*Cos(q1 - q2) + 2*L*Mp*R*Cos(q1 - q2) + 2*M*Power(R,2)*Cos(q1 - q2) + L*M*R*Cos(2*q1 - q2) - M*Power(R,2)*Cos(2*q1 - q2) - M*R*Cos(q2) - L*M*R*Cos(q2) - 2*L*Mp*R*Cos(q2) - M*Power(R,2)*Cos(q2) - 4*M*Power(R,2)*Cos(2*q1 + q2) - 2*Mp*Power(R,2)*Cos(2*q1 + q2) + R*(2*Mp*(-L + R) + M*(-1 - 2*L + 4*R))*Cos(3*q1 + q2)))/(M*(-1 - 2*Power(L,2) + 4*L*R + 4*(1 - 3*R)*R) - 4*Mp*(Power(L,2) - 2*L*R + 2*Power(R,2)) + 4*R*(-(M*(1 + L - 3*R)) + 2*Mp*(-L + R))*Cos(q2) + 2*M*Cos(2*q1)*(Power(R,2) + 2*(L - R)*R*Cos(q2) + Power(L - R,2)*Cos(2*q2)) + 4*M*(L - R)*(R + (L - R)*Cos(q2))*Sin(2*q1)*Sin(q2));
        q2dotnew = (2*(-1 + 2*L)*M*q2dot*(R*Cos(q1) + (L - R)*Cos(q1 - q2))*(1 - 2*R*Cos(q1 + q2) + 2*R*Cos(2*(q1 + q2))) + q1dot*(-4*(-1 + L)*Power(L,2)*Mp + 4*Mp*(L - R)*R*(-2 + 3*R) + M*(1 - 2*R*(3 + L + 2*Power(L,2) - 6*L*R + R*(-11 + 12*R))) + 2*(R*((M - L*M + 2*Power(L,2)*M + 2*Power(L,2)*Mp - 2*(M + 2*L*M + 2*L*Mp)*R + 6*(2*M + Mp)*Power(R,2))*Cos(q1) + 2*(2*M + Mp)*Power(R,2)*Cos(2*q1) + (1 - 2*L)*M*R*Cos(3*q1) - (L - R)*(M + 2*L*M + 2*L*Mp - 2*(2*M + Mp)*R)*Cos(4*q1)) + R*(-2*Mp*(L - R)*(-2 + L + 3*R) + M*(2 + 2*L - 11*R - 2*L*R + 12*Power(R,2)) + (2*Power(L,2)*(M + Mp) + L*(M - 2*M*R) + R*(M - 8*(2*M + Mp)*R))*Cos(q1) - 2*L*(M + L*Mp - (2*M + Mp)*R)*Cos(2*q1) + (L*(M + 2*L*M + 2*L*Mp) - (M + 6*L*M + 4*L*Mp)*R)*Cos(3*q1) + R*(2*Mp*(-L + R) + M*(-1 - 2*L + 4*R))*Cos(4*q1))*Cos(q2) - (L - R)*(R*(2*Mp*(L + R) + M*(1 + 2*L + 4*R))*Cos(q1) + 2*(L*(M + L*Mp) - (2*M + Mp)*Power(R,2))*Cos(2*q1))*Cos(2*q2) - 2*R*((2*L*(M + L*Mp) - ((3 + 10*L)*M + 8*L*Mp)*R + 6*(2*M + Mp)*Power(R,2))*Cos(q1) - (L*(M + 2*L*M + 2*L*Mp) - (M + 6*L*M + 4*L*Mp)*R + 4*(2*M + Mp)*Power(R,2))*Cos(2*q1) + R*(-2*(2*M + Mp)*R - (M + 2*L*M + 2*L*Mp - 2*(2*M + Mp)*R)*Cos(3*q1)))*Sin(q1)*Sin(q2) + (-L + R)*(R*(M + 2*L*M + 2*L*Mp - 2*(2*M + Mp)*R) + 4*(L - R)*(M + L*Mp - (2*M + Mp)*R)*Cos(q1))*Sin(q1)*Sin(2*q2))))/((-1 + 2*L)*(M*(-1 - 2*Power(L,2) + 4*L*R + 4*(1 - 3*R)*R) - 4*Mp*(Power(L,2) - 2*L*R + 2*Power(R,2)) + 4*R*(-(M*(1 + L - 3*R)) + 2*Mp*(-L + R))*Cos(q2) + 2*M*Cos(2*q1)*(Power(R,2) + 2*(L - R)*R*Cos(q2) + Power(L - R,2)*Cos(2*q2)) + 4*M*(L - R)*(R + (L - R)*Cos(q2))*Sin(2*q1)*Sin(q2)));
/* ********************************************************************* */        
        q1dot = q1dotnew;
        q2dot = q2dotnew;
        mxGetPr(plhs[0])[0] = q2;
        mxGetPr(plhs[0])[1] = q1;
        mxGetPr(plhs[0])[2] = q1dot;
        mxGetPr(plhs[0])[3] = q2dot;
        
    } else if (flag == 's') {
        
/* mexPrintf("Computing state derivatives."); */
/* ************************************************* */
        q1dotdot = (2*((-1 + 2*L)*M*Power(q2dot,2)*(-1 + 2*L - 2*R*Cos(q2))*((-L + R)*Sin(q1 - q2) + R*Sin(q2)) + Power(q1dot,2)*((1 - 2*L)*R*(M + L*M + 2*L*Mp - 3*M*R - 2*Mp*R + 2*M*R*Cos(q2) + M*(-L + R)*Cos(2*q2))*Sin(q1) + (L - R)*(-(R*(M + 2*L*M + 2*L*Mp - 2*(2*M + Mp)*R)*Cos(q2)*Sin(2*q1)) + (-1 + 2*L)*M*(L - R)*Cos(2*q2)*Sin(2*q1) + 2*R*Cos(q1)*(2*(2*M + Mp)*R + (M + 2*L*M + 2*L*Mp - 2*(2*M + Mp)*R)*Cos(q1))*Sin(q2) - (-1 + 2*L)*M*(R*Cos(q1) + (L - R)*Cos(2*q1))*Sin(2*q2))) + g*(-2*R*(2*Mp*(-L + R) + M*(-1 - 2*L + 4*R))*Cos(q2)*Cos(slope)*Sin(q1) + 2*R*(-2*(2*M + Mp)*R - (M + 2*L*M + 2*L*Mp - 2*(2*M + Mp)*R)*Cos(q1))*Cos(slope)*Sin(q2) + (-1 + 2*L)*M*(R*Cos(slope) + (L - R)*Cos(q1 + slope))*Sin(2*q2) + (-1 + 2*L)*((-(M*(1 + L - 3*R)) - 2*Mp*(L - R))*Sin(q1 - slope) + (3*M + 2*Mp)*R*Sin(slope)) - (-1 + 2*L)*M*Cos(2*q2)*(R*Sin(slope) + (L - R)*Sin(q1 + slope)))))/((-1 + 2*L)*(-4*Mp*Power(L - R,2) + M*(-1 - 2*Power(L,2) + 4*(1 + L)*R - 6*Power(R,2)) + 2*R*(-(M*(1 + L - 3*R)) + 2*Mp*(-L + R))*Cos(q1)) - 2*R*(-2*Mp*Power(L - R,2) + M*(-1 + L - 2*Power(L,2) + 2*L*R + (3 - 4*R)*R) + 2*(-1 + 2*L)*M*R*Cos(q1) + (L - R)*(M + 2*L*M + 2*L*Mp - 2*(2*M + Mp)*R)*Cos(2*q1))*Cos(q2) + 2*(-1 + 2*L)*M*(L - R)*(R*Cos(q1) + (L - R)*Cos(2*q1))*Cos(2*q2) - 4*(L - R)*R*(2*(2*M + Mp)*R + (M + 2*L*M + 2*L*Mp - 2*(2*M + Mp)*R)*Cos(q1))*Sin(q1)*Sin(q2) + 2*(-1 + 2*L)*M*(L - R)*(R + 2*(L - R)*Cos(q1))*Sin(q1)*Sin(2*q2));
        q2dotdot = (2*((L - R)*(2*(-1 + 2*L)*M*Power(q2dot,2)*Cos(q1 - q2)*((-L + R)*Sin(q1 - q2) + R*Sin(q2)) + Power(q1dot,2)*((4*Mp*Power(L - R,2) + M*(1 + 4*Power(L,2) - 4*R - 8*L*R + 8*Power(R,2)))*Cos(q2)*Sin(q1) - (2*R*(M + 2*L*M + 2*L*Mp - 2*(2*M + Mp)*R) + (4*Mp*Power(L - R,2) + M*(1 + 4*Power(L,2) - 4*R - 8*L*R + 8*Power(R,2)))*Cos(q1))*Sin(q2))) + g*((-L + R)*(M + 2*L*M + 2*L*Mp - 2*(2*M + Mp)*R)*Cos(q2 + slope)*Sin(2*q1) + (2*Mp*Power(L - R,2) + M*(1 + L*(-1 + 2*L) - 3*R - 2*L*R + 4*Power(R,2)))*Sin(q2 - slope) + 4*(2*M + Mp)*(L - R)*R*Sin(q1)*Sin(q2)*Sin(slope) + 2*R*Cos(q1)*((M + 2*L*M + 2*L*Mp - 2*(2*M + Mp)*R)*Cos(slope)*Sin(q2) + (-1 + 2*L)*M*Cos(q2)*Sin(slope)) + (L - R)*(M + 2*L*M + 2*L*Mp - 2*(2*M + Mp)*R)*Cos(2*q1)*Sin(q2 + slope))))/((-1 + 2*L)*(-4*Mp*Power(L - R,2) + M*(-1 - 2*Power(L,2) + 4*(1 + L)*R - 6*Power(R,2)) + 2*R*(-(M*(1 + L - 3*R)) + 2*Mp*(-L + R))*Cos(q1)) - 2*R*(-2*Mp*Power(L - R,2) + M*(-1 + L - 2*Power(L,2) + 2*L*R + (3 - 4*R)*R) + 2*(-1 + 2*L)*M*R*Cos(q1) + (L - R)*(M + 2*L*M + 2*L*Mp - 2*(2*M + Mp)*R)*Cos(2*q1))*Cos(q2) + 2*(-1 + 2*L)*M*(L - R)*(R*Cos(q1) + (L - R)*Cos(2*q1))*Cos(2*q2) - 4*(L - R)*R*(2*(2*M + Mp)*R + (M + 2*L*M + 2*L*Mp - 2*(2*M + Mp)*R)*Cos(q1))*Sin(q1)*Sin(q2) + 2*(-1 + 2*L)*M*(L - R)*(R + 2*(L - R)*Cos(q1))*Sin(q1)*Sin(2*q2));
/* ************************************************* */
        mxGetPr(plhs[0])[0] = q1dot;
        mxGetPr(plhs[0])[1] = q2dot;
        mxGetPr(plhs[0])[2] = q1dotdot;
        mxGetPr(plhs[0])[3] = q2dotdot;
        
    } else if (flag == 'g') {
        
/* mexPrintf("Computing guard condition."); */
/* ************************************************* */
        guard = R + L*Cos(q1) - L*Cos(q2) - R*Cos(2*q1 + q2);
/* ************************************************* */
        mxGetPr(plhs[0])[0] = guard;
        mxGetPr(plhs[0])[1] = guard;
        mxGetPr(plhs[0])[2] = guard;
        mxGetPr(plhs[0])[3] = guard;
        
    }
    /*
    mexPrintf("q1 is %g\n", q1);
    mexPrintf("q2 is %g\n", q2); 
    mexPrintf("q1dot is %g\n", q1dot); 
    mexPrintf("q2dot is %g\n", q2dot);
    mexPrintf("M is %g\n", M); 
    mexPrintf("Mp is %g\n", Mp); 
    mexPrintf("g is %g\n", g); 
    mexPrintf("L is %g\n", L);  
    mexPrintf("slope is %g\n", slope);
    mexPrintf("flag is %c\n", flag);
    mexPrintf("q1dot is %f\n", q1dot);
    mexPrintf("q2dot is %f\n", q2dot);
    mexPrintf("q1dotdot is %f\n", q1dotdot);
    mexPrintf("q1dotdot is %f\n", q2dotdot);
    */
}
