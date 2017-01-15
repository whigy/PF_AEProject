function [ window ] = getWindow(frame, center, windowsize)
x = center(1);
y = center(2);
hx = windowsize(1) /2;
hy = windowsize(2) /2;

[height, width, c] = size(frame);
window = int16([max(1, y - hy), max(1, x - hx), min(height, y + hy), min(width, x + hx)]);

end

