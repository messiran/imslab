close all
clear all
frames = frameReader('snowboard', settings);
meanShift( getSettings() )

% play movie
if isunix
    !mplayer -fps 10 -msglevel all=-1 result.avi;
elseif ispc
    !"C:\Program Files\VideoLAN\VLC\vlc.exe result.avi;
end
