% nbins 3d [r, g, b] 
% img = (MxN) xd 
function R = img2hist(img, nbins)

%imgSerialized = [img(:,1), img(:,:,2), img(:,:,3)]
x = floor( img(:,1)*(nbins(1)-1) ) + 1;
y = floor( img(:,2)*(nbins(2)-1) ) + 1;
z = floor( img(:,3)*(nbins(3)-1) ) + 1;

R = x + (y-1)*nbins(1) + (z-1)*nbins(1)*nbins(2);

