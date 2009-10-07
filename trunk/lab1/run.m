close all
clear all

%% Variables

image_files = str2mat('nemo1.jpg', 'nemo2.jpg');
image_dir = 'images';
NBins = [20, 20, 20];



%% Read images

imgs = cell(1,size(image_files,1));
for i=1:size(image_files, 1)
    imgstr = strcat(image_dir,'/',image_files(i,:));
    imgs(i)={im2double(imread(imgstr))};
end

img1 = cell2mat(imgs(1,1));
img2 = cell2mat(imgs(1,2));
% goto xy space
%I_xyl1 = rgb2xy(img1);
%I_xyl2 = rgb2xy(img2);

%show original
h = figure;
subplot(2,2,1);
imshow(img1);
img = img1;
%img = I_xyl1;

%get region
rect = getrect(h)
x = floor(rect(1));
y = floor(rect(2));
w = floor(rect(3));
h = floor(rect(4));

% show xy image converted back
subplot(2,2,2);
imshow(img);
       
% x = 249;
% y = 104;
% w = 62;
% h = 71;

nemo = img(y:y+h, x:x+w, :);
%figure
%imshow(img1(y:y+h, x:x+w, :))

[M, N, P] = size(nemo);
nemoReshaped = reshape(nemo, [M*N, P]);



% get locks
%locs = img2histloc2D(nemoReshaped, NBins);
locs = img2histloc(nemoReshaped, NBins);
% get counts
counts = full(sparse(locs, ones(M*N,1), ones(M*N,1), prod(NBins), 1));
p = counts/(M*N);



% save prob on corresponding index
%img = I_xyl2;

%img = img2;
[M, N, P] = size(img);
imgReshaped = reshape(img, [M*N, P]);

%imgloc = img2histloc2D(imgReshaped, NBins);
imgloc = img2histloc(imgReshaped, NBins);

result = p(imgloc);
result = reshape(result, [M,N]);
%%
subplot(2,2,3)
imshow(img2)
subplot(2,2,4)
%imgT = xy2rgb(img2)
imshow(img2)
figure;
imshow(result,[]);

%show nemo
figure
imshow(img1(y:y+h, x:x+w, :))
