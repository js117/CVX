
#include "math.h"
#include "..\mdefs.h"
#include "mex.h"
#include "string.h"

/* This code differentiates the state vector for a 2D passive bipedal 
 * walker. It accepts several different kinds of inputs, thanks to Matlab's
 * inane function handling methodology.
 */

void mexFunction( int nlhs, mxArray *plhs[], 
                    int nrhs, const mxArray *prhs[] ) {

/* ****************************** */
/* Declare pointers and variables */
/* ****************************** */
    const int dim = 6;
    double M, Mp, g, l, slope, w; /* The constants ... */
    mxArray *M_ptr, *Mp_ptr, *g_ptr, *l_ptr, *slope_ptr, *w_ptr; /* ... and their counterparts. */
    char flag;
    long double x5, x6, x7; /* Angles */
    long double x5dot, x6dot, x7dot, x5dotnew, x6dotnew, x7dotnew; /* Angle velocities */
    long double x5dotdot, x6dotdot, x7dotdot; /* Angle accels */
    plhs[0] = mxCreateDoubleMatrix(dim, 1, mxREAL);
    
/* ************ */
/* Parse inputs */
/* ************ */    
    /* Matlab arrays are indexed in a wonderfully undocumented fashion.
     * Imagine that you want to get element (2,3) of a 10-row matrix.
     * Then row = 2, col = 3 and the index you want is row+col*mxGetM(mtrx)
     * Or, 2 + 3*10 = 32. You access this element like so:
     *         mxGetPr(prhs[0])[32]
     * "Fantastic!" you say. Ah, but you forget: C indexing starts from 0.
     *         mxGetPr(prhs[0])[1+2*10]
     * is how you really do it. */    
    if (mxGetM(prhs[0]) == dim || mxGetN(prhs[0]) == dim) {
        x5 = mxGetPr(prhs[0])[0];
        x6 = mxGetPr(prhs[0])[1];
        x7 = mxGetPr(prhs[0])[2];
        x5dot = mxGetPr(prhs[0])[3];
        x6dot = mxGetPr(prhs[0])[4];
        x7dot = mxGetPr(prhs[0])[5];
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
        x5 = mxGetPr(prhs[1])[0]; 
        x6 = mxGetPr(prhs[1])[1]; 
        x7 = mxGetPr(prhs[1])[2];
        x5dot = mxGetPr(prhs[1])[3]; 
        x6dot = mxGetPr(prhs[1])[4];
        x7dot = mxGetPr(prhs[1])[5];
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
    l_ptr = mexGetVariable("global", "l"); 
    slope_ptr = mexGetVariable("global", "slope");
    w_ptr = mexGetVariable("global", "w");

    if (M_ptr == NULL || Mp_ptr == NULL || g_ptr == NULL || l_ptr == NULL || slope_ptr == NULL || w_ptr == NULL) {
        mexErrMsgTxt("eqns3: The global workspace must contain the variables M, Mp, g, l, slope, and w.");
    } else {
        M = mxGetScalar(M_ptr);
        Mp = mxGetScalar(Mp_ptr);
        g = mxGetScalar(g_ptr);
        l = mxGetScalar(l_ptr);
        slope = mxGetScalar(slope_ptr);
        w = mxGetScalar(w_ptr);
    }
    
    /* Make sure that we know what it is we're supposed to be doing. */
    if (!strcmp(&flag, "s") && !strcmp(&flag, "i")) {
        flag = 's';
        mexPrintf("\neqns2: Bad inputs! Calculating equations of state by default. \n");
    }
           
/* ******************* */
/* Solve for new state */
/* ******************* */
    /* mexPrintf("Computing state after impact."); */
    if (flag == 'i') {
/* ********************************************************************* */
        x5dotnew = (-(x5dot*(Cos(2*x6)*((Power(l,2)*M*(M + 4*Mp) + 4*Power(M + Mp,2)*Power(w,2))*Cos(2*x7) - M*(-2*Power(l,2)*(M + 2*Mp) + 4*(M + Mp)*Power(w,2) + Power(l,2)*M*Cos(4*x7))) + 2*(Power(l,2)*M*(3*M + 4*Mp) - (2*Power(M,2) + M*Mp - 2*Power(Mp,2))*Power(w,2) + 2*Power(M,2)*(-Power(l,2) + Power(w,2))*Cos(2*x7) + 4*Power(l,2)*(M + Mp)*Power(Cos(x6),2)*Cos(x7)*(-3*M - 4*Mp + 2*M*Cos(2*x7)) + (-2*(Power(l,2)*M*(M + 2*Mp) + 2*Power(M + Mp,2)*Power(w,2))*Cos(x7) + Power(l,2)*(-2*(M + Mp)*(-3*M - 4*Mp + 2*M*Cos(2*x7)) + Power(M,2)*Cos(3*x7)))*Sin(2*x6)*Sin(x7)))) - 4*l*w*(x6dot*(2*Mp*(5*M + 4*Mp + (6*M + 4*Mp)*Cos(x7))*Sin(x6)*Power(Sin(x7/2.),2) - (2*M + Mp)*Cos(x6)*(-M + 2*(M + 2*Mp)*Cos(x7))*Sin(x7)) + M*x7dot*(2*M*Cos(x6)*Sin(x7) + Mp*Sin(x6 + x7))))/(Cos(2*x6)*((Power(l,2)*(13*Power(M,2) + 32*M*Mp + 16*Power(Mp,2)) + 4*Mp*(2*M + Mp)*Power(w,2))*Cos(2*x7) + M*(-2*Power(l,2)*M + 4*(M + 2*Mp)*Power(w,2) - Power(l,2)*(5*M + 4*Mp)*Cos(4*x7))) + 2*(Power(l,2)*(3*M + 2*Mp)*(3*M + 4*Mp) + (2*Power(M,2) + 7*M*Mp + 2*Power(Mp,2))*Power(w,2) + 2*M*(-(Power(l,2)*(3*M + 2*Mp)) + Mp*Power(w,2))*Cos(2*x7) + 4*Power(l,2)*M*Power(Cos(x6),2)*(-2*(M + 2*Mp)*Cos(x7) + M*Cos(3*x7)) + (-2*(Power(l,2)*(M + 2*Mp)*(5*M + 4*Mp) + 2*Mp*(2*M + Mp)*Power(w,2))*Cos(x7) + Power(l,2)*M*(6*M + 8*Mp - 4*M*Cos(2*x7) + (5*M + 4*Mp)*Cos(3*x7)))*Sin(2*x6)*Sin(x7)));
        x6dotnew = (-(l*(M*x7dot*(-4*Power(l,2)*M - 4*Power(l,2)*M*Cos(2*x6) + Power(l,2)*M*Cos(2*x6 - x7) + 12*Power(l,2)*M*Cos(x7) + 8*Power(l,2)*Mp*Cos(x7) + 8*M*Power(w,2)*Cos(x7) - 4*Power(l,2)*M*Cos(2*x7) - 4*Power(l,2)*M*Cos(2*(x6 + x7)) + 2*(Power(l,2)*(3*M + 2*Mp) + 2*(2*M + Mp)*Power(w,2))*Cos(2*x6 + x7) + Power(l,2)*(5*M + 4*Mp)*Cos(2*x6 + 3*x7)) + x6dot*(2*Power(l,2)*M*(M + 2*Mp) - 2*(2*Power(M,2) + 7*M*Mp + 4*Power(Mp,2))*Power(w,2) + 8*M*(2*Power(l,2)*(M + Mp) + M*Power(w,2))*Cos(x7) - 4*(Power(l,2)*(7*Power(M,2) + 10*M*Mp + 4*Power(Mp,2)) + (2*M - Mp)*(M + Mp)*Power(w,2))*Cos(2*x7) + 8*Power(l,2)*M*(M + Mp)*Cos(3*x7) + Cos(2*x6)*(-(Power(l,2)*(13*Power(M,2) + 18*M*Mp + 8*Power(Mp,2))) - 4*(M - Mp)*(M + Mp)*Power(w,2) + M*(Power(l,2)*(11*M + 12*Mp) + 4*(2*M + Mp)*Power(w,2))*Cos(x7) - (3*Power(l,2)*Power(M,2) + 4*(2*M + Mp)*(M + 2*Mp)*Power(w,2))*Cos(2*x7) + Power(l,2)*(M*(13*M + 12*Mp)*Cos(3*x7) - 2*(M + Mp)*(5*M + 4*Mp)*Cos(4*x7))) + 2*(-(Power(l,2)*M*(3*M + 4*Mp)) - 2*M*(2*M + Mp)*Power(w,2) + (Power(l,2)*(9*Power(M,2) + 14*M*Mp + 8*Power(Mp,2)) + 4*(2*M + Mp)*(M + 2*Mp)*Power(w,2))*Cos(x7) + Power(l,2)*(-(M*(13*M + 12*Mp)*Cos(2*x7)) + 2*(M + Mp)*(5*M + 4*Mp)*Cos(3*x7)))*Sin(2*x6)*Sin(x7)))) - w*x5dot*((-(Power(l,2)*(17*Power(M,2) + 20*M*Mp + 4*Power(Mp,2))) - 8*Mp*(M + Mp)*Power(w,2) - 2*(2*Power(l,2)*(Power(M,2) + 4*M*Mp + 2*Power(Mp,2)) + 2*M*(4*M + 3*Mp)*Power(w,2) + (Power(l,2)*(7*Power(M,2) + 12*M*Mp + 4*Power(Mp,2)) + 4*(M + Mp)*(2*M + Mp)*Power(w,2))*Cos(2*x6))*Cos(2*x7) + 16*Power(l,2)*(M + Mp)*Power(Cos(x6),2)*((4*M + 3*Mp)*Cos(x7) - (M + Mp)*Cos(3*x7)))*Sin(x6) - Power(l,2)*(4*M*(M + Mp) + (M + 2*Mp)*(3*M + 2*Mp)*Cos(4*x7))*Sin(3*x6) + 8*Power(l,2)*(M + Mp)*Cos(x6)*(-5*M - 4*Mp + (4*M + 3*Mp)*Cos(2*x6))*Sin(x7) - 2*Cos(x6)*(-2*(3*M + 2*Mp)*(Power(l,2)*M + Mp*Power(w,2)) + (Power(l,2)*(7*Power(M,2) + 12*M*Mp + 4*Power(Mp,2)) + 4*(M + Mp)*(2*M + Mp)*Power(w,2))*Cos(2*x6))*Sin(2*x7) - 4*Power(l,2)*Power(M + Mp,2)*(Cos(x6) + Cos(3*x6))*Sin(3*x7) - Power(l,2)*(M + 2*Mp)*(3*M + 2*Mp)*Cos(3*x6)*Sin(4*x7)))/(l*(Cos(2*x6)*((Power(l,2)*(13*Power(M,2) + 32*M*Mp + 16*Power(Mp,2)) + 4*Mp*(2*M + Mp)*Power(w,2))*Cos(2*x7) + M*(-2*Power(l,2)*M + 4*(M + 2*Mp)*Power(w,2) - Power(l,2)*(5*M + 4*Mp)*Cos(4*x7))) + 2*(Power(l,2)*(3*M + 2*Mp)*(3*M + 4*Mp) + (2*Power(M,2) + 7*M*Mp + 2*Power(Mp,2))*Power(w,2) + 2*M*(-(Power(l,2)*(3*M + 2*Mp)) + Mp*Power(w,2))*Cos(2*x7) + 4*Power(l,2)*M*Power(Cos(x6),2)*(-2*(M + 2*Mp)*Cos(x7) + M*Cos(3*x7)) + (-2*(Power(l,2)*(M + 2*Mp)*(5*M + 4*Mp) + 2*Mp*(2*M + Mp)*Power(w,2))*Cos(x7) + Power(l,2)*M*(6*M + 8*Mp - 4*M*Cos(2*x7) + (5*M + 4*Mp)*Cos(3*x7)))*Sin(2*x6)*Sin(x7))));
        x7dotnew = (-(l*(M*x7dot*(2*Power(l,2)*(5*M + 2*Mp) + 2*(2*M + Mp)*Power(w,2) + M*(5*Power(l,2) + 4*Power(w,2))*Cos(2*x6) - Power(l,2)*M*Cos(2*x6 - x7) - 16*Power(l,2)*M*Cos(x7) - 8*Power(l,2)*Mp*Cos(x7) - 8*M*Power(w,2)*Cos(x7) + 4*Power(l,2)*M*Cos(2*x7) + 9*Power(l,2)*M*Cos(2*(x6 + x7)) + 4*Power(l,2)*Mp*Cos(2*(x6 + x7)) - 10*Power(l,2)*M*Cos(2*x6 + x7) - 4*Power(l,2)*Mp*Cos(2*x6 + x7) - 8*M*Power(w,2)*Cos(2*x6 + x7) - 4*Mp*Power(w,2)*Cos(2*x6 + x7) - Power(l,2)*(5*M + 4*Mp)*Cos(2*x6 + 3*x7)) + 4*x6dot*(2*((-M - Mp)*(2*Power(l,2)*(M + 2*Mp) - 3*Mp*Power(w,2) + (8*Power(l,2)*(M + Mp) + 2*(2*M - Mp)*Power(w,2))*Cos(x7) - 4*Power(l,2)*M*Cos(2*x7)) - Cos(2*x6)*(-3*Power(l,2)*M*(M + Mp) + Mp*(5*M + 3*Mp)*Power(w,2) + (Power(l,2)*(M + Mp)*(3*M + 4*Mp) + 2*(2*M + Mp)*(M + 2*Mp)*Power(w,2))*Cos(x7) + Power(l,2)*(M + Mp)*((M + 4*Mp)*Cos(2*x7) + (5*M + 4*Mp)*Cos(3*x7))))*Power(Sin(x7/2.),2) + ((-(Power(l,2)*(M + Mp)*(9*M + 4*Mp)) - 2*(2*M + Mp)*(M + 2*Mp)*Power(w,2))*Cos(x7) + (M + Mp)*(Power(l,2)*(5*M + 4*Mp) + (2*M + Mp)*Power(w,2) + Power(l,2)*((9*M + 4*Mp)*Cos(2*x7) - (5*M + 4*Mp)*Cos(3*x7))))*Sin(2*x6)*Sin(x7)))) - w*x5dot*((Power(l,2)*(21*Power(M,2) + 24*M*Mp + 4*Power(Mp,2)) + 8*Mp*(M + Mp)*Power(w,2))*Sin(x6) + 8*Power(l,2)*M*(M + Mp)*Sin(3*x6) + 5*Power(l,2)*Power(M,2)*Sin(x6 - 2*x7) + 4*Power(l,2)*M*Mp*Sin(x6 - 2*x7) - 24*Power(l,2)*Power(M,2)*Sin(x6 - x7) - 36*Power(l,2)*M*Mp*Sin(x6 - x7) - 16*Power(l,2)*Power(Mp,2)*Sin(x6 - x7) + 4*Power(M,2)*Power(w,2)*Sin(x6 - x7) - Power(l,2)*Power(M,2)*Sin(3*x6 - x7) + Power(l,2)*Power(M,2)*Sin(x6 + x7) - 8*Power(M,2)*Power(w,2)*Sin(x6 + x7) - 8*M*Mp*Power(w,2)*Sin(x6 + x7) - 17*Power(l,2)*Power(M,2)*Sin(3*x6 + x7) - 28*Power(l,2)*M*Mp*Sin(3*x6 + x7) - 12*Power(l,2)*Power(Mp,2)*Sin(3*x6 + x7) - 4*Power(M,2)*Power(w,2)*Sin(3*x6 + x7) - 4*M*Mp*Power(w,2)*Sin(3*x6 + x7) - 8*Power(l,2)*Power(M,2)*Sin(x6 + 2*x7) - 4*Power(l,2)*M*Mp*Sin(x6 + 2*x7) + 8*Power(M,2)*Power(w,2)*Sin(x6 + 2*x7) - 4*Power(Mp,2)*Power(w,2)*Sin(x6 + 2*x7) + 7*Power(l,2)*Power(M,2)*Sin(3*x6 + 2*x7) + 8*Power(l,2)*M*Mp*Sin(3*x6 + 2*x7) + 8*Power(M,2)*Power(w,2)*Sin(3*x6 + 2*x7) + 12*M*Mp*Power(w,2)*Sin(3*x6 + 2*x7) + 4*Power(Mp,2)*Power(w,2)*Sin(3*x6 + 2*x7) + 5*Power(l,2)*Power(M,2)*Sin(x6 + 3*x7) + 8*Power(l,2)*M*Mp*Sin(x6 + 3*x7) + 4*Power(l,2)*Power(Mp,2)*Sin(x6 + 3*x7) + Power(l,2)*(M + 2*Mp)*(3*M + 2*Mp)*Sin(3*x6 + 4*x7)))/(l*(Cos(2*x6)*((Power(l,2)*(13*Power(M,2) + 32*M*Mp + 16*Power(Mp,2)) + 4*Mp*(2*M + Mp)*Power(w,2))*Cos(2*x7) + M*(-2*Power(l,2)*M + 4*(M + 2*Mp)*Power(w,2) - Power(l,2)*(5*M + 4*Mp)*Cos(4*x7))) + 2*(Power(l,2)*(3*M + 2*Mp)*(3*M + 4*Mp) + (2*Power(M,2) + 7*M*Mp + 2*Power(Mp,2))*Power(w,2) + 2*M*(-(Power(l,2)*(3*M + 2*Mp)) + Mp*Power(w,2))*Cos(2*x7) + 4*Power(l,2)*M*Power(Cos(x6),2)*(-2*(M + 2*Mp)*Cos(x7) + M*Cos(3*x7)) + (-2*(Power(l,2)*(M + 2*Mp)*(5*M + 4*Mp) + 2*Mp*(2*M + Mp)*Power(w,2))*Cos(x7) + Power(l,2)*M*(6*M + 8*Mp - 4*M*Cos(2*x7) + (5*M + 4*Mp)*Cos(3*x7)))*Sin(2*x6)*Sin(x7))));
/* ********************************************************************* */        
        x5dot = x5dotnew;
        x6dot = x6dotnew;
        x7dot = x7dotnew;
        mxGetPr(plhs[0])[0] = x7;
        mxGetPr(plhs[0])[1] = x6;
        mxGetPr(plhs[0])[2] = x5;
        mxGetPr(plhs[0])[3] = x5dot;
        mxGetPr(plhs[0])[4] = x6dot;
        mxGetPr(plhs[0])[5] = x7dot;
    
    /* mexPrintf("Computing state derivatives."); */
    } else if (flag == 's') {
/* ************************************************* */
        x5dotdot = (-4*g*w*Cos(x5)*((Power(M,2) + 4*M*Mp + 2*Power(Mp,2))*Cos(2*x6) + M*(M + Mp)*Cos(2*x7) + Mp*(3*M + 2*Mp + M*Cos(2*(x6 + x7)))) + 4*g*l*(-3*M - 4*Mp + 2*M*Cos(2*x7))*((3*M + 2*Mp)*Cos(x6) - M*Cos(x6 + x7))*Sin(x5) + l*(4*w*((Power(M,2) + 7*M*Mp + 4*Power(Mp,2))*Power(x6dot,2)*Cos(x6) - M*(M + 4*Mp)*Power(x6dot + x7dot,2)*Cos(x6)*Cos(x7) + M*(M + 2*Mp)*Power(x6dot,2)*Cos(x6)*Cos(2*x7) + M*(M + 2*Mp)*Power(x6dot + x7dot,2)*Sin(x6)*Sin(x7) - M*(M + 2*Mp)*Power(x6dot,2)*Sin(x6)*Sin(2*x7)) + w*Power(x5dot,2)*((Power(M,2) + 7*M*Mp + 4*Power(Mp,2))*Cos(3*x6) + Cos(x6)*(-21*Power(M,2) - 23*M*Mp - 4*Power(Mp,2) + M*(5*M + 6*Mp - 2*Mp*Cos(2*x6))*Cos(x7) + 2*M*(9*M + 6*Mp + (M + 2*Mp)*Cos(2*x6))*Cos(2*x7) - M*(3*M - 2*Mp + 2*(M + 3*Mp)*Cos(2*x6))*Cos(3*x7)) - 4*M*(M + 2*Mp)*Power(Cos(x6),2)*Sin(x6)*Sin(2*x7) + M*Sin(x6)*((-13*M - 8*Mp + 2*Mp*Cos(2*x6))*Sin(x7) + (5*M + 4*Mp + 2*(M + 3*Mp)*Cos(2*x6))*Sin(3*x7))) + 2*l*x5dot*(-3*M - 4*Mp + 2*M*Cos(2*x7))*(x6dot*((5*M + 4*Mp)*Sin(2*x6) + M*(Sin(2*(x6 + x7)) - 4*Sin(2*x6 + x7))) + M*x7dot*(-2*Sin(x7) + Sin(2*(x6 + x7)) - 2*Sin(2*x6 + x7)))))/(-2*Power(l,2)*(3*M + 2*Mp)*(3*M + 4*Mp) - 2*(2*Power(M,2) + 7*M*Mp + 2*Power(Mp,2))*Power(w,2) + Cos(2*x6)*(-2*Power(l,2)*(7*Power(M,2) + 16*M*Mp + 8*Power(Mp,2)) - 4*Mp*(2*M + Mp)*Power(w,2) + M*(Power(l,2)*(7*M + 4*Mp) - 4*(M + 2*Mp)*Power(w,2))*Cos(2*x7) + Power(l,2)*Power(M,2)*Cos(4*x7)) + M*(4*(Power(l,2)*(3*M + 2*Mp) - Mp*Power(w,2))*Cos(2*x7) + 8*Power(l,2)*Power(Cos(x6),2)*(2*(M + 2*Mp)*Cos(x7) - M*Cos(3*x7)) + 2*(2*(M + 2*Mp)*(Power(l,2) + 2*Power(w,2))*Cos(x7) - Power(l,2)*(6*M + 8*Mp - 4*M*Cos(2*x7) + M*Cos(3*x7)))*Sin(2*x6)*Sin(x7)));
        x6dotdot = (-4*g*(-(Cos(x5)*((Power(l,2)*(3*M + 2*Mp)*(5*M + 4*Mp) + 8*M*(M + Mp)*Power(w,2) - 2*M*(Power(l,2)*(6*M + 4*Mp) - 2*Mp*Power(w,2) + (Power(l,2)*(3*M + 2*Mp) - 4*(M + Mp)*Power(w,2))*Cos(2*x6))*Cos(2*x7) + 16*Power(l,2)*M*Power(Cos(x6),2)*(-2*(M + Mp)*Cos(x7) + M*Cos(3*x7)))*Sin(x6) - Power(l,2)*(-2*(M + Mp)*(5*M + 4*Mp) + Power(M,2)*Cos(4*x7))*Sin(3*x6) + M*(4*Cos(x6)*(-2*(Power(l,2)*(4*M + 3*Mp) + (2*M + Mp)*Power(w,2))*Cos(x7) + Cos(2*x6)*(-4*Power(l,2)*(M + Mp) + (-(Power(l,2)*(3*M + 2*Mp)) + 4*(M + Mp)*Power(w,2))*Cos(x7)) + Power(l,2)*(7*M + 4*Mp + 2*M*Cos(2*x7)))*Sin(x7) - Power(l,2)*M*Cos(3*x6)*(-4*Sin(3*x7) + Sin(4*x7))))) + 4*l*w*Sin(x5)*((M + Mp)*(3*M + 2*Mp)*Sin(2*x6) + M*((2*M + Mp)*Sin(x7) - (3*M + 2*Mp)*Sin(2*x7) - 3*M*Sin(2*(x6 + x7)) - 2*Mp*Sin(2*(x6 + x7)) - M*Sin(2*x6 + x7) - Mp*Sin(2*x6 + x7) + M*Sin(2*x6 + 3*x7)))) - l*(Power(x5dot,2)*(2*(Power(l,2)*(25*Power(M,2) + 36*M*Mp + 16*Power(Mp,2)) + 2*(10*Power(M,2) + 15*M*Mp + 4*Power(Mp,2))*Power(w,2) + M*((-(Power(l,2)*(19*M + 20*Mp)) - 4*(2*M + Mp)*Power(w,2) - Power(l,2)*(17*M + 20*Mp)*Cos(2*x6))*Cos(x7) - (8*Power(l,2)*(2*M + Mp) + 4*(4*M + Mp)*Power(w,2) + (Power(l,2)*(3*M + 4*Mp) - 4*(M + 2*Mp)*Power(w,2))*Cos(2*x6))*Cos(2*x7) + (Power(l,2)*(15*M + 4*Mp) + 8*M*Power(w,2) + 4*(Power(l,2)*(3*M + Mp) + Mp*Power(w,2))*Cos(2*x6))*Cos(3*x7) - 3*Power(l,2)*M*Cos(4*x7)))*Sin(2*x6) + Power(l,2)*((3*M + 4*Mp)*(5*M + 4*Mp) + Power(M,2)*(-6*Cos(4*x7) + Cos(5*x7)))*Sin(4*x6) + 2*M*(Power(l,2)*(31*M + 16*Mp) + 2*(8*M + 3*Mp)*Power(w,2) - 16*(5*M + 3*Mp)*(Power(l,2) + Power(w,2))*Power(Cos(x6),2)*Cos(x7) + Power(l,2)*(13*M + 4*Mp)*Cos(2*x7) + 2*Cos(2*x6)*(Power(l,2)*(13*M + 4*Mp) - 2*Mp*Power(w,2) + (Power(l,2)*(15*M + 4*Mp) + 8*M*Power(w,2))*Cos(2*x7) - 2*Power(Cos(x6),2)*Cos(x7)*(Power(l,2)*(3*M + 4*Mp) - 4*(M + 2*Mp)*Power(w,2) + 12*Power(l,2)*M*Cos(2*x7))) + 12*Power(l,2)*M*Power(Cos(x6),2)*Cos(3*x7) + Cos(4*x6)*(-2*Power(l,2)*(M + 4*Mp) + 2*Mp*Power(w,2) + (Power(l,2)*(13*M + 4*Mp) + 4*Mp*Power(w,2))*Cos(2*x7) + Power(l,2)*M*Cos(4*x7)))*Sin(x7)) + 16*l*w*x5dot*(x6dot*((5*M + 4*Mp)*Sin(2*x6) + M*(Sin(2*(x6 + x7)) - 4*Sin(2*x6 + x7))) + M*x7dot*(-2*Sin(x7) + Sin(2*(x6 + x7)) - 2*Sin(2*x6 + x7)))*((M + Mp)*Sin(x6) - M*Sin(x6 + 2*x7)) + 4*(Power(x6dot,2)*((5*Power(l,2)*Power(M,2) - 4*Mp*(2*M + Mp)*Power(w,2) - M*(5*Power(l,2)*M - 4*Mp*Power(w,2))*Cos(x7) - Power(l,2)*Power(M,2)*(4*Cos(2*x7) - 5*Cos(3*x7) + Cos(4*x7)))*Sin(2*x6) + 2*M*(4*(-2*Power(l,2)*(2*M + Mp) + Mp*Power(w,2))*Cos(x7) + 2*Power(l,2)*(5*M + 2*Mp + 2*M*Cos(2*x7)) + Cos(2*x6)*(Power(l,2)*(9*M + 4*Mp) + 2*Mp*Power(w,2) - Power(l,2)*((15*M + 8*Mp)*Cos(x7) + M*(-5*Cos(2*x7) + Cos(3*x7)))))*Sin(x7)) + 2*M*x6dot*x7dot*(4*Power(l,2)*M*Sin(2*x6) - Power(l,2)*(5*M + 4*Mp)*Sin(2*x6 - x7) + 4*(Power(l,2)*(M + Mp) + Mp*Power(w,2))*Sin(2*x6 + x7) + 4*Power(l,2)*((3*M + 2*Mp)*Sin(x7) - 2*M*Cos(x6)*Sin(x6 + 2*x7)) + Power(l,2)*M*Sin(2*x6 + 3*x7)) + M*Power(x7dot,2)*(4*Power(l,2)*M*Sin(2*x6) - Power(l,2)*(5*M + 4*Mp)*Sin(2*x6 - x7) + 4*(Power(l,2)*(M + Mp) + Mp*Power(w,2))*Sin(2*x6 + x7) + 4*Power(l,2)*((3*M + 2*Mp)*Sin(x7) - 2*M*Cos(x6)*Sin(x6 + 2*x7)) + Power(l,2)*M*Sin(2*x6 + 3*x7)))))/(4.*l*(Cos(2*x6)*(2*Power(l,2)*(7*Power(M,2) + 16*M*Mp + 8*Power(Mp,2)) + 4*Mp*(2*M + Mp)*Power(w,2) + M*(-(Power(l,2)*(7*M + 4*Mp)) + 4*(M + 2*Mp)*Power(w,2))*Cos(2*x7) - Power(l,2)*Power(M,2)*Cos(4*x7)) + 2*(Power(l,2)*(3*M + 2*Mp)*(3*M + 4*Mp) + (2*Power(M,2) + 7*M*Mp + 2*Power(Mp,2))*Power(w,2) + 2*M*(-(Power(l,2)*(3*M + 2*Mp)) + Mp*Power(w,2))*Cos(2*x7) + 4*Power(l,2)*M*Power(Cos(x6),2)*(-2*(M + 2*Mp)*Cos(x7) + M*Cos(3*x7)) + M*(-2*(M + 2*Mp)*(Power(l,2) + 2*Power(w,2))*Cos(x7) + Power(l,2)*(6*M + 8*Mp - 4*M*Cos(2*x7) + M*Cos(3*x7)))*Sin(2*x6)*Sin(x7))));
        x7dotdot = (4*g*(4*l*w*Sin(x5)*((5*Power(M,2) + 6*M*Mp + 2*Power(Mp,2) + (2*Power(M,2) + 7*M*Mp + 4*Power(Mp,2))*Cos(x7) - M*(6*M + 5*Mp)*Cos(2*x7) + Power(M,2)*Cos(3*x7))*Sin(2*x6) + (17*Power(M,2) + 23*M*Mp + 8*Power(Mp,2) - 2*M*(5*M + 3*Mp)*Cos(x7) + Cos(2*x6)*(15*Power(M,2) + 21*M*Mp + 8*Power(Mp,2) - 2*M*(6*M + 5*Mp)*Cos(x7) + 2*Power(M,2)*Cos(2*x7)))*Sin(x7)) + Cos(x5)*((-(Power(l,2)*(3*M + 2*Mp)*(9*M + 4*Mp)) - 8*M*(M + Mp)*Power(w,2) + (Power(l,2)*M*(17*M + 14*Mp) + 4*(2*Power(M,2) + 2*M*Mp + Power(Mp,2))*Power(w,2))*Cos(x7) + M*(Power(l,2)*(17*M + 14*Mp) + 4*M*Power(w,2))*Cos(2*x7) - Power(l,2)*M*(7*M + 2*Mp)*Cos(3*x7))*Sin(x6) + (2*(Power(l,2)*M*(8*M + 7*Mp) + 2*(M + Mp)*(2*M + Mp)*Power(w,2))*Cos(x7) + M*(Power(l,2)*(11*M + 10*Mp) - 4*(M + Mp)*Power(w,2))*Cos(2*x7) - Power(l,2)*(22*Power(M,2) + 26*M*Mp + 8*Power(Mp,2) + 2*M*(3*M + Mp)*Cos(3*x7) - Power(M,2)*Cos(4*x7)))*Sin(3*x6) - Cos(x6)*(Power(l,2)*(85*Power(M,2) + 104*M*Mp + 32*Power(Mp,2)) + 4*(4*Power(M,2) + M*Mp - 2*Power(Mp,2))*Power(w,2) + 4*(M + Mp)*(Power(l,2)*(7*M + 8*Mp) - 2*(2*M + Mp)*Power(w,2))*Cos(2*x6))*Sin(x7) + 2*M*Cos(x6)*(2*Power(l,2)*(10*M + 7*Mp) + 2*(2*M + Mp)*Power(w,2) + (Power(l,2)*(11*M + 10*Mp) - 4*(M + Mp)*Power(w,2))*Cos(2*x6))*Sin(2*x7) - Power(l,2)*M*Cos(x6)*(M + 4*(3*M + Mp)*Cos(2*x6))*Sin(3*x7) + Power(l,2)*Power(M,2)*Cos(3*x6)*Sin(4*x7))) + l*(Power(x5dot,2)*(2*(2*Power(l,2)*(29*Power(M,2) + 30*M*Mp + 8*Power(Mp,2)) + 2*(2*M + Mp)*(9*M + 4*Mp)*Power(w,2) - 2*(Power(l,2)*M*(15*M + 8*Mp) - 4*Mp*(2*M + Mp)*Power(w,2) + (3*Power(l,2)*M*(5*M + 4*Mp) + 2*(2*M + Mp)*(M + 2*Mp)*Power(w,2))*Cos(2*x6))*Cos(x7) - 2*(Power(l,2)*(3*M + 2*Mp)*(9*M + 4*Mp) + (20*Power(M,2) + 17*M*Mp + 2*Power(Mp,2))*Power(w,2) + 2*(M + Mp)*(Power(l,2)*(9*M + 4*Mp) + (-M + Mp)*Power(w,2))*Cos(2*x6))*Cos(2*x7) + M*(2*Power(l,2)*(15*M + 8*Mp) + 8*M*Power(w,2) + (Power(l,2)*(29*M + 24*Mp) + 4*Mp*Power(w,2))*Cos(2*x6))*Cos(3*x7) - Power(l,2)*M*(4*M + (9*M + 4*Mp)*Cos(2*x6))*Cos(4*x7))*Sin(2*x6) + Power(l,2)*((5*M + 4*Mp)*(9*M + 4*Mp) + Power(M,2)*Cos(5*x7))*Sin(4*x6) + 2*(2*Power(l,2)*(67*Power(M,2) + 76*M*Mp + 24*Power(Mp,2)) + 20*(5*Power(M,2) + 5*M*Mp + Power(Mp,2))*Power(w,2) - 2*(Power(l,2)*(3*M + 2*Mp)*(25*M + 4*Mp) + 2*(17*Power(M,2) + 8*M*Mp + Power(Mp,2))*Power(w,2))*Cos(x7) + 2*Power(l,2)*M*(13*M + 4*Mp)*Cos(2*x7) + 4*Cos(2*x6)*(Power(l,2)*(39*Power(M,2) + 48*M*Mp + 16*Power(Mp,2)) + 4*(5*Power(M,2) + 5*M*Mp + Power(Mp,2))*Power(w,2) - (Power(l,2)*(49*Power(M,2) + 46*M*Mp + 8*Power(Mp,2)) + (20*Power(M,2) + 17*M*Mp + 2*Power(Mp,2))*Power(w,2))*Cos(x7) + M*((Power(l,2)*(15*M + 8*Mp) + 4*M*Power(w,2))*Cos(2*x7) - 2*Power(l,2)*M*Cos(3*x7))) + Cos(4*x6)*(Power(l,2)*Power(5*M + 4*Mp,2) - 4*Power(M + Mp,2)*Power(w,2) - (Power(l,2)*(5*M + 4*Mp)*(9*M + 4*Mp) + 4*(-Power(M,2) + Power(Mp,2))*Power(w,2))*Cos(x7) + M*((6*Power(l,2)*(5*M + 4*Mp) + 4*Mp*Power(w,2))*Cos(2*x7) + Power(l,2)*((-9*M - 4*Mp)*Cos(3*x7) + M*Cos(4*x7)))))*Sin(x7)) + 4*(2*M*x6dot*x7dot*(((-5*Power(l,2)*M + 4*Mp*Power(w,2))*Cos(x7) + (-4*Power(l,2)*M + 4*(M + 2*Mp)*Power(w,2))*Cos(2*x7) + Power(l,2)*M*(5 + 5*Cos(3*x7) - Cos(4*x7)))*Sin(2*x6) + 2*(4*(-2*Power(l,2)*(2*M + Mp) + Mp*Power(w,2))*Cos(x7) + 2*Power(l,2)*(5*M + 2*Mp + 2*M*Cos(2*x7)) + Cos(2*x6)*(Power(l,2)*(9*M + 4*Mp) + 2*Mp*Power(w,2) + (-(Power(l,2)*(15*M + 8*Mp)) + 4*(M + 2*Mp)*Power(w,2))*Cos(x7) - Power(l,2)*M*(-5*Cos(2*x7) + Cos(3*x7))))*Sin(x7)) + M*Power(x7dot,2)*(((-5*Power(l,2)*M + 4*Mp*Power(w,2))*Cos(x7) + (-4*Power(l,2)*M + 4*(M + 2*Mp)*Power(w,2))*Cos(2*x7) + Power(l,2)*M*(5 + 5*Cos(3*x7) - Cos(4*x7)))*Sin(2*x6) + 2*(4*(-2*Power(l,2)*(2*M + Mp) + Mp*Power(w,2))*Cos(x7) + 2*Power(l,2)*(5*M + 2*Mp + 2*M*Cos(2*x7)) + Cos(2*x6)*(Power(l,2)*(9*M + 4*Mp) + 2*Mp*Power(w,2) + (-(Power(l,2)*(15*M + 8*Mp)) + 4*(M + 2*Mp)*Power(w,2))*Cos(x7) - Power(l,2)*M*(-5*Cos(2*x7) + Cos(3*x7))))*Sin(x7)) + 2*Power(x6dot,2)*((Power(l,2)*M*(13*M + 8*Mp) - 2*Mp*(2*M + Mp)*Power(w,2) - (Power(l,2)*M*(7*M + 2*Mp) + 4*Power(M + Mp,2)*Power(w,2))*Cos(x7) - 2*M*(Power(l,2)*(6*M + 4*Mp) - (M + 2*Mp)*Power(w,2))*Cos(2*x7) - Power(l,2)*M*((-7*M - 2*Mp)*Cos(3*x7) + M*Cos(4*x7)))*Sin(2*x6) + 2*(Power(l,2)*(22*Power(M,2) + 24*M*Mp + 8*Power(Mp,2)) + 2*(M - Mp)*(M + Mp)*Power(w,2) + 4*M*((-2*Power(l,2)*(3*M + 2*Mp) + Mp*Power(w,2))*Cos(x7) + Power(l,2)*M*Cos(2*x7)) + Cos(2*x6)*(Power(l,2)*(19*Power(M,2) + 22*M*Mp + 8*Power(Mp,2)) - 2*Power(M + Mp,2)*Power(w,2) + M*(-(Power(l,2)*(23*M + 16*Mp)) + 2*(M + 2*Mp)*Power(w,2))*Cos(x7) + Power(l,2)*M*((7*M + 2*Mp)*Cos(2*x7) - M*Cos(3*x7))))*Sin(x7))) + 16*l*w*x5dot*((M + Mp + (M + 2*Mp)*Cos(x7) - M*Cos(2*x7))*Sin(x6) + Cos(x6)*(5*M + 4*Mp - 2*M*Cos(x7))*Sin(x7))*(x6dot*((5*M + 4*Mp)*Sin(2*x6) + M*(Sin(2*(x6 + x7)) - 4*Sin(2*x6 + x7))) + M*x7dot*(-2*Sin(x7) + Sin(2*(x6 + x7)) - 2*Sin(2*x6 + x7)))))/(4.*l*(Cos(2*x6)*(2*Power(l,2)*(7*Power(M,2) + 16*M*Mp + 8*Power(Mp,2)) + 4*Mp*(2*M + Mp)*Power(w,2) + M*(-(Power(l,2)*(7*M + 4*Mp)) + 4*(M + 2*Mp)*Power(w,2))*Cos(2*x7) - Power(l,2)*Power(M,2)*Cos(4*x7)) + 2*(Power(l,2)*(3*M + 2*Mp)*(3*M + 4*Mp) + (2*Power(M,2) + 7*M*Mp + 2*Power(Mp,2))*Power(w,2) + 2*M*(-(Power(l,2)*(3*M + 2*Mp)) + Mp*Power(w,2))*Cos(2*x7) + 4*Power(l,2)*M*Power(Cos(x6),2)*(-2*(M + 2*Mp)*Cos(x7) + M*Cos(3*x7)) + M*(-2*(M + 2*Mp)*(Power(l,2) + 2*Power(w,2))*Cos(x7) + Power(l,2)*(6*M + 8*Mp - 4*M*Cos(2*x7) + M*Cos(3*x7)))*Sin(2*x6)*Sin(x7))));
/* ************************************************* */
        mxGetPr(plhs[0])[0] = x5dot;
        mxGetPr(plhs[0])[1] = x6dot;
        mxGetPr(plhs[0])[2] = x7dot;
        mxGetPr(plhs[0])[3] = x5dotdot;
        mxGetPr(plhs[0])[4] = x6dotdot;
        mxGetPr(plhs[0])[5] = x7dotdot;
    }
}
