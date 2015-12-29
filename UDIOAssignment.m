clc;clear;
fname = '/Users/hassan/Downloads/AssignmentUDIO.mp4';
v = VideoReader(fname);

%for drawing circles in frames
shapeInserter = vision.ShapeInserter('Shape','Circles','LineWidth',3); 

findex = 1; % index of frames
while hasFrame(v)
   videoFrame = readFrame(v);
    %VFedges = imfilter(videoFrame, h, 'replicate');
    C = corner(rgb2gray(videoFrame),'Harris','SensitivityFactor',0.04);
    Circles = int32([C 5*ones(size(C,1),1)]);
    newFrame = step(shapeInserter,videoFrame,Circles);
    imshow(newFrame);
    pause(1/10);
    %Frames(findex) = im2frame(newFrame);
    %findex = findex+1;   

end

%movie(Frames);
%%
% v = VideoReader(fname);
% 
% while hasFrame(v)
%     videoFrame = readFrame(v);
%     I = rgb2gray(videoFrame);
%     C = cornermetric(I);
%     corner_peaks = imregionalmax(C);
%     corner_idx = find(corner_peaks == true);
%     [r g b] = deal(I);
%     r(corner_idx) = 255;
%     g(corner_idx) = 255;
%     b(corner_idx) = 0;
%     RGB = cat(3,r,g,b);
%     imshow(RGB);
% end

