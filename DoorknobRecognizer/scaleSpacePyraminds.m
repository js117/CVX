% What it does:
%
% Technical Documentation: (ref: http://www.vlfeat.org/api/sift.html)
%
% How to create Gaussian Kernel: use Pascal's triangles, form outer
% product, normalize, look at odd-length rows of Pascal's triangle
%                   1 1
%                  1 2 1     -----> [1 2 1]/4 ~ Gaussian(s=1/sqrt(2))
%                 1 3 3 1
%                1 4 6 4 1   -----> [1 4 6 4 1]/16 ~ Gaussian(s=1)
%              1 5 10 10 5 1
%             1 6 15 20 15 6 1 ---> [1 6 15 20 15 6 1]/64 ~ Gaussian(s=sqrt(3/2))
%
% An "octave" refers to the doubling of the size of the smoothing kernel ==
% halving the image resolution. We downsample after an octave. The number
% of scales/octaves (repeatedly convolved images at that resolution) is a
% parameter. 
%
% E.g. "General idea: cascaded filtering using [1 4 6 4 1] kernel to generate
% a pyramid with two images per octave (power of 2 change in
% resolution). When we reach a full octave, downsample the image."
% "Each octave is sampled at this given number of intermediate scales (by
% default 3). Increasing this number might in principle return more refined 
% keypoints, but in practice can make their selection unstable due to noise"
%
function Y = scaleSpacePyraminds(inputImage, numOctaves, scalesPerOctave)
    Y = cell
end