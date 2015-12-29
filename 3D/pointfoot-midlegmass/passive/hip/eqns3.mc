
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
            mexErrMsgTxt("eqns3 error:\nThe following calls are allowed:\nnrhs == 1:\n   eqns3(q)\nnrhs == 2:\n   eqns3(t, q)\n   eqns?(q, flag)\nnrhs == 3:\n   eqns3(t, q, flag)\n\nt = time (but only if called by ode45), q = state vector, flag = 's' or 'i' or 'g'.\n");
            break;
        case 1:
            mexErrMsgTxt("eqns3 error:\nMake sure that the input state vector has the right dimensions, is either a column or row vector, and is the first or second argument.");
            break;
        case 2:
            mexErrMsgTxt("eqns3 error:\nWrong # of arguments enter 1, 2 or 3 inputs.\n");
            break;
        case 3:
            mexErrMsgTxt("eqns3 error:\nThe flag must be 's' to compute dynamics, 'i' to compute impact, or 'g' to compute the guard function.\n");
            break;
        case 4:
            mexErrMsgTxt("eqns3 error:\nDefine your global variables first: try running pop.\n");
            break;
        default:
            mexErrMsgTxt("eqns3 error: An inexplicable error occurred. Contact your local metaphysicist.\n");
    }
}

void mexFunction( int nlhs, mxArray *plhs[], 
                    int nrhs, const mxArray *prhs[] ) {
    
/* ****************************** */
/* Declare pointers and variables */
/* ****************************** */
/* EDIT FOR EACH MODEL, AS NECESSARY */
    const int dim = 6;
    char *paramNames[6] = {"M", "Mp", "g", "l", "w", "slope"};
    mxArray *params;
    double M, Mp, g, l, w, slope; /* Model parameters */    
    double tmp[100]; /* After splicing, make sure tmp is large enough */
    double q[6]; /* double q[dim]; */
    double guard; /* Angles */
    double qdotdot[3]; /* double qdot[dim/2]; */
    double qnew[3]; /* double qdot_tmp[dim/2]; */

    /* Template formatting options. You may need to edit AssignReplace!
    <* SetOptions[CAssign, 
    AssignTemporary->{"tmp", Array}, 
    AssignTrig->True,
    AssignToArray->{q, qnew, qdotdot},
    AssignBreak->False,
    AssignOptimize->False,
    AssignIndent->"        ",
    AssignReplace->{
        "x5dot"->"q[3]",
        "x6dot"->"q[4]",
        "x7dot"->"q[5]",
        "x5"->"q[0]",
        "x6"->"q[1]",
        "x7"->"q[2]"}]; *>
/* END EDIT */
    
    int spot = 0, i = 0;
    char flag;
    
/* ************ */
/* Parse inputs */
/* ************ */
    if (nrhs == 0) dieHorribly(0);
    
    /* Find and parse global model parameters */
    for (i=0 ; i<6 ; i++) {
        params = mexGetVariable("global", paramNames[i]);
        if (params == NULL) dieHorribly(4);
        switch(i) {
/* EDIT FOR EACH MODEL, AS NECESSARY */
            case 0: M = *mxGetPr(params); break;
            case 1: Mp = *mxGetPr(params); break;
            case 2: g = *mxGetPr(params); break;
            case 3: l = *mxGetPr(params); break;
            case 4: w = *mxGetPr(params); break;
            case 5: slope = *mxGetPr(params); break;
            default: dieHorribly(-1);
/* END EDIT */
        }
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
        /* if (i < 3) q[i] = fmod(q[i], (double) M_PI*2); */
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
        /* Compute dynamics: */
<* CAssign[{qdotdot[0], qdotdot[1], qdotdot[2]}, {x5dotdot, x6dotdot, x7dotdot}] *>
        /* End dynamics. */
        plhs[0] = mxCreateDoubleMatrix(dim, 1, mxREAL);
        if (plhs[0] == NULL) dieHorribly(-1);
        /* Pass out derivative of q vector */
        for (i=0 ; i<dim/2 ; i++) {
            if (isnan(q[i+dim/2]) || isinf(q[i+dim/2]) || isnan(qdotdot[i]) || isinf(qdotdot[i])) {
                plhs[0] == NULL;
            } else {
                mxGetPr(plhs[0])[i] = q[i+dim/2];
                mxGetPr(plhs[0])[i+dim/2] = qdotdot[i];
            }
        }



    } else if (flag == 'i') {
        /* Compute impact: */
<* CAssign[{qnew[0], qnew[1], qnew[2]}, {x5dotimpact, x6dotimpact, x7dotimpact}] *>
        /* End impact. */
        plhs[0] = mxCreateDoubleMatrix(dim, 1, mxREAL);
        if (plhs[0] == NULL) dieHorribly(-1);
        /* Pass out half the q vector after impact */
        for (i=dim/2 ; i<dim ; i++) {
            if (isnan(qnew[i]) || isinf(qnew[i]) || isnan(q[i]) || isinf(q[i])) {
                plhs[0] = NULL;
            } else {
                mxGetPr(plhs[0])[i] = qnew[i];
            }
        }
/* EDIT FOR EACH MODEL, AS NECESSARY */
        /* Apply transition map: */
        mxGetPr(plhs[0])[0] = q[0];
        mxGetPr(plhs[0])[1] = q[1]+q[2];
        mxGetPr(plhs[0])[2] = -q[2];
/* END EDIT */



    } else if (flag == 'g') { 
    /* Compute guard function: */
<* CAssign[guard, guard] *>
    /* End guard function. */
        plhs[0] = mxCreateScalarDouble(guard);
        if (plhs[0] == NULL) dieHorribly(-1);
    }
}
