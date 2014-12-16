% Return the value of the true penalty function:
% minimize sum(abs(X(:,T+1)-X(:,T)))
% subject to
% Xmin <= X <= Xmax
% ForwardKinRH(X(:,T)) = target
function y = TruePenaltyFunction(Xmin, Xmax, T, start, target, mu, X) % X is current point

    f = 0;
    for k=1:T-1
       f = f + norm(X(:,k+1)-X(:,k),2); 
    end

    inequalitySlack = 0; 
    
    for i=1:T
       slack1 = max(X(:,i) - Xmax, 0); 
       inequalitySlack = inequalitySlack + sum(slack1);
       slack2 = max(-X(:,i) + Xmin, 0);
       inequalitySlack = inequalitySlack + sum(slack2);
    end
    if (inequalitySlack > 0)
       disp('Warning: inequality slack > 0'); 
    end
    
    slack3 = sum(abs(ForwardKinRH_TEST_SIMPLE(X(:,T)) - target));
    slack4 = sum(abs(X(:,1) - start));
    
    equalitySlack = slack3 + slack4;
    
    y = f + mu*(inequalitySlack + equalitySlack); %scalarized, though we may break it up above if need be
    
end