function [ yuvHist ] = calcNormYUVHist(frame, x_center)

[h, w, d] = size(frame);
distP = calcDistMat(x_center, w, h);
distH = calcHistMat(frame);
scale_factor = sum(sum(distP));
yuvHist = zeros([3,8]);
for i = 1 : 3
	for j = 1 : 8
        yuvHist(i, j) = sum(sum(distP .* (distH(:, :, i) == j)));
    end
end
if scale_factor ~= 0
    yuvHist = yuvHist / (3 * scale_factor);
end
    %Size of yuvHist (3 ,8)
end

