
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
<* Assign[{x5dotnew, x6dotnew, x7dotnew}, {x5dotimpact, x6dotimpact, x7dotimpact}, CForm, AssignToArray -> {}, AssignEnd->";", AssignIndex->0, AssignIndent->"        ", AssignBreak->False] *>
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
<* Assign[{x5dotdot, x6dotdot, x7dotdot}, {x5dotdot, x6dotdot, x7dotdot}, CForm, AssignToArray -> {}, AssignEnd->";", AssignIndex->0, AssignIndent->"        ", AssignBreak->False] *>
/* ************************************************* */
        mxGetPr(plhs[0])[0] = x5dot;
        mxGetPr(plhs[0])[1] = x6dot;
        mxGetPr(plhs[0])[2] = x7dot;
        mxGetPr(plhs[0])[3] = x5dotdot;
        mxGetPr(plhs[0])[4] = x6dotdot;
        mxGetPr(plhs[0])[5] = x7dotdot;
    }
}
