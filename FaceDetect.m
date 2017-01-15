function [ BB ] = FaceDetect( I, verbose )
% Detect one face from a frame (only one)
% [ face_para ] = FaceDetect( Image, verbose )
% face_para = x, y, width, height
% verbose: default = 0;
%          =1 : plot the frame with detected face

FDetect = vision.CascadeObjectDetector;

if nargin < 2
    verbose = 0;
end

BB = step(FDetect,I);

if verbose == 1
    figure,
    imshow(I); hold on
    for i = 1%:size(BB,1)
        rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
    end
    title('Initial Face Detection');
end
end

