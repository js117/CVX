
/* NOTE: Look for comments that say: "EDIT FOR EACH MODEL, AS NECESSARY" */

/* Also, the following calls to this function are allowed:
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

#include "math.h"
#include "mex.h"

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
    const int dim = 6, paramsLength = 6;
    char *paramStrings[6] = {"M", "Mp", "g", "l", "w", "slope"};
    double *params[6]; /* double *params[paramsLength] */
    double M, Mp, g, l, w, slope; /* Model parameters */
    
    double tmp[100]; /* After splicing, make sure tmp is large enough */
    double q[6]; /* double q[dim]; */
    double *guard; /* Angles */
    double qdotdot[3]; /* double qdot[dim/2]; */
    double qnew[3]; /* double qdot_tmp[dim/2]; */

    /* Template formatting options. You may need to edit AssignReplace!
    <* SetOptions[CAssign, 
    AssignMaxSize->2000,
    AssignTemporary->{"tmp", Array}, 
    AssignTrig->True,
    AssignToArray->{q, qdot, params},
    AssignBreak->False,
    AssignOptimize->False,
    AssignIndent->"        ",
    AssignReplace->{
        "x5dot"->"q[3]", 
        "x6dot"->"q[4]",
        "x7dot"->"q[5]",
        "x5"->"q[0]", 
        "x6"->"q[1]",
        "x7"->"q[2]",
        "Mp"->"params[1]",
        "M"->"params[0]",
        "g"->"params[2]",
        "l"->"params[3]",
        "w"->"params[4]",
        "slope"->"params[5]"}]; *>
    /* END EDIT */
    
    int rows, cols, spot, i;
    double *q_in;
    char flag;
    
/* ************************ */
/* Initialize output arrays */
/* ************************ */
    for (i=0 ; i<100 ; i++) {
        tmp[i] = 0.;
    }
    for (i=0 ; i<dim ; i++) {
        qdot[i] = 0.;
        q_tmp[i] = 0.;
    }
/* ************ */
/* Parse inputs */
/* ************ */
    /* Find and parse global model parameters */
    for (i=0 ; i<paramsLength ; i++) {
        params[i] = mexGetVariablePtr("global", paramStrings[i]);
        mexPrintf("q_in[%i] = %f\n", i, q[i]);
        if (params[i] == NULL) dieHorribly(4);
    }
    
    /* Find and parse q vector */
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
    q[0] = mxGetData(prhs[spot]); /* mxArray into double */
    for (i=0 ; i<dim ; i++) {
        mexPrintf("q_in[%i] = %f\n", i, q[i]);
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
        /* Compute dynamics: */
<* CAssign[{qdotdot[0], qdotdot[1], qdotdot[2]}, {x5dotdot, x6dotdot, x7dotdot}] *>
        /* End dynamics. */
        plhs[0] = mxCreateDoubleMatrix(dim, 1, mxREAL);
        if (plhs[0] == NULL) dieHorribly(-1);
        /* Pass out derivative of q vector */
        for (i=0 ; i<dim/2 ; i++) {
            mxGetData(plhs[0])[i] = q[i+dim/2];
            mxGetData(plhs[0])[i+dim/2] = qdotdot[i];
        }



    } else if (flag == 'i') {
        /* Compute impact: */
<* CAssign[{qnew[0], qnew[1], qnew[2]}, {x5dotimpact, x6dotimpact, x7dotimpact}] *>
        /* End impact. */
        plhs[0] = mxCreateDoubleMatrix(dim, 1, mxREAL);
        if (plhs[0] == NULL) dieHorribly(-1);
        /* Apply transition map: */
        mxGetData(plhs[0])[0] = q[0];
        mxGetData(plhs[0])[1] = q[1]+q[2];
        mxGetData(plhs[0])[2] = -q[2];
        for (i=dim/2 ; i<dim ; i++) {
            mxGetData(plhs[0])[i] = q_tmp[i];
        }



    } else if (flag == 'g') { 
    /* Compute guard function: */
<* CAssign[*guard, guard] *>
    /* End guard function. */
        plhs[0] = mxCreateScalarDouble(guard);
        if (plhs[0] == NULL) dieHorribly(-1);
        mxGetData(plhs[0]) = guard;
    }
        
/* ********************* */
/* Free allocated memory */
/* ********************* */
    /*mxFree(x5);
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
    mxFree(guard);*/
}
