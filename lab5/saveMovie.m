function saveMovie(framesTracked, movieName, fps, quality, compression, settings)
% unix cannot compress
if isunix
	compression = 'None';
end

currMovie = avifile(movieName, 'fps', fps, 'quality', quality, 'Compression', compression);

for i=1:size(framesTracked,4);
	currMovie = addframe(currMovie, framesTracked(:,:,:,i));
end
currMovie = close(currMovie);

% play movie
if isunix
	!mplayer -fps 10 -msglevel all=-1 result.avi;
elseif ispc
	%!"C:\Program Files\VideoLAN\VLC\vlc.exe" result.avi;
end
