function saveMovie(framesTracked, movieName, fps, quality, compression, settings)
%SAVEMOVIE save a movie frome a frame matrix with size [m*n*c*i] 
%   with m, n framesize, c=colorspace, i=number offrames
% SAVEMOVIE(FRAMESTRACKED, MOVIENAME, FPS, QUALITY, COMPRESSION, SETTINGS)
% FRAMESTRACKED = frame matrix
% MOVIENAME = string with movie name
% FPS = frames per second
% QUALITY = quality
% COMPRESSION = compression
% SETTINGS = settings structure (see getSettings.m)

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
