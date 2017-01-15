function [ x_bar ] = modelUpdate(x, A, sigma_devR, m, alpha )

mean_x = mean(x, 2);
x = (1 - alpha) * A * x + repmat(alpha * mean_x, 1, m);
dim = size(x, 1);
diffusion = randn([dim, m]).* repmat(sigma_devR, 1, m);
x_bar = diffusion + x;

end

