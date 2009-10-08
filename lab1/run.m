close all
clear all

%% Variables
% settings controling process flow
COLOR = struct('RGB', 0, 'XY', 1);
GETNEMO = struct('ON', 0, 'OFF', 1);
PROF = struct('ON', 0, 'OFF', 1);
settings = struct('color', COLOR.XY, 'getNemo', GETNEMO.OFF, 'prof', PROF.OFF);

% other settings
image_files = str2mat('nemo1.jpg', 'nemo2.jpg');
image_dir = 'images';
NBins = [16,16];

%do profiling if needed
if settings.prof == PROF.ON
    profile on
end

%% Read images

imgs = cell(1,size(image_files,1));
for i=1:size(image_files, 1)
    imgstr = strcat(image_dir,'/',image_files(i,:));
    imgs(i)={im2double(imread(imgstr))};
end

img1 = cell2mat(imgs(1,1));
img2 = cell2mat(imgs(1,2));

%% change colorspace
if settings.color == COLOR.XY
    % goto xy space
    I_xyl1 = rgb2xy(img1);
    I_xyl2 = rgb2xy(img2);
    img = I_xyl1;
else
    img = img1;
end
%% show original
h = figure;
subplot(2,2,1);
imshow(img1);
% show xy image converted back
if settings.color == COLOR.XY

    imgS = xy2rgb(img);
else
    imgS = img;
end

subplot(2,2,2);

imshow(imgS)

%% get region & show
if settings.getNemo == GETNEMO.ON
    rect = getrect(h);
    x = floor(rect(1));
    y = floor(rect(2));
    w = floor(rect(3));
    h = floor(rect(4));
else
    x = 249;
    y = 104;
    w = 62;
    h = 71;
end

nemo = img(y:y+h, x:x+w, :);
[M, N, P] = size(nemo);
nemoReshaped = reshape(nemo, [M*N, P]);

%% get nemo histogram
%locs = img2histloc2D(nemoReshaped, NBins);
locs = img2histloc(nemoReshaped, NBins);

hist = locs2hists(locs, NBins);
% get counts
%counts = full(sparse(locs, ones(M*N,1), ones(M*N,1), prod(NBins), 1));
%p = counts/(M*N);

%% hist back projection

% save prob on corresponding index
%img = I_xyl2; 

%img = img2;
[M, N, P] = size(img);
[MM, NN, PP] = size(img);
imgReshaped = reshape(img, [M*N, P]);

%imgloc = img2histloc2D(imgReshaped, NBins);
imgloc = img2histloc(imgReshaped, NBins);

result = hist(imgloc);
result = reshape(result, [M,N]);

%% get sliding window histograms
[M, N, P] = size(nemo);
imgloc = reshape(imgloc,[MM,NN]);

% calculate distances
% this may be optimized by keeping partial counts
dists1 = myImageFilter(imgloc, [M,N], hist, NBins, 'BC');
dists2 = myImageFilter(imgloc, [M,N], hist, NBins, 'EU');
dists3 = myImageFilter(imgloc, [M,N], hist, NBins, 'HI');

%% plot
subplot(2,2,3)
imshow(img2)
subplot(2,2,4)

if settings.color == COLOR.XY
    imgT = xy2rgb(img2);
else
    imgT = img2;
end
imshow(imgT)

figure;
imshow(result,[]);

%show nemo
figure
imshow(img1(y:y+h, x:x+w, :))

% show dists
figure
subplot(1,3,1)
imshow(dists1)
subplot(1,3,2)
imshow(dists2)
subplot(1,3,3)
imshow(dists3)
%show profiler
if settings.prof == PROF.ON
    profile viewer
end
