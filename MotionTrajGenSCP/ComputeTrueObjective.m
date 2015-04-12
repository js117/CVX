% To evaluate progress of SCP steps
function pstar = ComputeTrueObjective(delta, c_obj, xstar, Uy, Uz, Ly, Lz, ls, lt, lx, n, T)

    % To compute the true objective, we need only compute the true slack
    % variables 
    x_true = xstar;
    get_s_from_x = @(x, ls, lt) (x(1:ls));
    get_t_from_x = @(x, ls, lt) (x(ls+1:ls+lt));
    
    % Simplest proxy of the objective: sum of the slacks + the rest of the
    % objective in v (i.e. from the definition x = [s t v]')
    
    slack_total = 0;
    theta = reshape(get_t_from_x(xstar, ls, lt), [n,T]);
    
    for i=1:T
        
        if (mod(i,2) == 0) % y
            
           y = NaoRH_fwd_py(theta(:,i));
           slack1 = y - Uy(i);
           slack_total = slack_total + max(0, slack1);
           
           slack2 = Ly(i) - y;
           slack_total = slack_total + max(0, slack2);
           
        end
        
        if (mod(i,3) == 0) % z
            
           z = NaoRH_fwd_pz(theta(:,i));
           slack1 = z - Uz(i);
           slack_total = slack_total + max(0, slack1);
           
           slack2 = Lz(i) - z;
           slack_total = slack_total + max(0, slack2);
           
        end
        
    end
    
    slack_total = slack_total * delta; 
    
    pstar = c_obj(ls+1:end)'*xstar(ls+1:end) + slack_total; 
    %pstar = slack_total; % view the slack

end