
/* If you're porting this file to another model, be it 3D or 2D, look for
 * comments that say "EDIT FOR EACH MODEL", and also make 
 * sure that everything between the and brackets applies to the 
 * naming convention in your Mathematica notebook file and also to this
 * file. */

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
        case 5:
            mexErrMsgTxt("eqns3 error: You have NaN or Inf output.\n");
            break;
        case 6:
            mexErrMsgTxt("eqns3 error: Cannot allocate memory for calloc.\n");
            break;
        default:
            mexErrMsgTxt("eqns3 error: The sky is falling, or Eric made a logical typo.\n");
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
    const int dim = 6;
    char *paramNames[6] = {"M", "Mp", "g", "l", "w", "slope"};
    mxArray *params;
    double M, Mp, g, l, w, slope; /* Model parameters */    
    double *tmp; /* After splicing, make sure tmp is large enough */
    double *q;
    double *out;
    double guard;

    /* Template formatting options. You may need to edit AssignReplace!
    Null
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
    for (i=0 ; i<6 ; i++) {
        params = mexGetVariable("global", paramNames[i]);
        if (params == NULL) dieHorribly(4);
        switch(i) {
            /* EDIT FOR EACH MODEL */
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
        if (mxIsNaN(q[i]) == 1 | mxIsInf(q[i]) == 1) {
            /* mexPrintf("eqns3 error: Input is NaN or Inf. Setting global variable 'invalidResults' to '1'.\n"); */
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
        tmp = mxCalloc(10, sizeof(double));
        plhs[0] = mxCreateDoubleMatrix(dim, 1, mxREAL);
        if (plhs[0] == NULL) dieHorribly(-1);
        out = mxGetPr(plhs[0]);
        
        /* EDIT FOR EACH MODEL */        
        /* Compute dynamics: */
        tmp[1]=2./l;
        tmp[2]=1/(6.*M+4.*Mp+(5.*M+4.*Mp)*cos(2.*q[1])+M*(-4.*cos(q[2])+cos(2.*(q[1]+q[2]))-4.*cos(2.*q[1]+q[2])));
        tmp[3]=2.*g*((3.*M+2.*Mp)*cos(q[1])-M*cos(q[1]+q[2]))*sin(q[0]);
        tmp[4]=l*q[5]*(q[4]*((5.*M+4.*Mp)*sin(2.*q[1])+M*(sin(2.*(q[1]+q[2]))-4.*sin(2.*q[1]+q[2])))+M*q[5]*(-2.*sin(q[2])+sin(2.*(q[1]+q[2]))-2.*sin(2.*q[1]+q[2])));
        out[3]=tmp[1]*tmp[2]*(tmp[3]+tmp[4]);
        tmp[1]=0.5/l;
        tmp[2]=1/(-3.*M-4.*Mp+2.*M*cos(2.*q[2]));
        tmp[3]=4.*l*M*(pow(q[4]+q[5],2.)*sin(q[2])-pow(q[4],2.)*sin(2.*q[2]));
        tmp[4]=4.*g*cos(q[0])*(-2.*(M+Mp)*sin(q[1])+M*sin(q[1]+2.*q[2]))+l*pow(q[5],2.)*((3.*M+4.*Mp)*sin(2.*q[1])+4.*M*(pow(cos(q[1]+q[2]),2.)*sin(q[2])-cos(q[1])*sin(q[1]+2.*q[2])));
        out[4]=tmp[1]*tmp[2]*(tmp[3]+tmp[4]);
        tmp[1]=1/l;
        tmp[2]=1/(-3.*M-4.*Mp+2.*M*cos(2.*q[2]));
        tmp[3]=4.*(-3.*M-2.*Mp+2.*M*cos(q[2]))*pow(q[4],2.)+2.*M*(-1.+2.*cos(q[2]))*pow(q[5],2.);
        tmp[4]=(-6.*M-4.*Mp-(5.*M+4.*Mp)*cos(2.*q[1])+4.*M*cos(q[2])-M*cos(2.*(q[1]+q[2]))+(5.*M+4.*Mp)*cos(2.*q[1]+q[2]))*pow(q[5],2.)+4.*M*(-1.+2.*cos(q[2]))*q[4]*q[5];
        tmp[5]=sin(q[2]);
        tmp[6]=2.*g*cos(q[0])*((-3.*M-2.*Mp)*(-1.+2.*cos(q[2]))*sin(q[1])+(5.*M+4.*Mp-2.*M*cos(q[2]))*sin(q[1]+q[2]));
        out[5]=tmp[1]*tmp[2]*(l*(tmp[3]+tmp[4])*tmp[5]+tmp[6]);
        /* End dynamics. */
        
        /* The last half of the input is the first half of the output */
        for (i=0 ; i<dim/2 ; i++) {
            /* Check to see if the calculations were NaN or Inf */
            if (mxIsNaN(out[i+dim/2]) == 1 || mxIsInf(out[i+dim/2]) == 1) {
                /* mexPrintf("eqns3 error: Dynamics output is NaN or Inf. Setting global variable 'invalidResults' to '1'.\n"); */
                /* mexPrintf("invalid value is %f", out[i+dim/2]); */
                putInvalid();
            }
            out[i] = q[i+dim/2];
        }
        /* END EDIT */
        mxFree(tmp);



        
        
        
    } else if (flag == 'i') {
        /* Allocate memory for output */
        tmp = mxCalloc(10, sizeof(double));
        plhs[0] = mxCreateDoubleMatrix(dim, 1, mxREAL);
        if (plhs[0] == NULL) dieHorribly(6);
        out = mxGetPr(plhs[0]);

        /* EDIT FOR EACH MODEL */
        /* Compute impact: */
        out[3]=((-(M*cos(2.*q[1]))+4.*(M+Mp)*cos(q[2])-M*(2.+cos(2.*(q[1]+q[2])))+4.*(M+Mp)*cos(2.*q[1]+q[2]))*q[5])/(6.*M+4.*Mp+M*cos(2.*q[1])-4.*M*cos(q[2])+(5.*M+4.*Mp)*cos(2.*(q[1]+q[2]))-4.*M*cos(2.*q[1]+q[2]));
        out[4]=((M+2.*M*cos(q[2])-4.*(M+Mp)*cos(2.*q[2]))*q[4]+2.*M*cos(q[2])*q[5])/(-3.*M-4.*Mp+2.*M*cos(2.*q[2]));
        out[5]=(-4.*(M+Mp)*(cos(q[2])-cos(2.*q[2]))*q[4]+M*(1.-2.*cos(q[2]))*q[5])/(-3.*M-4.*Mp+2.*M*cos(2.*q[2]));
        /* End impact. */
        
        /* Check for valid output */
        for (i=dim/2 ; i<dim ; i++) {
            if (mxIsNaN(out[i]) == 1 || mxIsInf(out[i]) == 1) {
                /* mexPrintf("eqns3 error: Impact equations' output is NaN or Inf. Setting global variable 'invalidResults' to '1'.\n"); */
                putInvalid();
            }
        }
        
        /* Apply transition map: */
        out[0] = q[0];
        out[1] = q[1] + q[2];
        out[2] = -q[2];
        /* END EDIT */
        mxFree(tmp);






    } else if (flag == 'g') { 
        /* EDIT FOR EACH MODEL */
        /* Compute guard function: */
        guard=2.*l*cos(q[0])*sin(q[1]+0.5*q[2])*sin(0.5*q[2])+l*(-sin(q[1])+sin(q[1]+q[2]))*tan(slope);
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
