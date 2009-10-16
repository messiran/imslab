function hists = locs2hists(locs, NBins)
%LOCS2HISTS(LOCS) returns columns with histogram locations into a column
%histogram
%HISTS = LOCS2HISTS(LOCS) 
%HISTS column histograms
%LOC histogram locations, 1 histogram per column
%NBINS number of bins per color dimension
% MEMORY PROBLEMS IF USED ON A WHOLE IMAGE 
[M, N] = size(locs);

counts = full(sparse(locs, meshgrid(1:N,1:M), ones(M,N), prod(NBins), N));
hists = counts./M;