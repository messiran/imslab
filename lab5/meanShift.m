function meanShift(settings)

%settings = getSettings();

%read frames
frames = settings.frames;

% get target image (first frame)
imgT = transformColor(frames(:,:,:,1), settings);

%% get region of interest
if (settings.getRoi == settings.GETROI.ON && (exist('Roi.mat')~=2))
    handle = figure('Visible','off');
    imshow(imgT);
    rect = getrect(handle);
    Roi =  [floor(rect(1)),...
            floor(rect(2)),...
            floor(rect(3)),...
            floor(rect(4))]
	save('Roi.mat', 'Roi');
    close(handle);
else 
	if (exist('Roi.mat')==2)
		load('Roi.mat');
	else
		disp('loading default roi');
		Roi = settings.defaultRoi;
	end
end
x = Roi(1); y = Roi(2); w = Roi(3); h = Roi(4);

%% get weighting kernel for historgram counts

kernel = getMask(0, Roi, 'Epanechnikov');
% TODO reshape to column vector in a stand alone function
vectKernel = reshape(kernel, [1, (w+1)*(h+1)]);

[dummy,vectTHist] = getHist(vectKernel, imgT, Roi, settings);

% location filter (e.g. -2 -1 0 1 2)
locMask = getMask(2, Roi, 'location');

% meanShift loop
for i = 2:size(frames, 4)
	i
    imgC = frames(:,:,:,i);


	shift = 1;
	% perform shift till shift is negligible 
	while(max(abs(shift))>=0.5)
		% get candidate image
		[vectCLoc, vectCHist] = getHist(vectKernel, imgC, Roi, settings);
		
		% candidate model
		Pu = vectCHist;

		% targetmodel
		Qu = vectTHist;

		% the W's per bin
		Wbin = sqrt(Qu./Pu);
		% solve Nan problem
		Wbin(Pu==0) = 0;
		% set the W's in corresponding pixel in the image
		W = Wbin(vectCLoc);

		% duplicate W 2 times in the width dim
		shift = sum((W * ones(1,2)).*locMask) / sum(W);
		
        Roi(1:2) = round(Roi(1:2)+shift); 

		%rectMask = getMask(size(f),Roi,'border');
		% TODO optimize with ones
		%rectMask = repmat(rectMask, [1,1,3]);
		%f(rectMask) = 0;

		% define new Roi
	end
	% draw red rectangle
	frames(Roi(2),     Roi(1):Roi(1)+w, 2:3, i)=0;
	frames(Roi(2)+h,   Roi(1):Roi(1)+w, 2:3, i)=0;
	frames(Roi(2):Roi(2)+h, Roi(1)    , 2:3, i)=0;
	frames(Roi(2):Roi(2)+h, Roi(1)+w  , 2:3, i)=0;
	frames(Roi(2),     Roi(1):Roi(1)+w, 1, i)=255;
	frames(Roi(2)+h,   Roi(1):Roi(1)+w, 1, i)=255;
	frames(Roi(2):Roi(2)+h, Roi(1)    , 1, i)=255;
	frames(Roi(2):Roi(2)+h, Roi(1)+w  , 1, i)=255;

	%framesTracked(:,:,:,i-1) = f.cdata;
end

% show the profiler result
if settings.prof == settings.PROF.ON
	profile viewer 
end

disp('saving movie...');
%movie(immovie(frames))
saveMovie(frames, 'result.avi', 10, 100,'Cinepak');


% play movie
!mplayer -fps 10 -msglevel all=-1 result.avi

% todo herhistogrammen (bij min distance opnieuw histogram berekenen???
% (regiondimensions aanpassen??))
% lokatie voorspellen mean shift

% gaus op colorimportance en locatie? mag dit met mean shift?
% learning rate

% EPANECHNIKOV DOES NOT SUM TO 1!!!

% TODO: try different scales, e.g. if a player runs away he gets smaller
