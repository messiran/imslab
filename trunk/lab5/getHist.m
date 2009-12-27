function [vectLoc, vectHist] = getHist(img, Roi, settings) 
%GETHIST get a weighted histogram of roi in img using settings and a
%indexed version of the roi in img, with the bin numbers in the histogram
% [VECTLOC, VECTHIST] = GETHIST(IMG, ROI, SETTINGS)
% VECTLOC = an indexed image reshaped to a column vector, of the ROI in IMG
%   where the index indicates the bin in the histogram 
% VECTHIST = a weighted histogram of ROI in IMG using SETTINGS
% IMG = an image.
% ROI = region of interest in image as [x, y, width, height]
% SETTINGS = settings structure (see getSettings.m)  

% setup persistent variables as to not recalculate the kernel
persistent wP hP vectKernelP

%unravel ROI variables
x = Roi(1); y = Roi(2); w = Roi(3); h = Roi(4);

% get weighting kernel for histogram counts, persistent if possible.
if(isempty(wP) || (w~=wP) || (h~=hP))
    wP = w;
    hP = h;
    vectKernelP = getMask(Roi, 'Epanechnikov');
end
vectKernel = vectKernelP;

% reshape the cropped region of interest to a standing vector
vectImg = reshape(img(y:y+h, x:x+w, :), [(h+1)*(w+1), size(img,3)]);

%% construct histogram
% get bin location
vectLoc = img2histloc(vectImg, settings.NBins);

% count buckets
vectHist = locs2hist(vectLoc, settings.NBins, vectKernel);

function hist = locs2hist(locs, NBins, colKernel)
%LOCS2HIST returns a weighted histogram represented as a column vector
% LOCS2HIST(LOCS, NBINS, COLKERNEL) 
% HIST column histogram
% LOCS histogram locations, an indexed image vector with bin locations
% NBINS number of bins per color dimension
% COLKERNEL weighting kernel for histogram

hist = full(sparse(locs, ones(1,length(locs)), colKernel, prod(NBins), 1));

