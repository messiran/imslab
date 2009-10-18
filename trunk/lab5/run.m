close all
clear

global COLOR GETROI PROF settings


numFrame = 85:88
% frame reader
%for iFrame=85:139

if (exist('frames.mat')==2)
    load frames.mat;
else
    frames = {};
    for iFrame = 1:length(numFrame)
        sFile = sprintf('Frame%04d.png',numFrame(iFrame));
        img = im2double(imread(strcat('frames/',sFile)));
        figure; imshow(img);
        frames{iFrame} = img;
    end
    save frames.mat frames;
end

if (exist('frames.mat')==2)
    load frames.mat;
else
    frames = {};
    for iFrame=85:88
        sFile = sprintf('Frame%04d.png',iFrame);
        img = im2double(imread(strcat('frames/',sFile)));
        figure; imshow(img);
        frames{iFrame} = img;

    end
    save frames.mat frames;
end

%% Variables
% settings controling process flow
COLOR = struct('RGB', 0, 'XY', 1);
GETROI = struct('ON', 0, 'OFF', 1);

PROF = struct('ON', 0, 'OFF', 1);
settings = struct('color', COLOR.RGB, 'getRoi', GETROI.OFF, 'prof', PROF.ON,'searchNbh', [5,5]);


% other settings
if settings.color == COLOR.XY
    NBins = [16,16];
else
    NBins = [16,16,16];
end

% do profiling if needed
if settings.prof == PROF.ON
    profile on
end

% temporary
imgOrigIn = frames(:,:,:,1);
imgOrigOut = frames(:,:,:,1);

%% change colorspace
if settings.color == COLOR.XY
    % goto xy space
    imgIn = rgb2xy(imgOrigIn);
    imgOut = rgb2xy(imgOrigOut);
else
    imgIn = imgOrigIn;
    imgOut = imgOrigOut;
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
    x = 568;
    y = 223;
    w = 20;
    h = 50;
end

% get region of interest
imgRoi = imgIn(y:y+h, x:x+w, :);
[MRoi, NRoi, PRoi] = size(imgRoi);
colRoi = reshape(imgRoi, [MRoi*NRoi, PRoi]);

% construct histogram
% get bin location
colLocRoi = img2histloc(colRoi, NBins);
% count buckets
histRoi = locs2hists(colLocRoi, NBins);

% crop imageout to define search area
searchx = x-settings.searchNbh(1);
searchy = y-settings.searchNbh(2);
searchw = 2*settings.searchNbh(1)+w;
searchh = 2*settings.searchNbh(2)+h;

imgOut = imgOut(searchy:searchy+searchh, searchx:searchx+searchw, :);
[MOut, NOut, POut] = size(imgOut);

% imshow(imgRoi);
% pause;
% figure;
% imshow(imgSearch);


% histogram back projection 
colOut = reshape(imgOut, [MOut*NOut, POut]);
colLocOut = img2histloc(colOut, NBins);
backImgOut = reshape(histRoi(colLocOut), [MOut,NOut]);
colsbackOut = im2col(backImgOut, [h, w]+1, 'sliding');
dist = mean(colsbackOut);
dist = reshape(dist, [[settings.searchNbh]*2+1]);



% get sliding window histograms
imgLocOut = reshape(colLocOut,[MOut,NOut]);

%% calculate distances
% this may be optimized by keeping partial counts

imgLocOut = reshape(colLocOut, [MOut, NOut]);
colsLocOut = im2col(imgLocOut, [h, w]+1, 'sliding');
% count buckets
histOut = locs2hists(colsLocOut, NBins);

dists = histdists(histRoi, histOut, 'all', 'normalise');
dists = reshape(dists, [[settings.searchNbh]*2+1, 4]);

dists1 = dists(:,:,1);
dists2 = dists(:,:,2);
dists3 = dists(:,:,3);

test = 1-dist - dists(:,:,4)
test = sum(sum(test))<=0.0000001

%[iMax, iIndex] = max(reshape(dists1,[1,size(dist1,1)*size(dists1,2)]))

[Min1, yIndex1] = min(dists1);
[Min1, xIndex1] = min(Min1);
yIndex1 = yIndex1(xIndex1);

[Min2, yIndex2] = min(dists2);
[Min2, xIndex2] = min(Min2);
yIndex2 = yIndex2(xIndex2);

[Min3, yIndex3] = min(dists3);
[Min3, xIndex3] = min(Min3);
yIndex3 = yIndex3(xIndex3);

%xIndex1 
%yIndex1
%xIndex2 
%yIndex2
%xIndex3 
%yIndex3



% label original image using histogram bins as labels
colIn = reshape(imgIn, [MIn*NIn, PIn]);
colLocIn = img2histloc(colIn, NBins);
imgLocIn = reshape(colLocIn,[MIn, NIn]);
% reshape labeled ROI
imgLocRoi = reshape(colLocRoi,[MRoi, NRoi]);
imgOrigRoi = imgOrigIn(y:y+h, x:x+w, :);
%print everything
prettyPlots(imgOrigIn, imgOrigOut, imgOrigRoi, imgIn, imgOut, imgRoi, imgLocIn, imgLocOut, imgLocRoi, dists)




%show profiler
if settings.prof == PROF.ON
    profile viewer
end



% todo herhistogrammen (bij min distance opnieuw histogram berekenen (regiondimensions aanpassen??))
% histogram gaussen, (midden belangrijker)
% lokatie voorspellen mean shift
