function [ yuv ] = calcHistMat(img)
%yuv = rgb2yuv(img);
yuv = img;
yuv = ceil((yuv + 1) / 32);
end

