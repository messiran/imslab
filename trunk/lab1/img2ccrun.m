close all
clear

load outp.mat
%imshow(result,[]);

% normalize
result = result/max(max(result));


img2cc(result);

% img = imread('rice.png');
% img2cc(img);

