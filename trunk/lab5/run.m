close all
clear

% frame reader
%for iFrame=85:139

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
settings = struct('color', COLOR.RGB, 'getRoi', GETROI.OFF, 'prof', PROF.ON,'searchNbh', [20,20]);

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
imgOrigIn = frames{85};
imgOrigOut = frames{85};

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
imgOut = imgOut(y-settings.searchNbh(2):y+settings.searchNbh(2)+h, x-settings.searchNbh(1):x+settings.searchNbh(1)+w, :);
[MOut, NOut, POut] = size(imgOut);

% imshow(imgRoi);
% pause;
% figure;
% imshow(imgSearch);


% histogram back projection 
colOut = reshape(imgOut, [MOut*NOut, POut]);
colLocOut = img2histloc(colOut, NBins);
backImgOut = reshape(histRoi(colLocOut), [MOut,NOut]);

% get sliding window histograms
imgLocOut = reshape(colLocOut,[MOut,NOut]);

% calculate distances
% this may be optimized by keeping partial counts
dists1 = myImageFilter(imgLocOut, [MRoi,NRoi], histRoi, NBins, 'BC');
dists2 = myImageFilter(imgLocOut, [MRoi,NRoi], histRoi, NBins, 'EU');
dists3 = myImageFilter(imgLocOut, [MRoi,NRoi], histRoi, NBins, 'HI');



%[iMax, iIndex] = max(reshape(dists1,[1,size(dist1,1)*size(dists1,2)]))

[yMax, yIndex] = min(dists1)
[xMax, xIndex] = min(min(dists1))
yIndex = yIndex(xIndex);



% show original, colorspaces, histogram regions as labels
% label original image using histogram bins as labels
colIn = reshape(imgIn, [MIn*NIn, PIn]);
colLocIn = img2histloc(colIn, NBins);
imgLocIn = reshape(colLocIn,[MIn, NIn]);
% reshape labeled ROI
imgLocRoi = reshape(colLocRoi,[MRoi, NRoi]);

% show different colorspace image converted back
if settings.color == COLOR.XY
    imgTMPIn = xy2rgb(imgIn);
    imgTMPOut= xy2rgb(imgOut);
    imgTMPRoi = xy2rgb(imgRoi);
else
    imgTMPIn = imgIn;
    imgTMPOut = imgOut;
    imgTMPRoi = imgRoi;
end

figure
%Input
subplot(3,3,1);
imshow(imgOrigIn);
title('Original Input')
subplot(3,3,2);
imshow(imgTMPIn)
title('Colorspace converted')
subplot(3,3,3)
imshow(label2rgb(imgLocIn));
title('Labeled by Histogram bin')

%Output
subplot(3,3,4);
imshow(imgOrigOut);
title('Original Output')
subplot(3,3,5);
imshow(imgTMPOut)
title('Colorspace converted')
subplot(3,3,6)
imshow(label2rgb(imgLocOut));
title('Labeled by Histogram bin')

%Region of Interest
subplot(3,3,7);
imshow(imgOrigIn(y:y+h, x:x+w, :));
title('Original Region of Interest')
subplot(3,3,8);
imshow(imgTMPRoi)
title('Colorspace converted')
subplot(3,3,9)
imshow(label2rgb(imgLocRoi));
title('Labeled by Histogram bin')

% show back projection & histogram distsances
figure
subplot(2,2,1)
imshow(backImgOut,[]);
title('Histogram backprojection')
subplot(2,2,2)
imshow(dists1)
title('Bhattacharyya Distance')
subplot(2,2,3)
imshow(dists2)
title('Euclidean Distance')
subplot(2,2,4)
imshow(dists3)
title('Histogram Intersection')

%show profiler
if settings.prof == PROF.ON
    profile viewer
end



% todo herhistogrammen (bij min distance opnieuw histogram berekenen (regiondimensions aanpassen??))
% histogram gaussen, (midden belangrijker)
% lokatie voorspellen mean shift
