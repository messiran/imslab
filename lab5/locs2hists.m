function hists = locs2hists(locs, NBins, colKernels)
%LOCS2HISTS(LOCS, NBINS, COLKERNELS) returns columns with histogram locations into a column
%histogram 
%HISTS column histograms
%LOCS histogram locations, 1 histogram per column
%NBINS number of bins per color dimension
%COLKERNEL weighting kernel for historgram
% MEMORY PROBLEMS IF USED ON A WHOLE IMAGE 
[M, N] = size(locs);

%colKernels = repmat(colKernel, [1, N]);
hists = full(sparse(locs, meshgrid(1:N,1:M), colKernels, prod(NBins), N));
%hists = counts./M;
%normalisation not needed if the kernels sum to 1