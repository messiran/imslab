function frame = frameDrawRect(frame, RoiTrack, colorChannels);
	h = RoiTrack(3); w = RoiTrack(4);
	for iColor=1:3
		frame(RoiTrack(2),     RoiTrack(1):RoiTrack(1)+w, iColor, :)=colorChannels(iColor);
		frame(RoiTrack(2)+h,   RoiTrack(1):RoiTrack(1)+w, iColor, :)=colorChannels(iColor);
		frame(RoiTrack(2):RoiTrack(2)+h, RoiTrack(1)    , iColor, :)=colorChannels(iColor);
		frame(RoiTrack(2):RoiTrack(2)+h, RoiTrack(1)+w  , iColor, :)=colorChannels(iColor);
	end	
end
