close all
clear all

settings = getSettings();

%read frames
frames = frameReader('voetbal', settings);

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
            floor(rect(4))];
	save('Roi.mat', 'Roi');
    close(handle);
else 
	if (exist('Roi.mat')==2)
		load('Roi.mat');
	else
		Roi = settings.defaultRoi;
	end
end
x = Roi(1); y = Roi(2); w = Roi(3); h = Roi(4);

%% get weighting kernel for historgram counts

kernel = getMask(0, Roi, 'Epanechnikov');
% TODO reshape to column vector in a stand alone function
vectKernel = reshape(kernel, [1, (w+1)*(h+1)]);

[dummy,vectTHist] = getHist(vectKernel, imgT, Roi, settings);

xNewVect = [];
% meanShift loop
for i = 2:size(frames, 4)
	i
    imgC = frames(:,:,:,i);


	Yshift = 1;
	% perform shift till shift is negligible 
	while(max(abs(Yshift))>=0.5)
		% get candidate image
		[vectCLoc, vectCHist] = getHist(vectKernel, imgC, Roi, settings);
		
		% candidate model
		Pu = vectCHist;

		% targetmodel
		Qu = vectTHist;

		% define absolute start location 
		% Y0 = [x+.5*w, y + .5*h]

		% the W's per bin
		Wbin = sqrt(Qu./Pu);
		% solve Nan problem
		Wbin(Pu==0) = 0;
		% set the W's in corresponding pixel in the image
		W = Wbin(vectCLoc);

		% location filter (e.g. -2 -1 0 1 2)
		X = getMask(2, Roi, 'location');

		% duplicate W 2 times in the width dim
		Yshift = sum((W * ones(1,2)).*X) / sum(W);
		xNew = round(Roi(1)+Yshift(1));
		xNewVect = [xNewVect;xNew];
		yNew = round(Roi(2)+Yshift(2));
		close;
		%imshow(frames(:,:,:,i));
		hold on;
		%rectangle('Position',[xNew,yNew, w, h]);
		f = frames(:,:,:,i);
		x = Roi(1); y = Roi(2);
        f(y,     x:x+w, :)=0;
        f(y+h,   x:x+w, :)=0;
        f(y:y+h, x    , :)=0;
        f(y:y+h, x+w  , :)=0;

		%rectMask = getMask(size(f),Roi,'border');
		% TODO optimize with ones
		%rectMask = repmat(rectMask, [1,1,3]);
		%f(rectMask) = 0;
		frames(:,:,:,i) = f;

		% define new Roi
		Roi(1) = xNew;
		Roi(2) = yNew;
	end

	%framesTracked(:,:,:,i-1) = f.cdata;
	disp('shift!');
end

%movie(immovie(frames))
saveMovie(frames, 'result.avi', 10, 100,'Cinepak');

% show the profiler result
if settings.prof == settings.PROF.ON
	profile viewer 
end

% play movie
!mplayer -fps 2 result.avi

% todo herhistogrammen (bij min distance opnieuw histogram berekenen???
% (regiondimensions aanpassen??))
% lokatie voorspellen mean shift

% gaus op colorimportance en locatie? mag dit met mean shift?
% learning rate

% EPANECHNIKOV DOES NOT SUM TO 1!!!

% TODO: try different scales, e.g. if a player runs away he gets smaller
