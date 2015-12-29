
#include "math.h"
#include "mdefs.h"
#include "mex.h"

/* The following calls to this function are allowed:
 *
 * nrhs == 1:
 *      eqns3(q)
 * nrhs == 2:
 *      eqns3(t, q)
 *      eqns3(q, flag)
 * nrhs == 3:
 *      eqns3(t, q, flag)
 *
 * q = state vector, t = time, flag = 's', 'g', or 'i'.
 * Notice that the flag is always the last element, and follows the q 
 * vector no matter which argument the q vector is.
 *
 */

void dieHorribly( int option ) {
    switch (option) {
        case 0:
            mexErrMsgTxt("eqns? error:\nThe following calls are allowed:\nnrhs == 1:\n   eqns?(q)\nnrhs == 2:\n   eqns?(t, q)\n   eqns?(q, flag)\nnrhs == 3:\n   eqns?(t, q, flag)\n\nt = time (but only if called by ode45), q = state vector, flag = 's' or 'i' or 'g'.\n");
            break;
        case 1:
            mexErrMsgTxt("eqns? error:\nMake sure that the input state vector has the right dimensions, is either a column or row vector, and is the first or second argument.");
            break;
        case 2:
            mexErrMsgTxt("eqns? error:\nWrong # of arguments enter 1, 2 or 3 inputs.\n");
            break;
        case 3:
            mexErrMsgTxt("eqns? error:\nThe flag must be 's' to compute dynamics, 'i' to compute impact, or 'g' to compute the guard function.\n");
            break;
        case 4:
            mexErrMsgTxt("eqns? error:\nDefine your global variables first: try running pop.\n");
            break;
        default:
            mexErrMsgTxt("eqns? error: An inexplicable error occurred. Contact your local metaphysicist.\nJust kidding. You're out of memory, that's all.");
    }
}

