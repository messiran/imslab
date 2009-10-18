function dists = histdists(Hs, Hss, method, normalise)
% HISTDISTS(HS, HSS, method) calculates the histogram distance between a 
% histogram HS and a series of histograms Hss according to method
% 
% DISTS = HISTDISTS(HS, HSS, METHOD)
% HS is a histogram represented as an column vector
% HSS is a series of histograms, every column is a histogram
% 
% METHOD: a string
% BC = Bhattacharyya distance
% EU = Euclidean distance, normalised to 1
% HI = 1 - Histogram intersection
% ALL = do all 3 distances 

[nbins, nHss] = size(Hss);

%normalise to be sure
%Hs = Hs./repmat(sum(Hs), nbins, 1);
%Hss = Hss./repmat(sum(Hss), nbins, 1);

% always used
Hs = repmat(Hs, 1, nHss);

method = lower(method);
switch method
    case {'bc', 'bhattacharyya', 'all'}
        %disp('Bhattacharyya');
        BC = sum(sqrt(Hs.*Hss));
        BCdists = sqrt(1-BC);
        dists = BCdists;
end
switch method
    case {'eu', 'euclidean', 'all'}
        %disp('Euclidean');
        EUdists = sqrt(sum((Hs-Hss).^2));
        dists = EUdists;
end
switch method
    case {'hi', 'intersection', 'all'}
        % the normalisation in denominator with min(num(H1), num(H2)) not
        % needed if histogram adds up to 1 I think
        %disp('Histogram intersection');
        HIdists = 1 - sum(min(Hs, Hss));
        dists = EUdists;
end
switch method
    case {'bp', 'backprojection', 'all'}
        %This is the same as taking 1 - the average of 
        %the histogram backprojection in an area
        %disp('Histogram backprojection average');
        BPdists = 1 - sum(Hs.*Hss);
        dists = BPdists;
end
switch method
    case {'all'}
        dists(:,:,1) = BCdists;
        dists(:,:,2) = EUdists;
        dists(:,:,3) = HIdists;
        dists(:,:,4) = BPdists;
end

switch lower(normalise)
    case {'normalise', 'normalize'}
        mx = max(dists);
        mn = min(dists);
        mx = repmat(mx, [1, nHss, 1]);
        mn = repmat(mn, [1, nHss, 1]);
        dists = (dists - mn)./(mx-mn);
end
        