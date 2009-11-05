function hit = findHist(HsTemplate, imgSearch, window, colKernel)
% finds the wanted histogram, and gives back the locations

% globals
global COLOR settings
persistent colKernels


%% change colorspace
if settings.color == COLOR.XY
    % goto xy space
    imgSearch = rgb2xy(imgSearch);
end

[MSearch, NSearch, PSearch] = size(imgSearch);

%% prepare to calculate distanaces
% get sliding windows with bucket numbers
colSearch = reshape(imgSearch, [MSearch*NSearch, PSearch]);
colLocSearch = img2histloc(colSearch, settings.NBins);
imgLocSearch = reshape(colLocSearch,[MSearch,NSearch]);
colsLocSearch = im2col(imgLocSearch, [window(2), window(1)], 'sliding');

%% calculate distances

if isempty(colKernels)
   disp('init colkernels');
   colKernels = repmat(colKernel, [1, size(colsLocSearch,2)]); 
end

% this may be optimized by keeping partial counts
% count buckets, create histograms
histSearch = locs2hists(colsLocSearch, settings.NBins, colKernels);

% calculate distances
dists = histdists(HsTemplate, histSearch, 'bc', 'noNormalise');
dists = reshape(dists, [[settings.searchNbh]*2+1, size(dists, 3)]);

% find best matches
[minVal, yIndex] = min(dists);
[minVal, xIndex] = min(minVal);
yIndex = yIndex(xIndex);

hit = [xIndex, yIndex];