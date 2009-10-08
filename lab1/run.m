close all
clear all

%Some naming stuff, 
%Roi = region of interest (nemo)
%In  = input image 
%Out = output image
%imgXXX = image in rectangle form
%colXXX = image in column form
%backImgOut = backprojected Out image in rectangle form

%% Variables
% settings controling process flow
COLOR = struct('RGB', 0, 'XY', 1);
GETROI = struct('ON', 0, 'OFF', 1);
PROF = struct('ON', 0, 'OFF', 1);
settings = struct('color', COLOR.XY, 'getRoi', GETROI.OFF, 'prof', PROF.OFF, ...
    'imgIn', 1, 'imgOut', 2);

% other settings
image_files = str2mat('nemo1.jpg', 'nemo2.jpg');
image_dir = 'images';
if settings.color == COLOR.XY
    NBins = [16,16];
else
    NBins = [16,16,16];
end

%do profiling if needed
if settings.prof == PROF.ON
    profile on
end

%% Read images

%imgs = cell(1,size(image_files,1));
%for i=1:size(image_files, 1)
%    imgstr = strcat(image_dir,'/',image_files(i,:));
%    imgs(i)={im2double(imread(imgstr))};
%end
%img1 = cell2mat(imgs(1,1));
%img2 = cell2mat(imgs(1,2));

imgstr = strcat(image_dir,'/',image_files(settings.imgIn,:));
imgOrigIn = im2double(imread(imgstr));
imgstr = strcat(image_dir,'/',image_files(settings.imgOut,:));
imgOrigOut = im2double(imread(imgstr));


%% change colorspace
if settings.color == COLOR.XY
    % goto xy space
    imgIn = rgb2xy(imgOrigIn);
    imgOut = rgb2xy(imgOrigOut);
end
% set sizes we will use
[MIn, NIn, PIn] = size(imgIn);
[MOut, NOut, POut] = size(imgOut);


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
    x = 270;
    y = 130;
    w = 40;
    h = 40;
end


%nemo is region of interest
imgRoi = imgIn(y:y+h, x:x+w, :);
[MRoi, NRoi, PRoi] = size(imgRoi);
colRoi = reshape(imgRoi, [MRoi*NRoi, PRoi]);

%% get nemo histogram
colLocRoi = img2histloc(colRoi, NBins);
histRoi = locs2hists(colLocRoi, NBins);

%% histogram back projection on image 2
colOut = reshape(imgOut, [MOut*NOut, POut]);
colLocOut = img2histloc(colOut, NBins);

backImgOut = reshape(histRoi(colLocOut), [MOut,NOut]);

%% get sliding window histograms
imgLocOut = reshape(colLocOut,[MOut,NOut]);

% calculate distances
% this may be optimized by keeping partial counts
dists1 = myImageFilter(imgLocOut, [MRoi,NRoi], histRoi, NBins, 'BC');
dists2 = myImageFilter(imgLocOut, [MRoi,NRoi], histRoi, NBins, 'EU');
dists3 = myImageFilter(imgLocOut, [MRoi,NRoi], histRoi, NBins, 'HI');


%%show original, colorspaces, histogram regions as labels
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
Title('Original Output')
subplot(3,3,5);
imshow(imgTMPOut)
title('Colorspace converted')
subplot(3,3,6)
imshow(label2rgb(imgLocOut));
title('Labeled by Histogram bin')

%Region of Interest
subplot(3,3,7);
imshow(imgOrigIn(y:y+h, x:x+w, :));
Title('Original Region of Interes')
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
