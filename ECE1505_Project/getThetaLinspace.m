function y = getThetaLinspace(theta_init, theta_final, T)
    n = max(size(theta_init)); % which better equal the same for theta_final
    
    thetaLinSpace = zeros(n, T); 
    
    for i=1:n
        thetaLinSpace(i,:) = linspace(theta_init(i), theta_final(i), T);
    end
    y = thetaLinSpace; % meant to be vectorized
end