function dist = locs2dist(locs, Hist, NBins, method)
%LOCS2DIST(LOCS, HIST, NBINS, METHOD) returns the distance of the histogram
%and the histogram defined by the locations in locs. 
%DIST = LOCS2DIST(LOCS, HIST, NBINS, METHOD) 
%DIST = distance between Hist and histogram defined by locs according to method
%HIST a histogram in 1 column
%LOC histogram locations, 1 histogram in 1 column
% METHOD: a string
% BC = 1 - Bhattacharyya distance
% EU = Euclidean distance, normalised to 1
% HI = 1- Histogram intersection

hist2 = locs2hists(locs, NBins);
dist = histdists(Hist, hist2, method);