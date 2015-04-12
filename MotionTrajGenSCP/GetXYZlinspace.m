function xyz_linspace = GetXYZlinspace(NaoRH, theta_linspace) 
    
    T = size(theta_linspace,2);
    xyz_linspace = zeros(3,T);
    for i=1:T
       fwd = NaoRH.fkine(theta_linspace(:,i)');
       fwd = fwd(1:3,4);
       xyz_linspace(:,i) = fwd; 
    end

end