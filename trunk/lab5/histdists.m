function dists = histdists(Hs, Hss, method)
% HISTDISTS(HS, HSS, method) calculates the histogram distance between a 
% histogram HS and a series of histograms Hss according to method
% 
% DISTS = HISTDISTS(HS, HSS, METHOD)
% HS is a histogram represented as an column vector
% HSS is a series of histograms, every column is a histogram
% 
% METHOD: a string
% BC = 1 - Bhattacharyya distance
% EU = Euclidean distance, normalised to 1
% HI = 1- Histogram intersection

[nbins, nHss] = size(Hss);

%normalise to be sure
Hs = Hs./repmat(sum(Hs), nbins, 1);
Hss = Hss./repmat(sum(Hss), nbins, 1);

% always used
Hs = repmat(Hs, 1, nHss);

switch lower(method)
    case {'bc', 'bhattacharyya'}
        %disp('Bhattacharyya');
        BC = sum(sqrt(Hs.*Hss));
        dists = sqrt(1-BC);
    case {'eu', 'euclidean'}
        %disp('Euclidean');
        dists = sqrt(sum((Hs-Hss).^2));
    case {'hi', 'intersection'}
        % the normalisation in denominator with min(num(H1), num(H2)) not
        % needed if histogram adds up to 1 I think
        %disp('Histogram intersection');
        dists = -sum(min(Hs, Hss));
    otherwise
        disp('Unknown method');
end