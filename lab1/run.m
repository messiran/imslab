close all
clear all

img1=im2double(imread('images/nemo1.jpg'));
img2=im2double(imread('images/nemo2.jpg'));

C1 = makecform('srgb2xyz');
C2 = makecform('xyz2xyl');
C3 = makecform('xyl2xyz');
C4 = makecform('xyz2srgb');

I_xyz1 = applycform(img1,C1);
I_xyl1 = applycform(I_xyz1,C2);
[M, N, P] = size(I_xyl1);
I_xyl1(:,:,3) = ones(M, N);

I_xyz2 = applycform(img2,C1);
I_xyl2 = applycform(I_xyz2,C2);
[M, N, P] = size(I_xyl2);
I_xyl2(:,:,3) = ones(M, N);

I_xyz1 = applycform(I_xyl1,C3);
I_rgb1 = applycform(I_xyz1,C4);
 
%imshow(I_rgb1)

h = figure;
subplot(2,2,1);
imshow(img1);
img = I_xyl1;


rect = getrect(h)
x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);

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

NBins = [20, 20, 1];
locs = img2histloc(nemoReshaped, NBins);

counts = full(sparse(locs, ones(M*N,1), ones(M*N,1), prod(NBins), 1));
p = counts/(M*N);



% save prob on corresponding index
img = I_xyl2;
[M, N, P] = size(img);
imgReshaped = reshape(img, [M*N, P]);

imgloc = img2histloc(imgReshaped, NBins);
result = p(imgloc);
result = reshape(result, [M,N]);

subplot(2,2,3)
imshow(img2)
subplot(2,2,4)
imshow(img)
figure;
imshow(result,[]);

%show nemo
figure
imshow(img1(y:y+h, x:x+w, :))
