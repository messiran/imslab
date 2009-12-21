close all

settings = getSettings();
meanShift( settings )

% play movie
if isunix
    !mplayer -fps 10 -msglevel all=-1 result.avi;
elseif ispc
    !"C:\Program Files\VideoLAN\VLC\vlc.exe" result.avi;
end
