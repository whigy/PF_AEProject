function [ weight ] = calcHistDist(hist1, hist2)
    
rho = sum(sum(sum(hist1 .* hist2))); %Bhattacharyya coefficient
weight = rho;    
if rho ~=0
    dist_2 = 1 - rho;
    %weight = ( sqrt(2 * pi) * rho)^(-1) * exp(- dist_2 / square(rho));
    weight = exp(- dist_2 *20);
else
    weight = 0;

end

