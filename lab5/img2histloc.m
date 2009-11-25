% nbins 3d [r, g, b] 
% img = (MxN) xd
% gives all images in a picture a number corresponding to a 3d histogram
% bin.
function histloc = img2histloc(img, nbins)
%IMG2HISTLOC(img, nbins) Transform an image into an image with at each
%pixel location a direct index into a histogram with nbins.
% 
% histloc = IMG2HISTLOC(img, nbins)
% img, an image with 1,2 or 3 color dimensions
% nbins, a vector specifying the number of bins in each color dimension
%        it should have the same dimensions as the image has color dimensions


%init variables
x=0; y=0; z=0;
P = size(img,2);


% make nbins same dimension as colorspace in image
%if length(nbins) == 1
%    nbins = nbins * ones(1, P);
%end

% always calculate x
x = floor( img(:,1)*(nbins(1)-1) ) + 1;

% only y if dimensions >= 2
if P >= 2
    y = (floor( img(:,2)*(nbins(2)-1) ))*nbins(1);
end

% only y if dimensions == 3

if P == 3
    z = (floor( img(:,3)*(nbins(3)-1) ))*nbins(1)*nbins(2);
end
histloc = x + y + z;

