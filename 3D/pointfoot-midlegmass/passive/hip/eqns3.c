
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
    Null
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
        tmp[1] = -2.*(3.*M + 2.*Mp)*(3.*M + 4.*Mp)*(l*l) - 2.*(7.*M*Mp + 2.*(M*M) + 2.*(Mp*Mp))*(w*w);
        tmp[2] = cos(2.*q[1])*(cos(4.*q[2])*(l*l)*(M*M) - 2.*(l*l)*(16.*M*Mp + 7.*(M*M) + 8.*(Mp*Mp)) - 4.*Mp*(2.*M + Mp)*(w*w) + M*cos(2.*q[2])*((7.*M + 4.*Mp)*(l*l) - 4.*(M + 2.*Mp)*(w*w)));
        tmp[3] = 4.*cos(2.*q[2])*((3.*M + 2.*Mp)*(l*l) - Mp*(w*w)) + 8.*(2.*(M + 2.*Mp)*cos(q[2]) - M*cos(3.*q[2]))*(l*l)*pow(cos(q[1]),2.) + 2.*(-((6.*M + 8.*Mp - 4.*M*cos(2.*q[2]) + M*cos(3.*q[2]))*(l*l)) + 2.*(M + 2.*Mp)*cos(q[2])*(l*l + 2.*(w*w)))*sin(2.*q[1])*sin(q[2]);
        tmp[4] = -4.*g*w*cos(q[0])*(M*(M + Mp)*cos(2.*q[2]) + Mp*(3.*M + 2.*Mp + M*cos(2.*(q[1] + q[2]))) + cos(2.*q[1])*(4.*M*Mp + M*M + 2.*(Mp*Mp)));
        tmp[5] = 4.*g*l*(-3.*M - 4.*Mp + 2.*M*cos(2.*q[2]))*((3.*M + 2.*Mp)*cos(q[1]) - M*cos(q[1] + q[2]))*sin(q[0]);
        tmp[6] = 4.*w*(M*(M + 2.*Mp)*cos(q[1])*cos(2.*q[2])*(q[4]*q[4]) + cos(q[1])*(7.*M*Mp + M*M + 4.*(Mp*Mp))*(q[4]*q[4]) - M*(M + 4.*Mp)*cos(q[1])*cos(q[2])*pow(q[4] + q[5],2.) + M*(M + 2.*Mp)*pow(q[4] + q[5],2.)*sin(q[1])*sin(q[2]) - M*(M + 2.*Mp)*(q[4]*q[4])*sin(q[1])*sin(2.*q[2]));
        tmp[7] = q[5]*q[5];
        tmp[8] = cos(q[1])*(-23.*M*Mp + M*(5.*M + 6.*Mp - 2.*Mp*cos(2.*q[1]))*cos(q[2]) + 2.*M*(9.*M + 6.*Mp + (M + 2.*Mp)*cos(2.*q[1]))*cos(2.*q[2]) - M*(3.*M - 2.*Mp + 2.*(M + 3.*Mp)*cos(2.*q[1]))*cos(3.*q[2]) - 21.*(M*M) - 4.*(Mp*Mp)) + cos(3.*q[1])*(7.*M*Mp + M*M + 4.*(Mp*Mp));
        tmp[9] = -4.*M*(M + 2.*Mp)*pow(cos(q[1]),2.)*sin(q[1])*sin(2.*q[2]) + M*sin(q[1])*((-13.*M - 8.*Mp + 2.*Mp*cos(2.*q[1]))*sin(q[2]) + (5.*M + 4.*Mp + 2.*(M + 3.*Mp)*cos(2.*q[1]))*sin(3.*q[2]));
        tmp[10] = 2.*l*q[5]*(-3.*M - 4.*Mp + 2.*M*cos(2.*q[2]))*(q[4]*((5.*M + 4.*Mp)*sin(2.*q[1]) + M*(sin(2.*(q[1] + q[2])) - 4.*sin(2.*q[1] + q[2]))) + M*q[5]*(-2.*sin(q[2]) + sin(2.*(q[1] + q[2])) - 2.*sin(2.*q[1] + q[2])));
        qdotdot[0] = (tmp[4] + tmp[5] + l*(tmp[6] + w*tmp[7]*(tmp[8] + tmp[9]) + tmp[10]))/(tmp[1] + tmp[2] + M*tmp[3]);
        tmp[1] = 0.25/l;
        tmp[2] = cos(2.*q[1])*(-(cos(4.*q[2])*(l*l)*(M*M)) + 2.*(l*l)*(16.*M*Mp + 7.*(M*M) + 8.*(Mp*Mp)) + 4.*Mp*(2.*M + Mp)*(w*w) + M*cos(2.*q[2])*(-((7.*M + 4.*Mp)*(l*l)) + 4.*(M + 2.*Mp)*(w*w)));
        tmp[3] = (3.*M + 2.*Mp)*(3.*M + 4.*Mp)*(l*l) + (7.*M*Mp + 2.*(M*M) + 2.*(Mp*Mp))*(w*w);
        tmp[4] = 2.*M*cos(2.*q[2])*(-((3.*M + 2.*Mp)*(l*l)) + Mp*(w*w)) + 4.*M*(-2.*(M + 2.*Mp)*cos(q[2]) + M*cos(3.*q[2]))*(l*l)*pow(cos(q[1]),2.) + M*((6.*M + 8.*Mp - 4.*M*cos(2.*q[2]) + M*cos(3.*q[2]))*(l*l) - 2.*(M + 2.*Mp)*cos(q[2])*(l*l + 2.*(w*w)))*sin(2.*q[1])*sin(q[2]);
        tmp[5] = cos(q[0]);
        tmp[6] = ((3.*M + 2.*Mp)*(5.*M + 4.*Mp)*(l*l) + 8.*M*(M + Mp)*(w*w) - 2.*M*cos(2.*q[2])*((6.*M + 4.*Mp)*(l*l) - 2.*Mp*(w*w) + cos(2.*q[1])*((3.*M + 2.*Mp)*(l*l) - 4.*(M + Mp)*(w*w))) + 16.*M*(-2.*(M + Mp)*cos(q[2]) + M*cos(3.*q[2]))*(l*l)*pow(cos(q[1]),2.))*sin(q[1]);
        tmp[7] = -(l*l*(-2.*(M + Mp)*(5.*M + 4.*Mp) + cos(4.*q[2])*(M*M))*sin(3.*q[1]));
        tmp[8] = 4.*cos(q[1])*((7.*M + 4.*Mp + 2.*M*cos(2.*q[2]))*(l*l) - 2.*cos(q[2])*((4.*M + 3.*Mp)*(l*l) + (2.*M + Mp)*(w*w)) + cos(2.*q[1])*(-4.*(M + Mp)*(l*l) + cos(q[2])*(-((3.*M + 2.*Mp)*(l*l)) + 4.*(M + Mp)*(w*w))))*sin(q[2]);
        tmp[9] = -(M*cos(3.*q[1])*(l*l)*(-4.*sin(3.*q[2]) + sin(4.*q[2])));
        tmp[10] = 4.*l*w*sin(q[0])*((M + Mp)*(3.*M + 2.*Mp)*sin(2.*q[1]) + M*((2.*M + Mp)*sin(q[2]) - (3.*M + 2.*Mp)*sin(2.*q[2]) - 3.*M*sin(2.*(q[1] + q[2])) - 2.*Mp*sin(2.*(q[1] + q[2])) - M*sin(2.*q[1] + q[2]) - Mp*sin(2.*q[1] + q[2]) + M*sin(2.*q[1] + 3.*q[2])));
        tmp[11] = q[5]*q[5];
        tmp[12] = l*l*(36.*M*Mp + 25.*(M*M) + 16.*(Mp*Mp));
        tmp[13] = 2.*(15.*M*Mp + 10.*(M*M) + 4.*(Mp*Mp))*(w*w);
        tmp[14] = -3.*M*cos(4.*q[2])*(l*l) + cos(q[2])*(-((19.*M + 20.*Mp)*(l*l)) - (17.*M + 20.*Mp)*cos(2.*q[1])*(l*l) - 4.*(2.*M + Mp)*(w*w));
        tmp[15] = cos(3.*q[2])*((15.*M + 4.*Mp)*(l*l) + 8.*M*(w*w) + 4.*cos(2.*q[1])*((3.*M + Mp)*(l*l) + Mp*(w*w))) - cos(2.*q[2])*(8.*(2.*M + Mp)*(l*l) + 4.*(4.*M + Mp)*(w*w) + cos(2.*q[1])*((3.*M + 4.*Mp)*(l*l) - 4.*(M + 2.*Mp)*(w*w)));
        tmp[16] = sin(2.*q[1]);
        tmp[17] = l*l*((3.*M + 4.*Mp)*(5.*M + 4.*Mp) + (-6.*cos(4.*q[2]) + cos(5.*q[2]))*(M*M))*sin(4.*q[1]);
        tmp[18] = 2.*M;
        tmp[19] = (31.*M + 16.*Mp)*(l*l) + (13.*M + 4.*Mp)*cos(2.*q[2])*(l*l) + 2.*(8.*M + 3.*Mp)*(w*w);
        tmp[20] = cos(4.*q[1])*(-2.*(M + 4.*Mp)*(l*l) + M*cos(4.*q[2])*(l*l) + 2.*Mp*(w*w) + cos(2.*q[2])*((13.*M + 4.*Mp)*(l*l) + 4.*Mp*(w*w))) + 12.*M*cos(3.*q[2])*(l*l)*pow(cos(q[1]),2.);
        tmp[21] = -16.*(5.*M + 3.*Mp)*cos(q[2])*(l*l + w*w)*pow(cos(q[1]),2.);
        tmp[22] = 2.*cos(2.*q[1])*((13.*M + 4.*Mp)*(l*l) - 2.*Mp*(w*w) + cos(2.*q[2])*((15.*M + 4.*Mp)*(l*l) + 8.*M*(w*w)) - 2.*cos(q[2])*((3.*M + 4.*Mp)*(l*l) + 12.*M*cos(2.*q[2])*(l*l) - 4.*(M + 2.*Mp)*(w*w))*pow(cos(q[1]),2.));
        tmp[23] = sin(q[2]);
        tmp[24] = 16.*l*w*q[5]*(q[4]*((5.*M + 4.*Mp)*sin(2.*q[1]) + M*(sin(2.*(q[1] + q[2])) - 4.*sin(2.*q[1] + q[2]))) + M*q[5]*(-2.*sin(q[2]) + sin(2.*(q[1] + q[2])) - 2.*sin(2.*q[1] + q[2])))*((M + Mp)*sin(q[1]) - M*sin(q[1] + 2.*q[2]));
        tmp[25] = q[4]*q[4];
        tmp[26] = (5.*(l*l)*(M*M) - (4.*cos(2.*q[2]) - 5.*cos(3.*q[2]) + cos(4.*q[2]))*(l*l)*(M*M) - 4.*Mp*(2.*M + Mp)*(w*w) - M*cos(q[2])*(5.*M*(l*l) - 4.*Mp*(w*w)))*sin(2.*q[1]);
        tmp[27] = 2.*M*(2.*(5.*M + 2.*Mp + 2.*M*cos(2.*q[2]))*(l*l) + 4.*cos(q[2])*(-2.*(2.*M + Mp)*(l*l) + Mp*(w*w)) + cos(2.*q[1])*((9.*M + 4.*Mp)*(l*l) - ((15.*M + 8.*Mp)*cos(q[2]) + M*(-5.*cos(2.*q[2]) + cos(3.*q[2])))*(l*l) + 2.*Mp*(w*w)))*sin(q[2]);
        tmp[28] = 2.*M*q[4]*q[5]*(4.*M*(l*l)*sin(2.*q[1]) - (5.*M + 4.*Mp)*(l*l)*sin(2.*q[1] - q[2]) + 4.*((M + Mp)*(l*l) + Mp*(w*w))*sin(2.*q[1] + q[2]) + 4.*(l*l)*((3.*M + 2.*Mp)*sin(q[2]) - 2.*M*cos(q[1])*sin(q[1] + 2.*q[2])) + M*(l*l)*sin(2.*q[1] + 3.*q[2]));
        tmp[29] = M*(q[5]*q[5])*(4.*M*(l*l)*sin(2.*q[1]) - (5.*M + 4.*Mp)*(l*l)*sin(2.*q[1] - q[2]) + 4.*((M + Mp)*(l*l) + Mp*(w*w))*sin(2.*q[1] + q[2]) + 4.*(l*l)*((3.*M + 2.*Mp)*sin(q[2]) - 2.*M*cos(q[1])*sin(q[1] + 2.*q[2])) + M*(l*l)*sin(2.*q[1] + 3.*q[2]));
        tmp[30] = 1/(tmp[2] + 2.*(tmp[3] + tmp[4]));
        tmp[31] = -4.*g*(-(tmp[5]*(tmp[6] + tmp[7] + M*(tmp[8] + tmp[9]))) + tmp[10]) - l*(tmp[11]*(2.*(tmp[12] + tmp[13] + M*(tmp[14] + tmp[15]))*tmp[16] + tmp[17] + tmp[18]*(tmp[19] + tmp[20] + tmp[21] + tmp[22])*tmp[23]) + tmp[24] + 4.*(tmp[25]*(tmp[26] + tmp[27]) + tmp[28] + tmp[29]));
        qdotdot[1] = tmp[1]*tmp[30]*tmp[31];
        tmp[1] = 0.25/l;
        tmp[2] = cos(2.*q[1])*(-(cos(4.*q[2])*(l*l)*(M*M)) + 2.*(l*l)*(16.*M*Mp + 7.*(M*M) + 8.*(Mp*Mp)) + 4.*Mp*(2.*M + Mp)*(w*w) + M*cos(2.*q[2])*(-((7.*M + 4.*Mp)*(l*l)) + 4.*(M + 2.*Mp)*(w*w)));
        tmp[3] = (3.*M + 2.*Mp)*(3.*M + 4.*Mp)*(l*l) + (7.*M*Mp + 2.*(M*M) + 2.*(Mp*Mp))*(w*w);
        tmp[4] = 2.*M*cos(2.*q[2])*(-((3.*M + 2.*Mp)*(l*l)) + Mp*(w*w)) + 4.*M*(-2.*(M + 2.*Mp)*cos(q[2]) + M*cos(3.*q[2]))*(l*l)*pow(cos(q[1]),2.) + M*((6.*M + 8.*Mp - 4.*M*cos(2.*q[2]) + M*cos(3.*q[2]))*(l*l) - 2.*(M + 2.*Mp)*cos(q[2])*(l*l + 2.*(w*w)))*sin(2.*q[1])*sin(q[2]);
        tmp[5] = 4.*l;
        tmp[6] = sin(q[0]);
        tmp[7] = (6.*M*Mp - M*(6.*M + 5.*Mp)*cos(2.*q[2]) + 5.*(M*M) + cos(3.*q[2])*(M*M) + 2.*(Mp*Mp) + cos(q[2])*(7.*M*Mp + 2.*(M*M) + 4.*(Mp*Mp)))*sin(2.*q[1]);
        tmp[8] = (23.*M*Mp - 2.*M*(5.*M + 3.*Mp)*cos(q[2]) + 17.*(M*M) + 8.*(Mp*Mp) + cos(2.*q[1])*(21.*M*Mp - 2.*M*(6.*M + 5.*Mp)*cos(q[2]) + 15.*(M*M) + 2.*cos(2.*q[2])*(M*M) + 8.*(Mp*Mp)))*sin(q[2]);
        tmp[9] = cos(q[0]);
        tmp[10] = -((3.*M + 2.*Mp)*(9.*M + 4.*Mp)*(l*l)) - M*(7.*M + 2.*Mp)*cos(3.*q[2])*(l*l) - 8.*M*(M + Mp)*(w*w) + M*cos(2.*q[2])*((17.*M + 14.*Mp)*(l*l) + 4.*M*(w*w)) + cos(q[2])*(M*(17.*M + 14.*Mp)*(l*l) + 4.*(2.*M*Mp + 2.*(M*M) + Mp*Mp)*(w*w));
        tmp[11] = sin(q[1]);
        tmp[12] = (-(l*l*(26.*M*Mp + 2.*M*(3.*M + Mp)*cos(3.*q[2]) + 22.*(M*M) - cos(4.*q[2])*(M*M) + 8.*(Mp*Mp))) + M*cos(2.*q[2])*((11.*M + 10.*Mp)*(l*l) - 4.*(M + Mp)*(w*w)) + 2.*cos(q[2])*(M*(8.*M + 7.*Mp)*(l*l) + 2.*(M + Mp)*(2.*M + Mp)*(w*w)))*sin(3.*q[1]);
        tmp[13] = -(cos(q[1])*(l*l*(104.*M*Mp + 85.*(M*M) + 32.*(Mp*Mp)) + 4.*(M*Mp + 4.*(M*M) - 2.*(Mp*Mp))*(w*w) + 4.*(M + Mp)*cos(2.*q[1])*((7.*M + 8.*Mp)*(l*l) - 2.*(2.*M + Mp)*(w*w)))*sin(q[2]));
        tmp[14] = 2.*M*cos(q[1])*(2.*(10.*M + 7.*Mp)*(l*l) + 2.*(2.*M + Mp)*(w*w) + cos(2.*q[1])*((11.*M + 10.*Mp)*(l*l) - 4.*(M + Mp)*(w*w)))*sin(2.*q[2]) - M*cos(q[1])*(M + 4.*(3.*M + Mp)*cos(2.*q[1]))*(l*l)*sin(3.*q[2]) + cos(3.*q[1])*(l*l)*(M*M)*sin(4.*q[2]);
        tmp[15] = q[5]*q[5];
        tmp[16] = -(M*(4.*M + (9.*M + 4.*Mp)*cos(2.*q[1]))*cos(4.*q[2])*(l*l)) + 2.*(l*l)*(30.*M*Mp + 29.*(M*M) + 8.*(Mp*Mp)) + 2.*(2.*M + Mp)*(9.*M + 4.*Mp)*(w*w);
        tmp[17] = M*cos(3.*q[2])*(2.*(15.*M + 8.*Mp)*(l*l) + 8.*M*(w*w) + cos(2.*q[1])*((29.*M + 24.*Mp)*(l*l) + 4.*Mp*(w*w)));
        tmp[18] = -2.*cos(2.*q[2])*((3.*M + 2.*Mp)*(9.*M + 4.*Mp)*(l*l) + (17.*M*Mp + 20.*(M*M) + 2.*(Mp*Mp))*(w*w) + 2.*(M + Mp)*cos(2.*q[1])*((9.*M + 4.*Mp)*(l*l) + (-M + Mp)*(w*w)));
        tmp[19] = -2.*cos(q[2])*(M*(15.*M + 8.*Mp)*(l*l) - 4.*Mp*(2.*M + Mp)*(w*w) + cos(2.*q[1])*(3.*M*(5.*M + 4.*Mp)*(l*l) + 2.*(2.*M + Mp)*(M + 2.*Mp)*(w*w)));
        tmp[20] = sin(2.*q[1]);
        tmp[21] = l*l*((5.*M + 4.*Mp)*(9.*M + 4.*Mp) + cos(5.*q[2])*(M*M))*sin(4.*q[1]);
        tmp[22] = 2.*M*(13.*M + 4.*Mp)*cos(2.*q[2])*(l*l) + 2.*(l*l)*(76.*M*Mp + 67.*(M*M) + 24.*(Mp*Mp)) + 20.*(5.*M*Mp + 5.*(M*M) + Mp*Mp)*(w*w);
        tmp[23] = -2.*cos(q[2])*((3.*M + 2.*Mp)*(25.*M + 4.*Mp)*(l*l) + 2.*(8.*M*Mp + 17.*(M*M) + Mp*Mp)*(w*w));
        tmp[24] = cos(2.*q[1]);
        tmp[25] = l*l*(48.*M*Mp + 39.*(M*M) + 16.*(Mp*Mp)) + 4.*(5.*M*Mp + 5.*(M*M) + Mp*Mp)*(w*w);
        tmp[26] = -(cos(q[2])*(l*l*(46.*M*Mp + 49.*(M*M) + 8.*(Mp*Mp)) + (17.*M*Mp + 20.*(M*M) + 2.*(Mp*Mp))*(w*w))) + M*(-2.*M*cos(3.*q[2])*(l*l) + cos(2.*q[2])*((15.*M + 8.*Mp)*(l*l) + 4.*M*(w*w)));
        tmp[27] = cos(4.*q[1]);
        tmp[28] = -(cos(q[2])*((5.*M + 4.*Mp)*(9.*M + 4.*Mp)*(l*l) + 4.*(-(M*M) + Mp*Mp)*(w*w))) + M*(((-9.*M - 4.*Mp)*cos(3.*q[2]) + M*cos(4.*q[2]))*(l*l) + cos(2.*q[2])*(6.*(5.*M + 4.*Mp)*(l*l) + 4.*Mp*(w*w)));
        tmp[29] = -4.*(w*w)*pow(M + Mp,2.) + l*l*pow(5.*M + 4.*Mp,2.);
        tmp[30] = sin(q[2]);
        tmp[31] = 2.*M;
        tmp[32] = (M*(5. + 5.*cos(3.*q[2]) - cos(4.*q[2]))*(l*l) + cos(q[2])*(-5.*M*(l*l) + 4.*Mp*(w*w)) + cos(2.*q[2])*(-4.*M*(l*l) + 4.*(M + 2.*Mp)*(w*w)))*sin(2.*q[1]);
        tmp[33] = 2.*(5.*M + 2.*Mp + 2.*M*cos(2.*q[2]))*(l*l);
        tmp[34] = 4.*cos(q[2])*(-2.*(2.*M + Mp)*(l*l) + Mp*(w*w)) + cos(2.*q[1])*((9.*M + 4.*Mp)*(l*l) - M*(-5.*cos(2.*q[2]) + cos(3.*q[2]))*(l*l) + 2.*Mp*(w*w) + cos(q[2])*(-((15.*M + 8.*Mp)*(l*l)) + 4.*(M + 2.*Mp)*(w*w)));
        tmp[35] = sin(q[2]);
        tmp[36] = q[5]*q[5];
        tmp[37] = (M*(5. + 5.*cos(3.*q[2]) - cos(4.*q[2]))*(l*l) + cos(q[2])*(-5.*M*(l*l) + 4.*Mp*(w*w)) + cos(2.*q[2])*(-4.*M*(l*l) + 4.*(M + 2.*Mp)*(w*w)))*sin(2.*q[1]);
        tmp[38] = 2.*(5.*M + 2.*Mp + 2.*M*cos(2.*q[2]))*(l*l);
        tmp[39] = 4.*cos(q[2])*(-2.*(2.*M + Mp)*(l*l) + Mp*(w*w)) + cos(2.*q[1])*((9.*M + 4.*Mp)*(l*l) - M*(-5.*cos(2.*q[2]) + cos(3.*q[2]))*(l*l) + 2.*Mp*(w*w) + cos(q[2])*(-((15.*M + 8.*Mp)*(l*l)) + 4.*(M + 2.*Mp)*(w*w)));
        tmp[40] = sin(q[2]);
        tmp[41] = q[4]*q[4];
        tmp[42] = M*(13.*M + 8.*Mp)*(l*l) - M*((-7.*M - 2.*Mp)*cos(3.*q[2]) + M*cos(4.*q[2]))*(l*l) - 2.*Mp*(2.*M + Mp)*(w*w) - 2.*M*cos(2.*q[2])*((6.*M + 4.*Mp)*(l*l) - (M + 2.*Mp)*(w*w)) - cos(q[2])*(M*(7.*M + 2.*Mp)*(l*l) + 4.*(w*w)*pow(M + Mp,2.));
        tmp[43] = sin(2.*q[1]);
        tmp[44] = l*l*(24.*M*Mp + 22.*(M*M) + 8.*(Mp*Mp)) + 2.*(M - Mp)*(M + Mp)*(w*w);
        tmp[45] = 4.*M*(M*cos(2.*q[2])*(l*l) + cos(q[2])*(-2.*(3.*M + 2.*Mp)*(l*l) + Mp*(w*w)));
        tmp[46] = cos(2.*q[1])*(M*((7.*M + 2.*Mp)*cos(2.*q[2]) - M*cos(3.*q[2]))*(l*l) + l*l*(22.*M*Mp + 19.*(M*M) + 8.*(Mp*Mp)) + M*cos(q[2])*(-((23.*M + 16.*Mp)*(l*l)) + 2.*(M + 2.*Mp)*(w*w)) - 2.*(w*w)*pow(M + Mp,2.));
        tmp[47] = sin(q[2]);
        tmp[48] = 16.*l*w*q[5]*((M + Mp + (M + 2.*Mp)*cos(q[2]) - M*cos(2.*q[2]))*sin(q[1]) + cos(q[1])*(5.*M + 4.*Mp - 2.*M*cos(q[2]))*sin(q[2]))*(q[4]*((5.*M + 4.*Mp)*sin(2.*q[1]) + M*(sin(2.*(q[1] + q[2])) - 4.*sin(2.*q[1] + q[2]))) + M*q[5]*(-2.*sin(q[2]) + sin(2.*(q[1] + q[2])) - 2.*sin(2.*q[1] + q[2])));
        tmp[49] = tmp[15]*(2.*(tmp[16] + tmp[17] + tmp[18] + tmp[19])*tmp[20] + tmp[21] + 2.*(tmp[22] + tmp[23] + 4.*tmp[24]*(tmp[25] + tmp[26]) + tmp[27]*(tmp[28] + tmp[29]))*tmp[30]);
        tmp[50] = 4.*(q[4]*q[5]*tmp[31]*(tmp[32] + 2.*(tmp[33] + tmp[34])*tmp[35]) + M*tmp[36]*(tmp[37] + 2.*(tmp[38] + tmp[39])*tmp[40]) + 2.*tmp[41]*(tmp[42]*tmp[43] + 2.*(tmp[44] + tmp[45] + tmp[46])*tmp[47])) + tmp[48];
        qdotdot[2] = (tmp[1]*(4.*g*(w*tmp[5]*tmp[6]*(tmp[7] + tmp[8]) + tmp[9]*(tmp[10]*tmp[11] + tmp[12] + tmp[13] + tmp[14])) + l*(tmp[49] + tmp[50])))/(tmp[2] + 2.*(tmp[3] + tmp[4]));
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
        tmp[1] = cos(2.*q[1])*(cos(2.*q[2])*(l*l*(32.*M*Mp + 13.*(M*M) + 16.*(Mp*Mp)) + 4.*Mp*(2.*M + Mp)*(w*w)) + M*(-2.*M*(l*l) - (5.*M + 4.*Mp)*cos(4.*q[2])*(l*l) + 4.*(M + 2.*Mp)*(w*w)));
        tmp[2] = (3.*M + 2.*Mp)*(3.*M + 4.*Mp)*(l*l) + (7.*M*Mp + 2.*(M*M) + 2.*(Mp*Mp))*(w*w);
        tmp[3] = 2.*M*cos(2.*q[2])*(-((3.*M + 2.*Mp)*(l*l)) + Mp*(w*w));
        tmp[4] = 4.*M*(-2.*(M + 2.*Mp)*cos(q[2]) + M*cos(3.*q[2]))*(l*l)*pow(cos(q[1]),2.) + (M*(6.*M + 8.*Mp - 4.*M*cos(2.*q[2]) + (5.*M + 4.*Mp)*cos(3.*q[2]))*(l*l) - 2.*cos(q[2])*((M + 2.*Mp)*(5.*M + 4.*Mp)*(l*l) + 2.*Mp*(2.*M + Mp)*(w*w)))*sin(2.*q[1])*sin(q[2]);
        tmp[5] = cos(2.*q[1])*(-(M*(-2.*(M + 2.*Mp)*(l*l) + M*cos(4.*q[2])*(l*l) + 4.*(M + Mp)*(w*w))) + cos(2.*q[2])*(M*(M + 4.*Mp)*(l*l) + 4.*(w*w)*pow(M + Mp,2.)));
        tmp[6] = M*(3.*M + 4.*Mp)*(l*l) - (M*Mp + 2.*(M*M) - 2.*(Mp*Mp))*(w*w);
        tmp[7] = 2.*cos(2.*q[2])*(M*M)*(-(l*l) + w*w);
        tmp[8] = 4.*(M + Mp)*cos(q[2])*(-3.*M - 4.*Mp + 2.*M*cos(2.*q[2]))*(l*l)*pow(cos(q[1]),2.) + (l*l*(-2.*(M + Mp)*(-3.*M - 4.*Mp + 2.*M*cos(2.*q[2])) + cos(3.*q[2])*(M*M)) - 2.*cos(q[2])*(M*(M + 2.*Mp)*(l*l) + 2.*(w*w)*pow(M + Mp,2.)))*sin(2.*q[1])*sin(q[2]);
        tmp[9] = -4.*l*w*(q[4]*(2.*Mp*(5.*M + 4.*Mp + (6.*M + 4.*Mp)*cos(q[2]))*pow(sin(0.5*q[2]),2.)*sin(q[1]) - (2.*M + Mp)*cos(q[1])*(-M + 2.*(M + 2.*Mp)*cos(q[2]))*sin(q[2])) + M*q[5]*(2.*M*cos(q[1])*sin(q[2]) + Mp*sin(q[1] + q[2])));
        qnew[0] = (-(q[5]*(tmp[5] + 2.*(tmp[6] + tmp[7] + tmp[8]))) + tmp[9])/(tmp[1] + 2.*(tmp[2] + tmp[3] + tmp[4]));
        tmp[1] = 1/l;
        tmp[2] = cos(2.*q[1])*(cos(2.*q[2])*(l*l*(32.*M*Mp + 13.*(M*M) + 16.*(Mp*Mp)) + 4.*Mp*(2.*M + Mp)*(w*w)) + M*(-2.*M*(l*l) - (5.*M + 4.*Mp)*cos(4.*q[2])*(l*l) + 4.*(M + 2.*Mp)*(w*w)));
        tmp[3] = (3.*M + 2.*Mp)*(3.*M + 4.*Mp)*(l*l) + (7.*M*Mp + 2.*(M*M) + 2.*(Mp*Mp))*(w*w);
        tmp[4] = 2.*M*cos(2.*q[2])*(-((3.*M + 2.*Mp)*(l*l)) + Mp*(w*w));
        tmp[5] = 4.*M*(-2.*(M + 2.*Mp)*cos(q[2]) + M*cos(3.*q[2]))*(l*l)*pow(cos(q[1]),2.) + (M*(6.*M + 8.*Mp - 4.*M*cos(2.*q[2]) + (5.*M + 4.*Mp)*cos(3.*q[2]))*(l*l) - 2.*cos(q[2])*((M + 2.*Mp)*(5.*M + 4.*Mp)*(l*l) + 2.*Mp*(2.*M + Mp)*(w*w)))*sin(2.*q[1])*sin(q[2]);
        tmp[6] = -4.*M*(l*l) - 4.*M*cos(2.*q[1])*(l*l) + M*cos(2.*q[1] - q[2])*(l*l) + 12.*M*cos(q[2])*(l*l) + 8.*Mp*cos(q[2])*(l*l);
        tmp[7] = -4.*M*cos(2.*q[2])*(l*l) - 4.*M*cos(2.*(q[1] + q[2]))*(l*l) + (5.*M + 4.*Mp)*cos(2.*q[1] + 3.*q[2])*(l*l) + 8.*M*cos(q[2])*(w*w) + 2.*cos(2.*q[1] + q[2])*((3.*M + 2.*Mp)*(l*l) + 2.*(2.*M + Mp)*(w*w));
        tmp[8] = 2.*M*(M + 2.*Mp)*(l*l) + 8.*M*(M + Mp)*cos(3.*q[2])*(l*l) - 2.*(7.*M*Mp + 2.*(M*M) + 4.*(Mp*Mp))*(w*w);
        tmp[9] = 8.*M*cos(q[2])*(2.*(M + Mp)*(l*l) + M*(w*w)) - 4.*cos(2.*q[2])*(l*l*(10.*M*Mp + 7.*(M*M) + 4.*(Mp*Mp)) + (2.*M - Mp)*(M + Mp)*(w*w));
        tmp[10] = cos(2.*q[1]);
        tmp[11] = (M*(13.*M + 12.*Mp)*cos(3.*q[2]) - 2.*(M + Mp)*(5.*M + 4.*Mp)*cos(4.*q[2]))*(l*l) - l*l*(18.*M*Mp + 13.*(M*M) + 8.*(Mp*Mp));
        tmp[12] = -4.*(M - Mp)*(M + Mp)*(w*w) + M*cos(q[2])*((11.*M + 12.*Mp)*(l*l) + 4.*(2.*M + Mp)*(w*w)) - cos(2.*q[2])*(3.*(l*l)*(M*M) + 4.*(2.*M + Mp)*(M + 2.*Mp)*(w*w));
        tmp[13] = 2.*(-(M*(3.*M + 4.*Mp)*(l*l)) + (-(M*(13.*M + 12.*Mp)*cos(2.*q[2])) + 2.*(M + Mp)*(5.*M + 4.*Mp)*cos(3.*q[2]))*(l*l) - 2.*M*(2.*M + Mp)*(w*w) + cos(q[2])*(l*l*(14.*M*Mp + 9.*(M*M) + 8.*(Mp*Mp)) + 4.*(2.*M + Mp)*(M + 2.*Mp)*(w*w)));
        tmp[14] = sin(2.*q[1])*sin(q[2]);
        tmp[15] = -w;
        tmp[16] = -(l*l*(20.*M*Mp + 17.*(M*M) + 4.*(Mp*Mp))) - 8.*Mp*(M + Mp)*(w*w);
        tmp[17] = -2.*cos(2.*q[2])*(2.*(l*l)*(4.*M*Mp + M*M + 2.*(Mp*Mp)) + 2.*M*(4.*M + 3.*Mp)*(w*w) + cos(2.*q[1])*(l*l*(12.*M*Mp + 7.*(M*M) + 4.*(Mp*Mp)) + 4.*(M + Mp)*(2.*M + Mp)*(w*w)));
        tmp[18] = 16.*(M + Mp)*((4.*M + 3.*Mp)*cos(q[2]) - (M + Mp)*cos(3.*q[2]))*(l*l)*pow(cos(q[1]),2.);
        tmp[19] = sin(q[1]);
        tmp[20] = -((4.*M*(M + Mp) + (M + 2.*Mp)*(3.*M + 2.*Mp)*cos(4.*q[2]))*(l*l)*sin(3.*q[1])) + 8.*(M + Mp)*cos(q[1])*(-5.*M - 4.*Mp + (4.*M + 3.*Mp)*cos(2.*q[1]))*(l*l)*sin(q[2]);
        tmp[21] = -2.*cos(q[1])*(-2.*(3.*M + 2.*Mp)*(M*(l*l) + Mp*(w*w)) + cos(2.*q[1])*(l*l*(12.*M*Mp + 7.*(M*M) + 4.*(Mp*Mp)) + 4.*(M + Mp)*(2.*M + Mp)*(w*w)))*sin(2.*q[2]);
        tmp[22] = -4.*(cos(q[1]) + cos(3.*q[1]))*(l*l)*pow(M + Mp,2.)*sin(3.*q[2]) - (M + 2.*Mp)*(3.*M + 2.*Mp)*cos(3.*q[1])*(l*l)*sin(4.*q[2]);
        qnew[1] = (tmp[1]*(-(l*(M*q[5]*(tmp[6] + tmp[7]) + q[4]*(tmp[8] + tmp[9] + tmp[10]*(tmp[11] + tmp[12]) + tmp[13]*tmp[14]))) + q[5]*tmp[15]*((tmp[16] + tmp[17] + tmp[18])*tmp[19] + tmp[20] + tmp[21] + tmp[22])))/(tmp[2] + 2.*(tmp[3] + tmp[4] + tmp[5]));
        tmp[1] = 1/l;
        tmp[2] = cos(2.*q[1])*(cos(2.*q[2])*(l*l*(32.*M*Mp + 13.*(M*M) + 16.*(Mp*Mp)) + 4.*Mp*(2.*M + Mp)*(w*w)) + M*(-2.*M*(l*l) - (5.*M + 4.*Mp)*cos(4.*q[2])*(l*l) + 4.*(M + 2.*Mp)*(w*w)));
        tmp[3] = (3.*M + 2.*Mp)*(3.*M + 4.*Mp)*(l*l) + (7.*M*Mp + 2.*(M*M) + 2.*(Mp*Mp))*(w*w);
        tmp[4] = 2.*M*cos(2.*q[2])*(-((3.*M + 2.*Mp)*(l*l)) + Mp*(w*w));
        tmp[5] = 4.*M*(-2.*(M + 2.*Mp)*cos(q[2]) + M*cos(3.*q[2]))*(l*l)*pow(cos(q[1]),2.) + (M*(6.*M + 8.*Mp - 4.*M*cos(2.*q[2]) + (5.*M + 4.*Mp)*cos(3.*q[2]))*(l*l) - 2.*cos(q[2])*((M + 2.*Mp)*(5.*M + 4.*Mp)*(l*l) + 2.*Mp*(2.*M + Mp)*(w*w)))*sin(2.*q[1])*sin(q[2]);
        tmp[6] = 2.*(5.*M + 2.*Mp)*(l*l) - M*cos(2.*q[1] - q[2])*(l*l) - 16.*M*cos(q[2])*(l*l) - 8.*Mp*cos(q[2])*(l*l) + 4.*M*cos(2.*q[2])*(l*l) + 9.*M*cos(2.*(q[1] + q[2]))*(l*l) + 4.*Mp*cos(2.*(q[1] + q[2]))*(l*l);
        tmp[7] = -10.*M*cos(2.*q[1] + q[2])*(l*l) - 4.*Mp*cos(2.*q[1] + q[2])*(l*l) - (5.*M + 4.*Mp)*cos(2.*q[1] + 3.*q[2])*(l*l) + 2.*(2.*M + Mp)*(w*w) - 8.*M*cos(q[2])*(w*w) - 8.*M*cos(2.*q[1] + q[2])*(w*w) - 4.*Mp*cos(2.*q[1] + q[2])*(w*w) + M*cos(2.*q[1])*(5.*(l*l) + 4.*(w*w));
        tmp[8] = (-M - Mp)*(2.*(M + 2.*Mp)*(l*l) - 4.*M*cos(2.*q[2])*(l*l) - 3.*Mp*(w*w) + cos(q[2])*(8.*(M + Mp)*(l*l) + 2.*(2.*M - Mp)*(w*w)));
        tmp[9] = -(cos(2.*q[1])*(-3.*M*(M + Mp)*(l*l) + (M + Mp)*((M + 4.*Mp)*cos(2.*q[2]) + (5.*M + 4.*Mp)*cos(3.*q[2]))*(l*l) + Mp*(5.*M + 3.*Mp)*(w*w) + cos(q[2])*((M + Mp)*(3.*M + 4.*Mp)*(l*l) + 2.*(2.*M + Mp)*(M + 2.*Mp)*(w*w))));
        tmp[10] = pow(sin(0.5*q[2]),2.);
        tmp[11] = ((M + Mp)*((5.*M + 4.*Mp)*(l*l) + ((9.*M + 4.*Mp)*cos(2.*q[2]) - (5.*M + 4.*Mp)*cos(3.*q[2]))*(l*l) + (2.*M + Mp)*(w*w)) + cos(q[2])*(-((M + Mp)*(9.*M + 4.*Mp)*(l*l)) - 2.*(2.*M + Mp)*(M + 2.*Mp)*(w*w)))*sin(2.*q[1])*sin(q[2]);
        tmp[12] = -w;
        tmp[13] = (l*l*(24.*M*Mp + 21.*(M*M) + 4.*(Mp*Mp)) + 8.*Mp*(M + Mp)*(w*w))*sin(q[1]) + 8.*M*(M + Mp)*(l*l)*sin(3.*q[1]) + 4.*M*Mp*(l*l)*sin(q[1] - 2.*q[2]);
        tmp[14] = 5.*(l*l)*(M*M)*sin(q[1] - 2.*q[2]) - 36.*M*Mp*(l*l)*sin(q[1] - q[2]) - 24.*(l*l)*(M*M)*sin(q[1] - q[2]) - 16.*(l*l)*(Mp*Mp)*sin(q[1] - q[2]);
        tmp[15] = 4.*(M*M)*(w*w)*sin(q[1] - q[2]) - l*l*(M*M)*sin(3.*q[1] - q[2]) + l*l*(M*M)*sin(q[1] + q[2]) - 8.*M*Mp*(w*w)*sin(q[1] + q[2]) - 8.*(M*M)*(w*w)*sin(q[1] + q[2]) - 28.*M*Mp*(l*l)*sin(3.*q[1] + q[2]) - 17.*(l*l)*(M*M)*sin(3.*q[1] + q[2]) - 12.*(l*l)*(Mp*Mp)*sin(3.*q[1] + q[2]);
        tmp[16] = -4.*M*Mp*(w*w)*sin(3.*q[1] + q[2]) - 4.*(M*M)*(w*w)*sin(3.*q[1] + q[2]) - 4.*M*Mp*(l*l)*sin(q[1] + 2.*q[2]) - 8.*(l*l)*(M*M)*sin(q[1] + 2.*q[2]) + 8.*(M*M)*(w*w)*sin(q[1] + 2.*q[2]) - 4.*(Mp*Mp)*(w*w)*sin(q[1] + 2.*q[2]) + 8.*M*Mp*(l*l)*sin(3.*q[1] + 2.*q[2]);
        tmp[17] = 7.*(l*l)*(M*M)*sin(3.*q[1] + 2.*q[2]) + 12.*M*Mp*(w*w)*sin(3.*q[1] + 2.*q[2]) + 8.*(M*M)*(w*w)*sin(3.*q[1] + 2.*q[2]) + 4.*(Mp*Mp)*(w*w)*sin(3.*q[1] + 2.*q[2]);
        tmp[18] = 8.*M*Mp*(l*l)*sin(q[1] + 3.*q[2]) + 5.*(l*l)*(M*M)*sin(q[1] + 3.*q[2]) + 4.*(l*l)*(Mp*Mp)*sin(q[1] + 3.*q[2]) + (M + 2.*Mp)*(3.*M + 2.*Mp)*(l*l)*sin(3.*q[1] + 4.*q[2]);
        qnew[2] = (tmp[1]*(-(l*(M*q[5]*(tmp[6] + tmp[7]) + 4.*q[4]*(2.*(tmp[8] + tmp[9])*tmp[10] + tmp[11]))) + q[5]*tmp[12]*(tmp[13] + tmp[14] + tmp[15] + tmp[16] + tmp[17] + tmp[18])))/(tmp[2] + 2.*(tmp[3] + tmp[4] + tmp[5]));
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
        guard = -(w*sin(q[0])) + 2.*l*cos(q[0])*sin(q[1] + 0.5*q[2])*sin(0.5*q[2]) + l*(-sin(q[1]) + sin(q[1] + q[2]))*tan(slope);
    /* End guard function. */
        plhs[0] = mxCreateScalarDouble(guard);
        if (plhs[0] == NULL) dieHorribly(-1);
    }
}
