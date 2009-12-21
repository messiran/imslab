function saveMovie(frames, RoiTracked, movieName, fps, quality, compression, settings)
    % unix cannot compress
    if isunix
        compression = 'None';
    end
    currMovie = avifile(movieName, 'fps', fps, 'quality', quality, 'Compression', compression);
    for i=1:size(frames,4);
		RoiTrack = RoiTracked(i,:);
		frame = frameDrawRect(color2rgb(frames(:,:,:,i), settings), RoiTrack, [255, 255, 0]);
        currMovie = addframe(currMovie, frame);
    end
    currMovie = close(currMovie);
end
