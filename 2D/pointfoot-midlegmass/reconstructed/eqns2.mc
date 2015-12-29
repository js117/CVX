
/* If you're porting this file to another model, be it 3D or 2D, look for
 * comments that say "EDIT FOR EACH MODEL", and also make 
 * sure that everything between the and brackets applies to the 
 * naming convention in your Mathematica notebook file and also to this
 * file. */

/* Also, the following calls to this function are allowed:
 *
 * nrhs == 1:
 *      eqns2(q)
 * nrhs == 2:
 *      eqns2(t, q)
 *      eqns2(q, flag)
 * nrhs == 3:
 *      eqns2(t, q, flag)
 *
 * q = state vector, t = time, flag = 's', 'g', or 'i'.
 * Notice that the flag is always the last element, and follows the q 
 * vector no matter which argument the q vector is.
 *
 */

#include "math.h"
#include "mex.h"

void dieHorribly( int option ) {

    switch (option) {
        case 0:
            mexErrMsgTxt("eqns2 error:\nThe following calls are allowed:\nnrhs == 1:\n   eqns2(q)\nnrhs == 2:\n   eqns2(t, q)\n   eqns?(q, flag)\nnrhs == 3:\n   eqns2(t, q, flag)\n\nt = time (but only if called by ode45), q = state vector, flag = 's' or 'i' or 'g'.\n");
            break;
        case 1:
            mexErrMsgTxt("eqns2 error:\nMake sure that the input state vector has the right dimensions, is either a column or row vector, and is the first or second argument.");
            break;
        case 2:
            mexErrMsgTxt("eqns2 error:\nWrong # of arguments enter 1, 2 or 3 inputs.\n");
            break;
        case 3:
            mexErrMsgTxt("eqns2 error:\nThe flag must be 's' to compute dynamics, 'i' to compute impact, or 'g' to compute the guard function.\n");
            break;
        case 4:
            mexErrMsgTxt("eqns2 error:\nDefine your global variables first: try running pop.\n");
            break;
        case 5:
            mexErrMsgTxt("eqns2 error: You have NaN or Inf output.\n");
            break;
        case 6:
            mexErrMsgTxt("eqns2 error: Cannot allocate memory for calloc.\n");
            break;
        default:
            mexErrMsgTxt("eqns2 error: The sky is falling, or Eric made a logical typo.\n");
            break;
    }
}

void putInvalid() {
    mxArray *invalidValue;
    int success;
    double value = 1.;
    
    invalidValue = mxCreateScalarDouble(value);
    success = mexPutVariable("global", "invalidResults", invalidValue);
    if (success == 1) {
        dieHorribly(-1);
    }
}

