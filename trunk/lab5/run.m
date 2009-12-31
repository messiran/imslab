%RUN 
% perform multiple trackings with various settings
% currently with N=4 bins and XY=1 colorspace.
close all
warning off all

% set parameters
paramsN = [4];
paramsColor = [1];
inpGetRoi = 1;

% do loop for different parameters
for b = 1:length(paramsColor)
	clear framesGlobal;
	clear settings;
	delete frames.mat;

	inpColor = paramsColor(b);

	for a = 1:length(paramsN)
		inpN = paramsN(a);

		%get settings
        disp('create settings');
		settings = getSettings('color',inpColor, 'getRoi',inpGetRoi, 'N',inpN);
		disp('done');
        
		% perform mean shift
		disp('perform meanshift');
		RoiTracked = meanShift( settings );
		disp('done');

        %% write away results
        % add tracked window
		disp('add trackingdata to frames');
		framesTracked = addTrackingData(RoiTracked, settings);
		disp('done'); 

        % save movie
		if settings.saveAndShowMovie == 1
			disp('saving movie');
			saveMovie(framesTracked, 'result.avi', 10, 100,'Cinepak', settings);
			disp('done');
        end


        % save montage
		thumbnailSize = 6;
		stepSize = 10;

		disp('saving montage');
		saveMontage(thumbnailSize, stepSize, framesTracked, settings);
		disp('done'); 
		disp('done loop'); 

	end
end
