close all
i=im2double(rgb2gray(imread('images/nemo1.jpg')));
h = figure
imshow(i);
% nbins = 10;
% figure;
% hist(i, nbins);
rect = getrect(h)

x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);

nemo = i(y:y+h, x:x+w);
figure
imshow(nemo)




