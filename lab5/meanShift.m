function RoiTracked = meanShift(settings)
%MEANSHIFT track an object using meanShift
% ROITRACKED = MEANSHIFT(SETTINGS)
% ROITRACKED = an array of roi's[x,y,w,h] as tracked by meanshift 
% SETTINGS = settings structure (see getSettings.m)  

% get target image (first frame)
imgT = settings.frames(:,:,:,1);
% get region of interest and extract the sizes
Roi = settings.Roi;
w = Roi(3); h = Roi(4);

% start filling the resulting track
RoiTracked(1,:) = Roi;

%% get weighting kernel for histogram counts
[dummy,vectTHist] = getHist(imgT, Roi, settings);

% location filter (e.g. -2 -1 0 1 2)
locMask = getMask(Roi, 'location');

previousBC = 0;

% meanShift loop
for i = 2:size(settings.frames, 4)
	fprintf('\nmeanshift process %02.1f%\n\n', i/size(settings.frames, 4)*100);
    imgC = settings.frames(:,:,:,i);


	shift = 1;
	% perform shift till shift is negligible 
	while(max(abs(shift))>=0.5)
		% get candidate image
		[vectCLoc, vectCHist] = getHist(imgC, Roi, settings);
		
		% candidate model
		Pu = vectCHist;

		% targetmodel
		Qu = vectTHist;

        warning off all
		% the W's per bin
		Wbin = sqrt(Qu./Pu);
        warning on all
		% solve Nan problem
		Wbin(Pu==0) = 0;
		% set the W's in corresponding pixel in the image
		W = Wbin(vectCLoc);

		% duplicate W 2 times in the width dim
        locMask = getMask(Roi, 'location');
		shift = sum((W * ones(1,2)).*locMask) / sum(W);
		
        Roi(1:2) = round(Roi(1:2)+shift); 


	end
	% store tracking data
    
	RoiTracked(i,:) = [Roi(1:2), w, h];
	% below searches for 
    % % compare X
	% % different roi's
    % cRois(1,:) = [Roi(1:2), w, h];
    % cRois(2,:) = [Roi(1)+1,Roi(2), w-2, h];
    % cRois(3,:) = [Roi(1)-1,Roi(2), w+2, h];
	% % TODO size vectKernel addapt to size roi ?
    % [dummy, vectCSmallHist] = getHist(settings.frames(:,:,:,i), cRois(2,:), settings);
    % [dummy, vectCLargeHist] = getHist(settings.frames(:,:,:,i), cRois(3,:), settings);
    % vectCHists = [vectCHist, vectCSmallHist, vectCLargeHist];
    % 
	% % returns a 1x3 dist vector
    % dists = histdists(vectTHist, vectCHists, 'bc', 'normalise');
	% % roi with smallest distance 
    % [bestBC, idx] = min(dists);
    % bestCRoi = cRois(idx,:);
    % bestVectCHist = vectCHists(:,idx);
    % 
    % % compare Y & previous ROI
    % cRois(1,:) = bestCRoi;
    % cRois(2,:) = [bestCRoi(1),bestCRoi(2)+1, w, h-2];
    % cRois(3,:) = [bestCRoi(1),bestCRoi(2)-1, w, h+2];
    % cRois(4,:) = RoiTracked(i-1,:);
    % [dummy, vectCSmallHist] = getHist(settings.frames(:,:,:,i), cRois(2,:), settings);
    % [dummy, vectCLargeHist] = getHist(settings.frames(:,:,:,i), cRois(3,:), settings);
    % [dummy, vectCPreviousHist] = getHist(vectKernel, settings.frames(:,:,:,i), cRois(4,:), settings);
    % vectCHists = [bestVectCHist, vectCSmallHist, vectCLargeHist, vectCPreviousHist];
    % 
    % dists = histdists(vectTHist, vectCHists, 'bc', 'normalise');
    % [bestBC, idx] = min(dists);
    % bestCRoi = cRois(idx,:);
    % bestVectCHist = vectCHists(:,idx);
    % 

	% RoiTracked(i,:) = bestCRoi;

    % Roi = RoiTracked(i,:);
    % x = RoiTracked(i,1); y = RoiTracked(i,2); w = RoiTracked(i,3); h = RoiTracked(i,4);

end

% show the profiler result
if settings.prof == settings.PROF.ON
	profile viewer 
end
