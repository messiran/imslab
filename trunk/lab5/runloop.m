%runLoop

close all
clear all

global COLOR GETROI PROF settings

%% Variables
% settings controling process flow
COLOR = struct('RGB', 0, 'XY', 1);
GETROI = struct('ON', 0, 'OFF', 1);
PROF = struct('ON', 0, 'OFF', 1);
DIRTY = struct('dirty', true, 'clean', false);
settings = struct(...
    'color', COLOR.RGB, ...
    'getRoi', GETROI.OFF, ...
    'prof', PROF.ON, ...
    'searchNbh', [20,20], ...
    'dirty', DIRTY.clean);


% other settings
if settings.color == COLOR.XY
    settings.NBins = [16,16];
else
    settings.NBins = [16,16,16];
end

% do profiling if needed
if settings.prof == PROF.ON
    profile on
end

%read frames
frames = frameReader('voetbal', settings.dirty);

% temporary
imgOrigIn = frames(:,:,:,1);

%% change colorspace
if settings.color == COLOR.XY
    % goto xy space
    imgIn = rgb2xy(imgOrigIn);
else
    imgIn = imgOrigIn;
end
% set sizes we will use
[MIn, NIn, PIn] = size(imgIn);


%% get region of interest
if settings.getRoi == GETROI.ON
    h = figure;
    imshow(imgOrigIn);
    rect = getrect(h)
    x = floor(rect(1));
    y = floor(rect(2));
    w = floor(rect(3));
    h = floor(rect(4));
    close(h);
else
    x = 575;
    y = 240;
    w = 10;
    h = 20;
end


for i = 1:size(frames, 4)

    %% Get region of interest and calculate new histogram 
    % TODO this histogram has already been calculated in
    % findHist except for the 1st time

    % get region of interest
    imgRoi = imgIn(y:y+h, x:x+w, :);
    [MRoi, NRoi, PRoi] = size(imgRoi);
    colRoi = reshape(imgRoi, [MRoi*NRoi, PRoi]);

    % construct histogram
    % get bin location
    colLocRoi = img2histloc(colRoi, settings.NBins);
    % count buckets
    histRoi = locs2hists(colLocRoi, settings.NBins);

    % crop imageout to define search area
    searchx = x-settings.searchNbh(1);
    searchy = y-settings.searchNbh(2);
    searchw = 2*settings.searchNbh(1)+w;
    searchh = 2*settings.searchNbh(2)+h;

    imgOut = frames(:,:,:,i);
    imgOut = frames(searchy:searchy+searchh,searchx:searchx+searchw,:,i);
    [MOut, NOut, POut] = size(imgOut);

    % find the best histogram matches
    track(i,:,:) = findHist(histRoi, imgOut, [w, h]+1);
     
    % move to full image coordinates
    track(i,:,:) = track(i,:,:) + repmat([searchx,searchy], [1,1,size(track,3)]) - 1;
    
    % write tracking in images
    fig = frames(:,:,:,i);
    
    mask = getmask(size(fig),[track(i,1,1), track(i,2,1), w, h], 'border');
    fig(mask)=0;
    mask = getmask(size(fig),[track(i,1,1)+w/2-3, track(i,2,1)+h/2-3, 6, 6], 'ellipse');
    fig(mask)=0;
    mask = getmask(size(fig),[track(i,1,1)+w/2-1, track(i,2,1)+h/2-1, 2, 2], 'ellipse');
    fig(mask)=1;
    % write in frames, to save memory
    imgIn = frames(:,:,:,i);
    frames(:,:,:,i) = fig;
    
    % update window, we now track on 1st dimension
    x = track(i,1,1);
    y = track(i,2,1);
 
end

montage(frames)

%show profiler
if settings.prof == PROF.ON
    profile viewer
end



% todo herhistogrammen (bij min distance opnieuw histogram berekenen (regiondimensions aanpassen??))
% histogram gaussen, (midden belangrijker)
% lokatie voorspellen mean shift
