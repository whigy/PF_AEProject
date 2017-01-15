%% Parameters chase
clc
clear

% A = [1 0 1 0 0 0; 
%      0 1 0 1 0 0; 
%      0 0 1 0 0 0; 
%      0 0 0 1 0 0;
%      0 0 0 0 1 0
%      0 0 0 0 0 1];
% dim = size(A, 2);
% sigma_devR = [20, 20, 5, 5, 5, 5]';
A = [1 0 1 0; 
     0 1 0 1; 
     0 0 1 0; 
     0 0 0 1];
dim = size(A, 2);
sigma_devR = [15, 15, 1, 1]';
m = 1000;
Xstd_rgb = 50;
alpha = 0.1;

%v = VideoReader('10519268-1-hd.mp4');
% v = VideoReader('VID_20170115_094603.mp4');
v = VideoReader('VID_20170115_094626.mp4');

% myObj = VideoWriter('demo.mp4');
% writerObj.FrameRate = 30;
% open(myObj);

nFrames = v.NumberOfFrames
startFrameNum = 1;
endFrameNum = 160;


%% Particle Filter
figure(1)
frame = read(v, 210);
flag = 0;
BB = -1;
for i = startFrameNum : endFrameNum
    
    % Getting Image
    frame = read(v, i);

    try
       if flag == 0
           disp('Face not detected yet')
           BB = FaceDetect( frame, 0 ); % 1: plot the image
       end
    end
    
    if flag == 0
        if BB(1) ~= -1;
            flag = 1; %face detected
            x = BB(1)
            y = BB(2)
            w = BB(3)
            h = BB(4)
            rect = [x, y, w, h];
            center = [x + 0.5 * w, y + 0.5 * h]';
            targetSize = [w, h];
            particle = initial([x; y], sigma_devR, dim, m);

            window = getWindow(frame, center, targetSize);
            target_frame = getStateFrame(frame, window);

            target_hist = calcNormYUVHist(target_frame, center);

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
        end
    else
        % Model Update
        particle = modelUpdate(particle, A, sigma_devR, m, alpha);

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
    end

    % Showing Image
    
    figure(1)
    imshow(frame);
    if flag ~=0
        hold on
        plot(particle(1, :)+ 0.5 * w, particle(2,:)+ 0.5 * h, 'b.');
        %frame(int16(particle(1, :)+ 0.5 * w), int16(particle(2,:)+ 0.5 * h), : ) = repmat([0, 0, 255]', 1, m);
        
        axis([0,size(frame,2),0,size(frame,1)])
        hold off
%         writeVideo(myObj,frame);
    end
    drawnow
    %show_state_estimated(X, Y_k);
    
end
% close(myObj);