void mexFunction( int nlhs, mxArray *plhs[], 
                    int nrhs, const mxArray *prhs[] ) {
    
/* ****************************** */
/* Declare pointers and variables */
/* ****************************** */
/* EDIT FOR EACH MODEL */
    const int dim = 5, halfdim = 2;
    char *paramNames[7] = {"M", "Mp", "g", "L", "alpha", "slope", "c"};
    mxArray *params;
    double M, Mp, g, L, alpha, slope, beta, c; /* Model parameters */    
    /* *tmp; /* After splicing, make sure tmp is large enough */
    double *q;
    double *out;
    double guard;

    /* Template formatting options. You may need to edit AssignReplace!
    <* SetOptions[CAssign, 
    AssignTemporary->{"tmp", Array}, 
    AssignTrig->True,
    AssignToArray->{q, out},
    AssignBreak->False,
    AssignOptimize->False,
    AssignReplace->{"Beta"->"beta"},
    AssignIndent->"        "]; *>
/* END EDIT */
    
    int spot = 0, i = 0;
    char flag; 
    q = calloc(dim, sizeof(double));
    if (q == NULL) dieHorribly(6);
    
/* ************ */
/* Parse inputs */
/* ************ */
    if (nrhs == 0) dieHorribly(0);
    
    /* Find and parse global model parameters */
    for (i=0 ; i<7 ; i++) {
        params = mexGetVariable("global", paramNames[i]);
        if (params == NULL) dieHorribly(4);
        switch(i) {
            /* EDIT FOR EACH MODEL */
            case 0: M = *mxGetPr(params); break;
            case 1: Mp = *mxGetPr(params); break;
            case 2: g = *mxGetPr(params); break;
            case 3: L = *mxGetPr(params); break;
            case 4: alpha = *mxGetPr(params); break;
            case 5: slope = *mxGetPr(params); break;
            case 6: c = *mxGetPr(params); break;
            default: dieHorribly(-1);
            /* END EDIT */
        }
    }
    beta = slope - alpha;
    if (mxIsNaN(beta) == 1 || mxIsInf(beta) == 1) {
        putInvalid();
    }
    
    /* Find and parse q vector */
    i = 0;
    spot = -1;
    while (spot == -1) {
        if ((mxGetM(prhs[i]) == dim && mxGetN(prhs[i]) == 1) || 
            (mxGetM(prhs[i]) == 1   && mxGetN(prhs[i]) == dim)) {
            spot = i;
        } else {
            i = i + 1;
        }
    }
    for (i=0 ; i<dim ; i++) {
        q[i] = mxGetPr(prhs[spot])[i];
        if (mxIsNaN(q[i]) == 1 || mxIsInf(q[i]) == 1) {
            /* mexPrintf("eqns2 error: Input is NaN or Inf. Setting global variable 'invalidResults' to '1'.\n"); */
            putInvalid();
        }
        /* mexPrintf("q[%i] = %f\n", i, q[i]); */
    }
    
    /* Find and parse flag */
    if (spot+1 == nrhs-1 && mxIsChar(prhs[spot+1])) {
        flag = *mxGetChars(prhs[spot+1]);
    } else {
        flag = 's';
    }
    if (flag != 's' && flag != 'i' && flag != 'g') dieHorribly(3);

/* ************************ */
/* Splice, dice and compute */
/* ************************ */
    if (flag == 's') {
        /* Allocate memory for output */
        /* tmp = mxCalloc(10, sizeof(double)); */
        plhs[0] = mxCreateDoubleMatrix(dim, 1, mxREAL);
        if (plhs[0] == NULL) dieHorribly(-1);
        out = mxGetPr(plhs[0]);
        
        /* EDIT FOR EACH MODEL */        
        /* Compute dynamics: */
<* CAssign[{out[2], out[3], out[4]}, {q1dotdot, q2dotdot, phidot}] *>
        /* End dynamics. */
        
        /* The last half of the input is the first half of the output */
        for (i=0 ; i<halfdim ; i++) {
            /* Check to see if the calculations were NaN or Inf */
            if (mxIsNaN(out[i+halfdim]) == 1 || mxIsInf(out[i+halfdim]) == 1) {
                /* mexPrintf("eqns2 error: Dynamics output is NaN or Inf. Setting global variable 'invalidResults' to '1'.\n"); */
                /* mexPrintf("invalid value is %f", out[i+halfdim]); */
                putInvalid();
            }
            out[i] = q[i+halfdim];
        }
        if (mxIsNaN(out[dim-1]) == 1 || mxIsInf(out[dim-1]) == 1) {
            putInvalid();
        }
        /* END EDIT */
        /* mxFree(tmp); */



        
        
        
    } else if (flag == 'i') {
        /* Allocate memory for output */
        /* tmp = mxCalloc(10, sizeof(double)); */
        plhs[0] = mxCreateDoubleMatrix(dim, 1, mxREAL);
        if (plhs[0] == NULL) dieHorribly(6);
        out = mxGetPr(plhs[0]);

        /* EDIT FOR EACH MODEL */
        /* Compute impact: */
<* CAssign[{out[2], out[3]}, {q1dotimpact, q2dotimpact}] *>
        out[4] = q[4];
        /* End impact. */
        
        /* Check for valid output */
        for (i=halfdim ; i<dim ; i++) {
            if (mxIsNaN(out[i]) == 1 || mxIsInf(out[i]) == 1) {
                /* mexPrintf("eqns2 error: Impact equations' output is NaN or Inf. Setting global variable 'invalidResults' to '1'.\n"); */
                putInvalid();
            }
        }
        
        /* Apply transition map: */
        out[0] = q[1];
        out[1] = q[0];
        /* END EDIT */
        /* mxFree(tmp); */






    } else if (flag == 'g') { 
        /* EDIT FOR EACH MODEL */
        /* Compute guard function: */
<* CAssign[guard, guard] *>
        if (mxIsNaN(guard) == 1 || mxIsInf(guard) == 1) {
            putInvalid();
        }
        /* End guard function. */
        plhs[0] = mxCreateScalarDouble(guard);
        if (plhs[0] == NULL) dieHorribly(6);
        /* END EDIT */
    }
    
/* ************************ */
/* Free up allocated memory */
/* ************************ */ 
    free(q);
}
