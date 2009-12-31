function framesTracked = addTrackingData(RoiTracked, settings);
%ADDTRACKINGDATA add a tracked region of interest, in the movie as a box
% FRAMESTRACKED = ADDTRACKINGDATA(ROITRACKED,SETTINGS)
% FRAMESTRACKED = movie with a box of the tracked rois
% ROITRACKED = a matrix with rows of roi =[x, y, width, height]
% SETTINGS = settings structure (see getSettings.m)
    for i=1:size(settings.frames, 4);
		fprintf('Adding tracking data and writing frames   ');
		fprintf('\b\b\b %4.1f%%\n', i/size(settings.frames, 4) * 100);
		% get tracking data
		RoiTrack = RoiTracked(i,:);
		% draw tracking data in frame
		framesTracked(:,:,:,i) = frameDrawRect(color2rgb(settings.frames(:,:,:,i), settings), RoiTrack, settings.TrackColor);
    end
end

function frame = frameDrawRect(frame, RoiTrack, colorChannels);
%draw a rectangle of color = colorChannels at location roiTrack in frame
w = RoiTrack(3); h = RoiTrack(4);
	for iColor=1:3
		frame(RoiTrack(2),     RoiTrack(1):RoiTrack(1)+w, iColor, :)=colorChannels(iColor);
		frame(RoiTrack(2)+h,   RoiTrack(1):RoiTrack(1)+w, iColor, :)=colorChannels(iColor);
		frame(RoiTrack(2):RoiTrack(2)+h, RoiTrack(1)    , iColor, :)=colorChannels(iColor);
		frame(RoiTrack(2):RoiTrack(2)+h, RoiTrack(1)+w  , iColor, :)=colorChannels(iColor);
	end	
end