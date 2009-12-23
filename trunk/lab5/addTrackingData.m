function framesTracked = addTrackingData(RoiTracked, settings);
    for i=1:size(settings.frames, 4);
		fprintf('Adding tracking data and writing frames   ');
		fprintf('\b\b\b %4.1f%%\n', i/size(settings.frames, 4) * 100);
		% get tracking data
		RoiTrack = RoiTracked(i,:);
		% draw tracking data in frame
		framesTracked(:,:,:,i) = frameDrawRect(color2rgb(settings.frames(:,:,:,i), settings), RoiTrack, settings.TrackColor);
    end
end
