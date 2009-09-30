close all
clear all

img1=im2double(imread('images/nemo1.jpg'));
img2=im2double(imread('images/nemo2.jpg'));

% goto xy space
I_xyl1 = rgb2xy(img1);
I_xyl2 = rgb2xy(img2);

%show original
h = figure;
subplot(2,2,1);
imshow(img1);
img = I_xyl1;

%get region
rect = getrect(h)
x = floor(rect(1));
y = floor(rect(2));
w = floor(rect(3));
h = floor(rect(4));

% show xy image converted back
subplot(2,2,2);
imshow(xy2rgb(img));
       
% x = 249;
% y = 104;
% w = 62;
% h = 71;

nemo = img(y:y+h, x:x+w, :);
%figure
%imshow(img1(y:y+h, x:x+w, :))

[M, N, P] = size(nemo);
nemoReshaped = reshape(nemo, [M*N, P]);

NBins = [20, 20];

% get locks
locs = img2histloc2D(nemoReshaped, NBins);
% get counts
counts = full(sparse(locs, ones(M*N,1), ones(M*N,1), prod(NBins), 1));
p = counts/(M*N);



% save prob on corresponding index
img = I_xyl2;
[M, N, P] = size(img);
imgReshaped = reshape(img, [M*N, P]);

imgloc = img2histloc2D(imgReshaped, NBins);
result = p(imgloc);
result = reshape(result, [M,N]);

subplot(2,2,3)
imshow(img2)
subplot(2,2,4)
imgT = xy2rgb(img2)
imshow(imgT)
figure;
imshow(result,[]);

%show nemo
figure
imshow(img1(y:y+h, x:x+w, :))
