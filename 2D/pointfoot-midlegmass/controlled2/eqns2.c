
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
    char *paramNames[7] = {"M", "Mp", "g", "L", "alpha", "slope", "mu"};
    mxArray *params;
    double M, Mp, g, L, alpha, slope, beta, mu; /* Model parameters */    
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
            case 6: mu = *mxGetPr(params); break;
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
        tmp = mxCalloc(39, sizeof(double));
        plhs[0] = mxCreateDoubleMatrix(dim, 1, mxREAL);
        if (plhs[0] == NULL) dieHorribly(-1);
        out = mxGetPr(plhs[0]);
        
        /* EDIT FOR EACH MODEL */        
        /* Compute dynamics: */
        tmp[1] = 0.5*pow(L,-4.);
        tmp[2] = 1/(-5.*M - 4.*Mp + 4.*M*pow(cos(q[0] - q[1]),2.));
        tmp[3] = pow(6.*M + 4.*Mp + (5.*M + 4.*Mp)*cos(2.*q[0]) - 8.*M*cos(q[0])*cos(q[1]) + M*cos(2.*q[1]),-2.);
        tmp[4] = -g;
        tmp[5] = pow(L,3.);
        tmp[6] = 416.*Mp*(M*M) + 2.*(17.*M + 6.*Mp)*cos(4.*q[1])*(M*M) + 256.*M*(Mp*Mp);
        tmp[7] = M*cos(2.*q[1])*(248.*M*Mp + 229.*(M*M) + 64.*(Mp*Mp)) + 246.*pow(M,3.) + cos(6.*q[1])*pow(M,3.) + 64.*pow(Mp,3.);
        tmp[8] = -256.*M*(mu*mu)*pow(cos(q[1]),3.);
        tmp[9] = sin(q[0]);
        tmp[10] = 8.*M;
        tmp[11] = 16.*cos(2.*q[1])*(mu*mu);
        tmp[12] = g*(2.*(3.*M + 2.*Mp)*(11.*M + 8.*Mp)*cos(q[1]) + M*(17.*M + 12.*Mp)*cos(3.*q[1]))*pow(L,3.);
        tmp[13] = sin(2.*q[0]);
        tmp[14] = 8.*(8.*(3.*M + 4.*Mp)*(mu*mu) + g*cos(5.*q[1])*pow(L,3.)*pow(M,3.))*sin(2.*q[0]);
        tmp[15] = -(g*M*((7.*M + 4.*Mp)*(33.*M + 20.*Mp)*cos(2.*q[1]) + 2.*M*(13.*M + 4.*Mp)*cos(4.*q[1]))*pow(L,3.)*sin(3.*q[0]));
        tmp[16] = 16.*g*M*(5.*M + 4.*Mp)*cos(q[1])*(2.*(M + Mp) + M*cos(2.*q[1]))*pow(L,3.)*sin(4.*q[0]);
        tmp[17] = -(g*M*cos(2.*q[1])*pow(L,3.)*pow(5.*M + 4.*Mp,2.)*sin(5.*q[0]));
        tmp[18] = 2.*g;
        tmp[19] = (5.*M + 4.*Mp)*pow(L,3.)*((-31.*M*Mp - 28.*(M*M) - 12.*(Mp*Mp))*sin(3.*q[0]) - (M + Mp)*(5.*M + 4.*Mp)*sin(5.*q[0]));
        tmp[20] = 4.*M*pow(L,4.);
        tmp[21] = pow(6.*M + 4.*Mp + (5.*M + 4.*Mp)*cos(2.*q[0]) - 8.*M*cos(q[0])*cos(q[1]) + M*cos(2.*q[1]),2.);
        tmp[22] = (2.*cos(q[0] - q[1])*pow(q[2],2.) - pow(q[3],2.))*sin(q[0] - q[1]);
        tmp[23] = -16.*M*cos(q[0])*(-4.*(mu*mu) + 2.*g*M*cos(q[0])*(6.*M + 4.*Mp + (5.*M + 4.*Mp)*cos(2.*q[0]))*pow(L,3.))*sin(q[1]);
        tmp[24] = M*cos(q[0]);
        tmp[25] = -256.*cos(q[0])*(mu*mu);
        tmp[26] = pow(L,3.);
        tmp[27] = 272.*M*Mp + 259.*(M*M);
        tmp[28] = 96.*(Mp*Mp) + 16.*cos(2.*q[0])*(22.*M*Mp + 19.*(M*M) + 8.*(Mp*Mp)) + 2.*cos(4.*q[0])*pow(5.*M + 4.*Mp,2.);
        tmp[29] = sin(2.*q[1]);
        tmp[30] = -16.*M*cos(q[0])*(-4.*(mu*mu) + g*M*(6.*(3.*M + 2.*Mp)*cos(q[0]) + (5.*M + 4.*Mp)*cos(3.*q[0]))*pow(L,3.))*sin(3.*q[1]);
        tmp[31] = 4.*g*cos(q[0])*(14.*M + 4.*Mp + (13.*M + 4.*Mp)*cos(2.*q[0]))*(M*M)*pow(L,3.)*sin(4.*q[1]);
        tmp[32] = -16.*g*pow(L,3.)*pow(M,3.)*pow(cos(q[0]),2.)*sin(5.*q[1]) + g*cos(q[0])*pow(L,3.)*pow(M,3.)*sin(6.*q[1]);
        tmp[33] = (tmp[4]*tmp[5]*(tmp[6] + tmp[7]) + tmp[8])*tmp[9] + tmp[10]*(tmp[11] + tmp[12])*tmp[13] + tmp[14] + tmp[15] + tmp[16] + tmp[17];
        tmp[34] = tmp[18]*tmp[19] + tmp[20]*tmp[21]*tmp[22] + tmp[23] + tmp[24]*(tmp[25] + g*tmp[26]*(tmp[27] + tmp[28]))*tmp[29] + tmp[30] + tmp[31] + tmp[32];
        out[2] = tmp[1]*tmp[2]*tmp[3]*(tmp[33] + tmp[34]);
        tmp[1] = 0.5*pow(L,-4.);
        tmp[2] = 1/(-5.*M - 4.*Mp + 4.*M*pow(cos(q[0] - q[1]),2.));
        tmp[3] = pow(6.*M + 4.*Mp + (5.*M + 4.*Mp)*cos(2.*q[0]) - 8.*M*cos(q[0])*cos(q[1]) + M*cos(2.*q[1]),-2.);
        tmp[4] = 32.*g*M*(3.*M + 2.*Mp)*(13.*M + 8.*Mp + 2.*(5.*M + 4.*Mp)*cos(2.*q[0]) + M*cos(4.*q[1]))*pow(L,3.)*pow(cos(q[0]),2.)*sin(q[0]);
        tmp[5] = -128.*M*(mu*mu)*sin(2.*q[0]) - 128.*M*cos(2.*q[1])*(mu*mu)*sin(2.*q[0]);
        tmp[6] = -(g*M*(3.*M + 2.*Mp)*(57.*M + 16.*Mp + 4.*(13.*M + 4.*Mp)*cos(2.*q[0]))*cos(3.*q[1])*pow(L,3.)*sin(2.*q[0]));
        tmp[7] = -(g*(3.*M + 2.*Mp)*cos(5.*q[1])*(M*M)*pow(L,3.)*sin(2.*q[0]));
        tmp[8] = -2.*g*(3.*M + 2.*Mp);
        tmp[9] = cos(q[1])*pow(L,3.);
        tmp[10] = 2.*(72.*M*Mp + 79.*(M*M) + 24.*(Mp*Mp));
        tmp[11] = 2.*cos(2.*q[0])*(92.*M*Mp + 89.*(M*M) + 32.*(Mp*Mp)) + cos(4.*q[0])*pow(5.*M + 4.*Mp,2.);
        tmp[12] = sin(2.*q[0]);
        tmp[13] = 4.*pow(L,4.);
        tmp[14] = pow(6.*M + 4.*Mp + (5.*M + 4.*Mp)*cos(2.*q[0]) - 8.*M*cos(q[0])*cos(q[1]) + M*cos(2.*q[1]),2.);
        tmp[15] = (5.*M + 4.*Mp)*pow(q[2],2.)*sin(q[0] - q[1]) - M*pow(q[3],2.)*sin(2.*(q[0] - q[1]));
        tmp[16] = -64.*(5.*M + 4.*Mp)*cos(3.*q[0])*(mu*mu);
        tmp[17] = g*cos(2.*q[0])*pow(L,3.)*(2522.*Mp*(M*M) + 1856.*M*(Mp*Mp) + 1191.*pow(M,3.) + 480.*pow(Mp,3.));
        tmp[18] = pow(L,3.);
        tmp[19] = 2.*cos(4.*q[0])*(508.*Mp*(M*M) + 376.*M*(Mp*Mp) + 239.*pow(M,3.) + 96.*pow(Mp,3.));
        tmp[20] = 2.*(838.*Mp*(M*M) + 616.*M*(Mp*Mp) + 393.*pow(M,3.) + 160.*pow(Mp,3.)) + (3.*M + 2.*Mp)*cos(6.*q[0])*pow(5.*M + 4.*Mp,2.);
        tmp[21] = sin(q[1]);
        tmp[22] = -8.*(3.*M + 4.*Mp)*(mu*mu);
        tmp[23] = -16.*M*cos(2.*q[0])*(mu*mu);
        tmp[24] = g*M*((3.*M + 2.*Mp)*(5.*M + 4.*Mp)*cos(5.*q[0]) + cos(3.*q[0])*(106.*M*Mp + 71.*(M*M) + 40.*(Mp*Mp)))*pow(L,3.);
        tmp[25] = sin(2.*q[1]);
        tmp[26] = g*M;
        tmp[27] = 218.*M*Mp + 2.*(3.*M + 2.*Mp)*(13.*M + 4.*Mp)*cos(4.*q[0]);
        tmp[28] = 188.*(M*M) + 48.*(Mp*Mp) + cos(2.*q[0])*(294.*M*Mp + 269.*(M*M) + 64.*(Mp*Mp));
        tmp[29] = pow(L,3.)*sin(3.*q[1]);
        tmp[30] = cos(q[0]);
        tmp[31] = 8.*(5.*M + 4.*Mp)*cos(q[1])*(mu*mu)*sin(2.*q[0]);
        tmp[32] = 2.*g*M*(3.*M + 2.*Mp)*(7.*M + 4.*Mp + (5.*M + 4.*Mp)*cos(2.*q[0]))*cos(2.*q[1])*pow(L,3.)*sin(2.*q[0]);
        tmp[33] = -12.*(5.*M + 4.*Mp)*(mu*mu)*sin(q[1]);
        tmp[34] = -(g*M*(104.*M*Mp + 67.*(M*M) + 40.*(Mp*Mp))*pow(L,3.)*sin(2.*q[1]));
        tmp[35] = -(g*(2.*(M + Mp) + (3.*M + 2.*Mp)*cos(2.*q[0]))*(M*M)*pow(L,3.)*sin(4.*q[1]));
        tmp[36] = g*(2.*(M + Mp) + (3.*M + 2.*Mp)*cos(2.*q[0]))*(M*M)*pow(L,3.)*sin(5.*q[1]);
        tmp[37] = tmp[13]*tmp[14]*tmp[15] + (tmp[16] + tmp[17] + g*tmp[18]*(tmp[19] + tmp[20]))*tmp[21] - 8.*(tmp[22] + tmp[23] + tmp[24])*tmp[25];
        tmp[38] = tmp[26]*(tmp[27] + tmp[28])*tmp[29] + 16.*tmp[30]*(tmp[31] + tmp[32] + tmp[33] + tmp[34] + tmp[35]) + tmp[36];
        out[3] = tmp[1]*tmp[2]*tmp[3]*(tmp[4] + tmp[5] + tmp[6] + tmp[7] + tmp[8]*tmp[9]*(tmp[10] + tmp[11])*tmp[12] + tmp[37] + tmp[38]);
        tmp[1] = (6.*M + 4.*Mp)*(L*L) + ((5.*M + 4.*Mp)*cos(2.*q[0]) - 8.*M*cos(q[0])*cos(q[1]) + M*cos(2.*q[1]))*(L*L);
        out[4] = (8.*mu)/tmp[1];
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
        mxFree(tmp);



        
        
        
    } else if (flag == 'i') {
        /* Allocate memory for output */
        tmp = mxCalloc(10, sizeof(double));
        plhs[0] = mxCreateDoubleMatrix(dim, 1, mxREAL);
        if (plhs[0] == NULL) dieHorribly(6);
        out = mxGetPr(plhs[0]);

        /* EDIT FOR EACH MODEL */
        /* Compute impact: */
        out[2] = (-2.*(M + 2.*Mp)*cos(q[0] - q[1])*q[2] + M*q[3])/(-3.*M - 4.*Mp + 2.*M*cos(2.*(q[0] - q[1])));
        tmp[1] = 1/(-3.*M - 4.*Mp + 2.*M*cos(2.*(q[0] - q[1])));
        tmp[2] = (M - 4.*(M + Mp)*cos(2.*(q[0] - q[1])))*q[2] + 2.*M*cos(q[0] - q[1])*q[3];
        out[3] = tmp[1]*tmp[2];
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
        mxFree(tmp);






    } else if (flag == 'g') { 
        /* EDIT FOR EACH MODEL */
        /* Compute guard function: */
        guard = L*(cos(q[0]) - cos(q[1]));
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
