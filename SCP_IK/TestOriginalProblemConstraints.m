% Return the total slack in the original constraints, which are:
% Xmin <= X <= Xmax
% ForwardKinRH(X(:,T)) = target
function y = TestOriginalProblemConstraints(Xmin, Xmax, T, start, target, X) % X is current point

    inequalitySlack = 0; 
    
    for i=1:T
       slack1 = max(X(:,i) - Xmax, 0);
       inequalitySlack = inequalitySlack + sum(slack1);
       slack2 = max(-X(:,i) + Xmin, 0);
       inequalitySlack = inequalitySlack + sum(slack2);
    end
    
    slack3 = sum(abs(ForwardKinRH_TEST_SIMPLE(X(:,T)) - target));
    slack4 = sum(abs(X(:,1) - start));
    
    equalitySlack = slack3 + slack4;
    
    y = inequalitySlack + equalitySlack; %scalarized, though we may break it up above if need be
    
end