void mexFunction( int nlhs, mxArray *plhs[], 
                    int nrhs, const mxArray *prhs[] ) {

/* ****************************** */
/* Declare pointers and variables */
/* ****************************** */
    /* EDIT FOR EACH MODEL, AS NECESSARY */
    const int dim = 6;
    char *paramStrings[] = {"M", "Mp", "g", "l", "w", "slope"};
    int paramsLength = 6; /* length of paramStrings[] */
    double *params[6]; /* where ? = paramsLength */
    double M, Mp, g, l, w, slope; /* Model parameters */
    
    double *guard, *x5, *x6, *x7; /* Angles */
    double *x5dot, *x6dot, *x7dot, *x5dotnew, *x6dotnew, *x7dotnew; /* Angle velocities */
    double *x5dotdot, *x6dotdot, *x7dotdot; /* Angle accels */
    /* END EDIT */
    
    int rows, cols, spot, i;
    double *q_in;
    char flag;
    
/* ************ */
/* Parse inputs */
/* ************ */
    /* Find and parse the global variables */
    for (i=0 ; i<paramsLength ; i++) {
        params[i] = mexGetVariablePtr("global", paramStrings[i]);
        if (params[i] == NULL) dieHorribly(4);
    }
    
    /* Find and parse the input q vector */
    i = 0;
    spot = -1;
    while (spot == -1) {
        rows = mxGetM(prhs[i]);
        cols = mxGetN(prhs[i]);
        if ((rows == dim && cols == 1) || (rows == 1 && cols == dim)) {
            spot = i;
        } else {
            i = i + 1;
        }
    }
    if (spot == -1 || spot >= nrhs) dieHorribly(1);
    q_in = mxGetData(prhs[spot]); /* mxArray into double */
    for (i=0 ; i<dim ; i++) {
        mexPrintf("q_in[%i] = %f\n", i, q_in[i]);
        /*q_in[i] = mxCalloc(1, sizeof(long double)); /* Allocate mem */
    }
    
    /* Find and parse our flag */
    if (spot+1 == nrhs-1 && mxIsChar(prhs[spot+1])) {
        flag = *mxGetChars(prhs[spot+1]);
    } else {
        flag = 's';
    }
    if (flag != 's' && flag != 'i' && flag != 'g') dieHorribly(3);
    
/* ************************************ */
/* Copy values and allocate more memory */
/* ************************************ */
    /* EDIT FOR EACH MODEL, AS NECESSARY */
    x5 = mxCalloc(1, sizeof(double));
    x6 = mxCalloc(1, sizeof(long double));
    x7 = mxCalloc(1, sizeof(long double));
    x5dot = mxCalloc(1, sizeof(long double));
    x6dot = mxCalloc(1, sizeof(long double));
    x7dot = mxCalloc(1, sizeof(long double));
    x5dotnew = mxCalloc(1, sizeof(long double));
    x6dotnew = mxCalloc(1, sizeof(long double));
    x7dotnew = mxCalloc(1, sizeof(long double));
    x5dotdot = mxCalloc(1, sizeof(long double));
    x6dotdot = mxCalloc(1, sizeof(long double));
    x7dotdot = mxCalloc(1, sizeof(long double));
    guard = mxCalloc(1, sizeof(long double));
    
    *x5 = q_in[0];
    *x6 = q_in[1];
    *x7 = q_in[2];
    *x5dot = q_in[3];
    *x6dot = q_in[4];
    *x7dot = q_in[5];
    /* END EDIT */
        
    mexPrintf("x5 = %f, x6 = %f, x7 = %f\nx5dot = %f, x6dot = %f, x7dot = %f\n", *x5, *x6, *x7, *x5dot, *x6dot, *x7dot);
    
/* ************************ */
/* Splice, dice and compute */
/* ************************ */
    if (flag == 's') { /* Compute dynamics */
<* Assign[{"*x5dotdot", "*x6dotdot", "*x7dotdot"}, {x5dotdot, x6dotdot, x7dotdot}, CForm, AssignToArray -> {}, AssignEnd->";", AssignIndex->0, AssignIndent->"        ", AssignBreak->False] *>
        plhs[0] = mxCreateDoubleMatrix(dim, 1, mxREAL);
        if (plhs[0] == NULL) dieHorribly(-1);
        mxGetPr(plhs[0])[0] = *x5dot;
        mxGetPr(plhs[0])[1] = *x6dot;
        mxGetPr(plhs[0])[2] = *x7dot;
        mxGetPr(plhs[0])[3] = *x5dotdot;
        mxGetPr(plhs[0])[4] = *x6dotdot;
        mxGetPr(plhs[0])[5] = *x7dotdot;
    } else if (flag == 'i') { /* Compute impact with transition map */
<* Assign[{"*x5dotnew", "*x6dotnew", "*x7dotnew"}, {x5dotimpact, x6dotimpact, x7dotimpact}, CForm, AssignToArray -> {}, AssignEnd->";", AssignIndex->0, AssignIndent->"        ", AssignBreak->False] *>
        plhs[0] = mxCreateDoubleMatrix(dim, 1, mxREAL);
        if (plhs[0] == NULL) dieHorribly(-1);
        mxGetPr(plhs[0])[0] = *x5;
        mxGetPr(plhs[0])[1] = *x6+*x7;
        mxGetPr(plhs[0])[2] = -*x7;
        mxGetPr(plhs[0])[3] = *x5dot;
        mxGetPr(plhs[0])[4] = *x6dot;
        mxGetPr(plhs[0])[5] = *x7dot;
    } else if (flag == 'g') { /* Compute guard function */
<* Assign["*guard", guard, CForm, AssignToArray -> {}, AssignEnd->";", AssignIndex->0, AssignIndent->"        ", AssignBreak->False] *>
        plhs[0] = mxCreateScalarDouble(*guard);
        if (plhs[0] == NULL) dieHorribly(-1);
    }
        
/* *********************************** */
/* Free allocated memory, just in case */
/* *********************************** */
    mxFree(x5);
    mxFree(x6);
    mxFree(x7);
    mxFree(x5dot);
    mxFree(x6dot);
    mxFree(x7dot);
    mxFree(x5dotnew);
    mxFree(x6dotnew);
    mxFree(x7dotnew);
    mxFree(x5dotdot);
    mxFree(x6dotdot);
    mxFree(x7dotdot);
    mxFree(guard);
}
