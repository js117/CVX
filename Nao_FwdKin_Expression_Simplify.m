% DH convention: variables named as a#, al#, d#, t# for (a, alpha, d,
% theta) in expression
function newExpression = Nao_FwdKin_Expression_Simplify(expression)

    syms a1 a2 a3 a4 a5 al1 al2 al3 al4 al5 d1 d2 d3 d4 d5

    newExpression = subs(expression,a1,0);
    simplify(newExpression);
    
    newExpression = subs(newExpression,a2,0); simplify(newExpression);
    newExpression = subs(newExpression,a3,0); simplify(newExpression);
    newExpression = subs(newExpression,al1,-pi/2); simplify(newExpression);
    newExpression = subs(newExpression,al2,pi/2); simplify(newExpression);
    newExpression = subs(newExpression,al3,pi/2); simplify(newExpression);
    newExpression = subs(newExpression,al4,-pi/2); simplify(newExpression);
    newExpression = subs(newExpression,d1,0); simplify(newExpression);
    newExpression = subs(newExpression,d2,0); simplify(newExpression);
    newExpression = subs(newExpression,d4,0); simplify(newExpression);
    
end