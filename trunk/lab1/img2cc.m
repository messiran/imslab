function r = img2cc(img)
%img2cc converts an image to its connected component image
%   IMSHOW(img) displays the connected component image.
%   
%   arguments:
%   img: a rgb unnormalized image, example imread('rice.png');
%

close all;
%figure; imshow(img); pause;

% calculate background using a opening
imgBg = imopen(img, strel('disk', 15));

%figure; imshow(imgBg); pause;

% remove noisy background
img2 = img - imgBg;

figure; imshow(img2); pause;

% adjust intensity
img3 = imadjust(img2);
figure; imshow(img3); pause;

% threshold img and transform to binary
level = graythresh(img3);
img4 = im2bw(img3,level);
figure; imshow(img4); pause;

% remove noise by applying the morphological opening
img5 = bwareaopen(img4, 50);
figure; imshow(img5); pause;

% calculate connected components
cc = bwconncomp(img5, 4);

labeled = labelmatrix(cc)


% % loop through connected components
% for i=1:size(cc.PixelIdxList,2)
%     % initialize with zeros
%     i
%     result = false(size(img5));
%     result(cc.PixelIdxList{i}) = true;
%     figure; imshow(result); pause;
% end

% retrieve properties
ccRegionprops = regionprops(cc, 'basic');
% retreive areavalues of regionprop
ccAreas = [ccRegionprops.Area]
% retrieve max area with corresponding index
[maxArea, maxAreaIdx] = max(ccAreas);

% draw
result = false(size(img5));
result(cc.PixelIdxList{maxAreaIdx}) = true;
figure; imshow(result); pause;

img6 = rgb2gray(imread('images/nemo1.jpg'))
img6(result==0)=0;
figure; imshow(img6); pause;


% todo imfill


% RGB_label = label2rgb(labeled, @spring, 'c', 'shuffle');
% figure; imshow(RGB_label); pause;



