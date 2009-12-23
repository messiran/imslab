close all
warning on all

%disp('no or other settings found in workspace, resetting vars');
%delete frames.mat;
%delete Roi.mat

paramsN = [4, 8];
paramsColor = [0, 1];
inpGetRoi = 0;

for b = 1:length(paramsColor)
	clear framesGlobal;
	clear settings;
	delete frames.mat;

	inpColor = paramsColor(b)

	for a = 1:length(paramsN)
		inpN = paramsN(a);

		disp('create settings');
		settings = getSettings(inpColor, inpGetRoi, inpN);
		disp('done'); 
		% perform mean shift

		disp('perform meanshift');
		RoiTracked = meanShift( settings );
		disp('done');

		disp('add trackingdata to frames');
		framesTracked = addTrackingData(RoiTracked, settings);
		disp('done'); 

		if settings.saveAndShowMovie == 1
			disp('saving movie');
			saveMovie(framesTracked, 'result.avi', 10, 100,'Cinepak', settings);
			disp('done');
		end


		thumbnailSize = 6;
		stepSize = 10;

		disp('saving montage');
		saveMontage(thumbnailSize, stepSize, framesTracked, settings);
		disp('done'); 
		disp('done loop'); 

	end
end
