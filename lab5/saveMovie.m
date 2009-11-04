function saveMovie(frames, movieName, fps, quality, compression)
    currMovie = avifile(movieName, 'fps', fps, 'quality', quality, 'Compression', compression);
    for i=1:size(frames,4)
        currMovie = addframe(currMovie, frames(:,:,:,i));
    end
    currMovie = close(currMovie);
end
