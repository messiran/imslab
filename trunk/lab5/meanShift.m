function meanShift(settings)

%settings = getSettings();

%read frames
%frames = settings.frames;

% get target image (first frame)
imgT = settings.frames(:,:,:,1);

%% get region of interest
if (settings.getRoi == settings.GETROI.ON && (exist('Roi.mat')~=2))
    handle = figure('Visible','off');
    imshow(color2rgb(imgT,settings));
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
		disp('loading default roi');
		Roi = settings.defaultRoi;
	end
end
x = Roi(1); y = Roi(2); w = Roi(3); h = Roi(4);

RoiTracked(1,:) = Roi;

%% get weighting kernel for historgram counts

kernel = getMask(0, Roi, 'Epanechnikov');
% TODO reshape to column vector in a stand alone function
vectKernel = reshape(kernel, [1, (w+1)*(h+1)]);

[dummy,vectTHist] = getHist(vectKernel, imgT, Roi, settings);

% location filter (e.g. -2 -1 0 1 2)
locMask = getMask(2, Roi, 'location');

previousBC = 0;

% meanShift loop
for i = 2:size(settings.frames, 4)
	fprintf('\nmeanshift process %02.1f%\n\n', i/size(settings.frames, 4)*100);
    imgC = settings.frames(:,:,:,i);


	shift = 1;
	% perform shift till shift is negligible 
	while(max(abs(shift))>=0.5)
		% get candidate image
        vectKernel = reshape(getMask(0, Roi, 'Epanechnikov'), [1, (w+1)*(h+1)]);
		[vectCLoc, vectCHist] = getHist(vectKernel, imgC, Roi, settings);
		
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
        locMask = getMask(2, Roi, 'location');
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
    % vectKernel = reshape( getMask(0, cRois(2,:), 'Epanechnikov'), [1, (cRois(2,3)+1)*(cRois(2,4)+1)]);
    % [dummy, vectCSmallHist] = getHist(vectKernel, settings.frames(:,:,:,i), cRois(2,:), settings);
    % vectKernel = reshape( getMask(0, cRois(3,:), 'Epanechnikov'), [1, (cRois(3,3)+1)*(cRois(3,4)+1)]);
    % [dummy, vectCLargeHist] = getHist(vectKernel, settings.frames(:,:,:,i), cRois(3,:), settings);
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
    % vectKernel = reshape( getMask(0, cRois(2,:), 'Epanechnikov'), [1, (cRois(2,3)+1)*(cRois(2,4)+1)]);
    % [dummy, vectCSmallHist] = getHist(vectKernel, settings.frames(:,:,:,i), cRois(2,:), settings);
    % vectKernel = reshape( getMask(0, cRois(3,:), 'Epanechnikov'), [1, (cRois(3,3)+1)*(cRois(3,4)+1)]);
    % [dummy, vectCLargeHist] = getHist(vectKernel, settings.frames(:,:,:,i), cRois(3,:), settings);
    % vectKernel = reshape( getMask(0, cRois(4,:), 'Epanechnikov'), [1, (cRois(4,3)+1)*(cRois(4,4)+1)]);
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

%imageFrame(settings.frames, RoiTracked)

disp('saving movie...');
saveMovie(RoiTracked, 'result.avi', 10, 100,'Cinepak', settings);



% todo herhistogrammen (bij min distance opnieuw histogram berekenen???
% (regiondimensions aanpassen??))
% lokatie voorspellen mean shift

% gaus op colorimportance en locatie? mag dit met mean shift?
% learning rate

% EPANECHNIKOV DOES NOT SUM TO 1!!!

% TODO: try different scales, e.g. if a player runs away he gets smaller
