%runLoop

close all
clear all

global COLOR GETROI PROF settings

%% Variables
% settings controling process flow
COLOR = struct('RGB', 0, 'XY', 1);
GETROI = struct('ON', 0, 'OFF', 1);
PROF = struct('ON', 0, 'OFF', 1);
CACHE = struct('ON', true, 'OFF', false);
settings = struct(...
    'color', COLOR.RGB, ...
    'getRoi', GETROI.ON, ...
    'prof', PROF.OFF, ...
    'searchNbh', [20,20], ...
    'cache', CACHE.ON);


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
frames = frameReader('voetbal', settings.cache);

% temporary
imgOrigIn = frames(:,:,:,1);

%% change colorspace
if settings.color == COLOR.XY
    % goto xy space
    imgPrev = rgb2xy(imgOrigIn);
else
    imgPrev = imgOrigIn;
end
% set sizes we will use
[MIn, NIn, PIn] = size(imgPrev);


%% get region of interest
if settings.getRoi == GETROI.ON
    handle = figure;
    imshow(imgOrigIn);
    rect = getrect(handle)
    x = floor(rect(1));
    y = floor(rect(2));
    w = floor(rect(3));
    h = floor(rect(4));
    close(handle);
else
    x = 575;
    y = 230;
    w = 10;
    h = 40;
end
%% get weighting kernel for historgram counts

kernel = getmask(0,[x,y,w,h], 'Epanechnikov');
colKernel = reshape(kernel, [1, (w+1)*(h+1)]);
    
imgRoi = imgPrev(y:y+h, x:x+w, :);
% main loop
for i = 1:size(frames, 4)

    %% Get region of interest and calculate new histogram 
    % TODO this histogram has already been calculated in
    % findHist except for the 1st time

    % get region of interest
    %imgRoi = imgPrev(y:y+h, x:x+w, :);
    [MRoi, NRoi, PRoi] = size(imgRoi);
    colRoi = reshape(imgRoi, [MRoi*NRoi, PRoi]);


    
    % construct histogram
    % get bin location
    colLocRoi = img2histloc(colRoi, settings.NBins);
    % count buckets
    histRoi = locs2hists(colLocRoi, settings.NBins, colKernel);

    % crop imageout to define search area
    searchX = x-settings.searchNbh(1);
    searchY = y-settings.searchNbh(2);
    searchW = 2*settings.searchNbh(1)+w;
    searchH = 2*settings.searchNbh(2)+h;

    imgSearchArea = frames(searchY:searchY+searchH,searchX:searchX+searchW,:,i);
    %[MOut, NOut, POut] = size(imgSearchArea);

    % find the best histogram matches per difference method
    track(i,:) = findHist(histRoi, imgSearchArea, [w, h]+1, colKernel);
     
    % add the searchWindow location coords
    track(i,:) = track(i,:) + [searchX,searchY] - 1;
   
    % update window, we now track on 1st dimension
    x = track(i,1);
    y = track(i,2);
    
    imgPrev = frames(:,:,:,i);
end

% add tracking info (rectangle)
frames = addTrackingInfo(frames, track, w, h);
    

%montage(frames)

%show profiler
if settings.prof == PROF.ON
    profile viewer
end

saveMovie(frames, 'result.avi', 10, 100,'None');



% todo herhistogrammen (bij min distance opnieuw histogram berekenen (regiondimensions aanpassen??))
% histogram gaussen, (midden belangrijker)
% lokatie voorspellen mean shift

% gaus op colorimportance en locatie
% learning rate
% remove repmat van locs2hists
