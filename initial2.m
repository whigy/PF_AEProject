function [particle] = initial2(frame, m)

[x, y, z] = size(frame)
particle = zeros(4, m)
particle(1,:) = rand(1, m) * x
particle(2,:) = rand(1, m) * y

end

