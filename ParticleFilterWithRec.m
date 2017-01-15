%% Parameters chase
clc
clear

A = [1 0 1 0; 
     0 1 0 1; 
     0 0 1 0; 
     0 0 0 1];
dim = size(A, 2);
sigma_devR = [2, 2, 0.5, 0.5]';
m = 1000;
Xstd_rgb = 50;
Xrgb_trgt = [255; 0; 0];

v = VideoReader('chase.mp4');
%v = VideoReader('ball.avi');

nFrames = v.NumberOfFrames
startFrameNum = 1;
endFrameNum = nFrames;

% initialization

x = 295;
y = 70;   
w = 20;   
h = 20;
rect = [x, y, w, h];



%% Parameters person
clc
clear

A = [1 0 1 0; 
     0 1 0 1; 
     0 0 1 0; 
     0 0 0 1];
dim = size(A, 2);
sigma_devR = [10, 10, 1, 1]';
m = 400;
Xstd_rgb = 50;
Xrgb_trgt = [255; 0; 0];
v = VideoReader('Person.wmv');
nFrames = v.NumberOfFrames
startFrameNum = 25;
endFrameNum = nFrames;

% initialization
x = 560;
y = 130;   
w = 50;   
h = 100;
rect = [x, y, w, h];



%% Particle Filter

frame = read(v, startFrameNum);

center = [x + 0.5 * w, y + 0.5 * h]';
targetSize = [w, h];
particle = initial([x; y], sigma_devR, dim, m);

window = getWindow(frame, center, targetSize);
target_frame = getStateFrame(frame, window);

target_hist = calcNormYUVHist(target_frame, center);

figure(1)
size(frame)
size(target_frame)
frame(1:size(target_frame, 1),1:size(target_frame, 2),:) = target_frame;
imshow(frame); hold on
rectangle('Position',rect,'EdgeColor','b')
% plot(x, y, 'ro')
% plot(x+w, y+w, 'bo')
% plot(center(1), center(2), 'ko');
plot(particle(1,:)+ 0.5 * w, particle(2,:)+ 0.5 * h, '.');

axis on
hold off
drawnow

%%
for i = startFrameNum+1 : endFrameNum
    
    % Getting Image
    frame = read(v, i);
    
    % Model Update
    particle = modelUpdate(particle, A, sigma_devR, m, 0.2);
    
    % Calculating Log Likelihood
    %weight = calc_log_likelihood(Xstd_rgb, Xrgb_trgt, particle(1:2, :), frame);
    weight = zeros(1, m);
    for i = 1:m
        targetSize = [w, h];
        particleCenter =  [particle(1, i) + 0.5 * w, particle(2, i) + 0.5 * h];
        window = getWindow(frame, particleCenter, targetSize);
        particleFrame = getStateFrame(frame, window);
        particleHist = calcNormYUVHist(particleFrame, particleCenter);
        weight(i) = calcHistDist(particleHist, target_hist);
    end
    weight = weight ./ sum(sum(weight));
    
    % Resampling
    particle = systematic_resample(particle, weight);

    % Showing Image
    %show_particles(particle, frame); 
    
    figure(1)
    imshow(frame); hold on
    plot(particle(1, :)+ 0.5 * w, particle(2,:)+ 0.5 * h, 'b.');
    axis([0,size(frame,2),0,size(frame,1)])
    hold off
    drawnow
    %show_state_estimated(X, Y_k);

end

