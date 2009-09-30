% nbins 2d [x, y] 
% img = (MxN) x2
% gives all images in a picture a number corresponding to a 3d histogram
% bin.
function R = img2histloc2D(img, nbins)

%imgSerialized = [img(:,1), img(:,:,2), img(:,:,3)]
x = floor( img(:,1)*(nbins(1)-1) ) + 1;
y = floor( img(:,2)*(nbins(2)-1) ) + 1;

R = x + (y-1)*nbins(1);

