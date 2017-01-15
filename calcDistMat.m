function [ distMat ] = calcDistMat(x_center, w, h)

    % distMat is of size (h, w)
h_list = 1 : h;
w_list = 1 : w;
distMat_h = (ones(w, 1) * h_list)' - ones([h, w]) * floor(h/2);
distMat_w = ones(h, 1) * w_list - ones([h, w]) * floor(w/2);
distMat = (distMat_h .^ 2 + distMat_w .^ 2) / (w ^ 2 + h ^ 2);
distMat = ones(h, w) - distMat;

end

