function saveMontage(thumbnailSize, stepSize, framesTracked, settings)
%SAVEMONTAGE save a montage from a  frame matrix with size [m*n*c*i] 
%   with m, n framesize, c=colorspace, i=number offrames
% SAVEMONTAGE(THUMBNAILSIZE, STEPSIZE, FRAMESTRACKED, SETTINGS)
% THUMBNAILSIZE = size of the images in montage
% STEPSIZE = number of frames to skip between images in montage
% FRAMESTRACKED = frame matrix
% SETTINGS = settings structure (see getSettings.m)

fileName = sprintf('scene_%s_colorspace%d_downsample_%dx_bin_%d.png', settings.movieName, settings.color, settings.downSampleRate, settings.N)

figure;
mHandle = montage(framesTracked(:,:,:,1:stepSize:thumbnailSize*stepSize));
saveas(mHandle, fileName);
