
    M = mxGetData(params[0]);
    Mp = mxGetData(
    M_ptr = mexGetVariablePtr("global", "M"); 
    Mp_ptr = mexGetVariablePtr("global", "Mp"); 
    g_ptr = mexGetVariablePtr("global", "g"); 
    l_ptr = mexGetVariablePtr("global", "l"); 
    slope_ptr = mexGetVariablePtr("global", "slope");
    w_ptr = mexGetVariablePtr("global", "w");

    if (M_ptr == NULL || Mp_ptr == NULL || g_ptr == NULL || l_ptr == NULL || slope_ptr == NULL || w_ptr == NULL) {
        mexErrMsgTxt("The global workspace must contain the variables M, Mp, g, L and slope.");
    } else {    
        M = mxGetScalar(M_ptr);
        Mp = mxGetScalar(Mp_ptr);
        g = mxGetScalar(g_ptr);
        l = mxGetScalar(l_ptr);
        slope = mxGetScalar(slope_ptr);
        w = mxGetScalar(w_ptr);
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
/* ********************************************************************* */
<* Assign[{x5dotnew, x6dotnew, x7dotnew}, {x5dotimpact, x6dotimpact, x7dotimpact}, CForm, AssignToArray -> {}, AssignEnd->";", AssignIndex->0, AssignIndent->"        ", AssignBreak->False] *>
/* ********************************************************************* */        
        x5dot = x5dotnew;
        x6dot = x6dotnew;
        x7dot = x7dotnew;
        mxGetPr(plhs[0])[0] = x5;
        mxGetPr(plhs[0])[1] = x6+x7;
        mxGetPr(plhs[0])[2] = -x7;
        mxGetPr(plhs[0])[3] = x5dot;
        mxGetPr(plhs[0])[4] = x6dot;
        mxGetPr(plhs[0])[5] = x6dot;
        
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
        
    } else if (flag == 'g') { 
/* ************************************************* */
<* Assign[guard, guard, CForm, AssignToArray -> {}, AssignEnd->";", AssignIndex->0, AssignIndent->"        ", AssignBreak->False] *>
/* ************************************************* */
        mxGetPr(plhs[0])[0] = guard;
        mxGetPr(plhs[0])[1] = guard;
        mxGetPr(plhs[0])[2] = guard;
        mxGetPr(plhs[0])[3] = guard;
        mxGetPr(plhs[0])[4] = guard;
        mxGetPr(plhs[0])[5] = guard;
        
    }
    /*