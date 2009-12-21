function meanShift(settings)

%settings = getSettings();

%read frames
frames = settings.frames;

% get target image (first frame)
imgT = frames(:,:,:,1);

%% get region of interest
if (settings.getRoi == settings.GETROI.ON && (exist('Roi.mat')~=2))
    handle = figure('Visible','off');
    imshow(color2rgb(imgT,settings));
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


	end
	% store tracking data
    previous = RoiTracked(i-2,:);
    
    % compare X
    cRois(1,:) = [Roi(1:2), h, w];
    cRois(2,:) = [Roi(1)+1,Roi(2), w-2, h]
    cRois(3,:) = [Roi(1)-1,Roi(2), w+2, h]
    [dummy, vectCSmallHist] = getHist(vectKernel, frames(:,:,:,i), cRois(2,:), settings);
    [dummy, vectCLargeHist] = getHist(vectKernel, frames(:,:,:,i), cRois(3,:), settings);
    vectCHists = [vectCHist, vectCSmallHist, vectCLargeHist];
    
    dists = histdists(vectTHist, vectCHists, 'bc', 'normalise');
    [bestBC, I] = min(dists);
    bestCRoi = cRois(I,:);
    bestVectCHist = vectCHist(:,I);
    
    % compare Y
    cRois(1,:) = bestCRoi;
    cRois(2,:) = [bestCRoi(1),bestCRoi(2)+1, w, h-2]
    cRois(3,:) = [bestCRoi(1),bestCRoi(2)-1, w, h+2]
    [dummy, vectCSmallHist] = getHist(vectKernel, frames(:,:,:,i), cRois(2,:), settings);
    [dummy, vectCLargeHist] = getHist(vectKernel, frames(:,:,:,i), cRois(3,:), settings);
    vectCHists = [vectCHist, vectCSmallHist, vectCLargeHist];
    
    [bestBC, I] = min(dists);
    bestCRoi = cRois(I,:);
    bestVectCHist = vectCHist(:,I);
    
    if(bestBC) > previousBC
        RoiTracked(i-1,:) = RoiTracked(i-1,:)
    else
        RoiTracked(i-1,:) = bestCRoi;
    end
end

% show the profiler result
if settings.prof == settings.PROF.ON
	profile viewer 
end

%imageFrame(frames, RoiTracked)

disp('saving movie...');
saveMovie(frames, RoiTracked, 'result.avi', 10, 100,'Cinepak', settings);



% todo herhistogrammen (bij min distance opnieuw histogram berekenen???
% (regiondimensions aanpassen??))
% lokatie voorspellen mean shift

% gaus op colorimportance en locatie? mag dit met mean shift?
% learning rate

% EPANECHNIKOV DOES NOT SUM TO 1!!!

% TODO: try different scales, e.g. if a player runs away he gets smaller
