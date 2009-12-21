close all
clear all

frames = frameReader('snowboard', settings);
meanShift( getSettings() )

% play movie
!mplayer -fps 10 -msglevel all=-1 result.avi
