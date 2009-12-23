function saveMontage(thumbnailSize, stepSize, framesTracked, settings)

% colorList = {'RGB', 'XY', 'rg', 'H', 'HS','HSV'};
% color = colorList(settings.color+1)

fileName = sprintf('scene_%s_colorspace%d_downsample_%dx_bin_%d.png', settings.movieName, settings.color, settings.downSampleRate, settings.N)

figure;
mHandle = montage(framesTracked(:,:,:,1:stepSize:thumbnailSize*stepSize));
saveas(mHandle, fileName);
