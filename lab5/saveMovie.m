function saveMovie(RoiTracked, movieName, fps, quality, compression, settings)
	%global framesTracked;
	saveMovie = 1;

    % unix cannot compress
    if isunix
        compression = 'None';
    end
	if settings.saveAndShowMovie == 1
		currMovie = avifile(movieName, 'fps', fps, 'quality', quality, 'Compression', compression);
	end

	% copy from frames
    for i=1:size(settings.frames,4);
		fprintf('Adding tracking data and writing frames   ');
		fprintf('\b\b\b %4.1f%%\n', i/size(settings.frames, 4) * 100);
		% get tracking data
		RoiTrack = RoiTracked(i,:);
		% draw tracking data in frame
		framesTracked(:,:,:,i) = frameDrawRect(color2rgb(settings.frames(:,:,:,i), settings), RoiTrack, [255, 255, 0]);
		if settings.saveAndShowMovie == 1
        	currMovie = addframe(currMovie, framesTracked(:,:,:,i));
		end			
    end
	if settings.saveAndShowMovie == 1
		currMovie = close(currMovie);
	end			


 	thumbnailSize = 6;
 	stepSize = 10;
 
 	disp('saving framesTracked..');
 	save framesTracked.mat framesTracked
 	montage(framesTracked(:,:,:,1:stepSize:thumbnailSize*stepSize));

end
