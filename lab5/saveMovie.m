function saveMovie(frames, RoiTracked, movieName, fps, quality, compression)
    % unix cannot compress
    if isunix
        compression = 'None';
    end
    currMovie = avifile(movieName, 'fps', fps, 'quality', quality, 'Compression', compression);
    for i=1:size(frames,4)

		Roi = RoiTracked(i);
		frames(Roi(2),     Roi(1):Roi(1)+w, 2:3, i)=0;
		frames(Roi(2)+h,   Roi(1):Roi(1)+w, 2:3, i)=0;
		frames(Roi(2):Roi(2)+h, Roi(1)    , 2:3, i)=0;
		frames(Roi(2):Roi(2)+h, Roi(1)+w  , 2:3, i)=0;
		frames(Roi(2),     Roi(1):Roi(1)+w, 1, i)=255;
		frames(Roi(2)+h,   Roi(1):Roi(1)+w, 1, i)=255;
		frames(Roi(2):Roi(2)+h, Roi(1)    , 1, i)=255;
		frames(Roi(2):Roi(2)+h, Roi(1)+w  , 1, i)=255;
        currMovie = addframe(currMovie, frames(:,:,:,i));
    end
    currMovie = close(currMovie);
end
