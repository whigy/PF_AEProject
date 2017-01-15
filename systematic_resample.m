function particle_new = systematic_resample(particle, weight)

cdf = cumsum(weight);
[dim, M] = size(particle);
particle_new = zeros(dim, M);
r_0 = rand / M;
for m = 1 : M
    i = find(cdf >= r_0,1,'first');
    particle_new(:, m) = particle(:, i);
    r_0 = r_0 + 1/M;
end
end