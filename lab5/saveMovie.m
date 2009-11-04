function saveMovie(frames, movieName, fps, quality, compression)
    currMovie = avifile(movieName, 'fps', fps, 'quality', quality, 'Compression', compression);
    currMovie = addframe(currMovie, frames);
    currMovie = close(currMovie);
end
