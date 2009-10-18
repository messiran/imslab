function prettyPlots(imgOrigIn, imgOrigOut, imgOrigRoi, imgIn, imgOut, imgRoi, imgLocIn, imgLocOut, imgLocRoi, dists)
global COLOR GETROI PROF settings

[MIn, NIn, PIn] = size(imgIn);

% show original, colorspaces, histogram regions as labels



% show different colorspace image converted back
if settings.color == COLOR.XY
    imgTMPIn = xy2rgb(imgIn);
    imgTMPOut= xy2rgb(imgOut);
    imgTMPRoi = xy2rgb(imgRoi);
else
    imgTMPIn = imgIn;
    imgTMPOut = imgOut;
    imgTMPRoi = imgRoi;
end

figure
%Input
subplot(3,3,1);
imshow(imgOrigIn);
title('Original Input')
subplot(3,3,2);
imshow(imgTMPIn)
title('Colorspace converted')
subplot(3,3,3)
imshow(label2rgb(imgLocIn));
title('Labeled by Histogram bin')

%Output
subplot(3,3,4);
imshow(imgOrigOut);
title('Original Output')
subplot(3,3,5);
imshow(imgTMPOut)
title('Colorspace converted')
subplot(3,3,6)
imshow(label2rgb(imgLocOut));
title('Labeled by Histogram bin')

%Region of Interest
subplot(3,3,7);
imshow(imgOrigRoi);
title('Original Region of Interest')
subplot(3,3,8);
imshow(imgTMPRoi)
title('Colorspace converted')
subplot(3,3,9)
imshow(label2rgb(imgLocRoi));
title('Labeled by Histogram bin')

% show back projection & histogram distsances
figure
subplot(2,2,1)
imshow(dists(:,:,4), []);
title('Histogram backprojection')
subplot(2,2,2)
imshow(dists(:,:,1), [])
title('Bhattacharyya Distance')
subplot(2,2,3)
imshow(dists(:,:,2), [])
title('Euclidean Distance')
subplot(2,2,4)
imshow(dists(:,:,3), [])
title('Histogram Intersection')