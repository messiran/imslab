close all
warning on all

fprintf('Define your colorspace \n  (0) RGB \n  (1) XY \n  (2) rg\n  (3) Hue \n  (4) HS\n  (5) HSV \n');

inpColor = input('');

% if no input is given and settings is in workspace
if length(inpColor)==0 
	disp('you entered no value');
	if exist('settings')==0
		disp('I cant find settings in workspace');
		ERR;
	else
		disp('I found settings in workspace');
		inpColor = settings.color;
	end
else
	disp('you entered a value');
end

if exist('settings')~=0 && settings.color == inpColor 
	disp('using settings from the workspace..');
end
% detect settings change
if exist('settings')==0 || settings.color ~= inpColor 
	disp('no or other settings found in workspace, resetting vars');
	clear global;
	clear framesGlobal;
	delete frames.mat;
end

fprintf('Define your choice \n  (0) use old region of interest \n  (1) use custom region of interest selection\n');
inpGetRoi = input('');
if length(inpGetRoi)==0 
	inpGetRoi = settings.getRoi;
end
if inpGetRoi == 1
	delete Roi.mat
end
fprintf('Define your bin size (per colorchannel)\n');
inpN = input('');

settings = getSettings(inpColor, inpGetRoi, inpN);
disp('globalizing new settings');
% perform mean shift
meanShift( settings )

if settings.saveAndShowMovie == 1
	% play movie
	if isunix
		!mplayer -fps 10 -msglevel all=-1 result.avi;
	elseif ispc
		%!"C:\Program Files\VideoLAN\VLC\vlc.exe" result.avi;
	end
end
