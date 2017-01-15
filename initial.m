function [x] = initial(center, sigma_devR, dim, m)

x = zeros(dim, m);
x(1:2, :) = repmat(center, 1, m);
x = x + randn([dim, m]) .* repmat(sigma_devR, 1, m);
weight = ones(1, m) ./ m;

end

