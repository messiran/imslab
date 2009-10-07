function dist = histdists(Hs, method)
% histogram distance(Hs, method)
% every column is a histogram
% BC = 1 - Bhattacharyya distance
% EU = Euclidean distance, normalised to 1
% HI = 1- Histogram intersection

[M, numH] = size(Hs);
%normalise to be sure
Hs = Hs./repmat(sum(Hs), M, 1);

switch lower(method)
    case {'bc', 'bhattacharyya'}
        %disp('Bhattacharyya');
        aa = repmat(Hs, numH, 1);
        bb = reshape(Hs, M*numH, 1);
        bb = repmat(bb, 1, numH);
        dist = sqrt(aa.*bb);
        dist = reshape(dist, M, numH.^2);
        dist = 1 - reshape(sum(dist, 1), numH, numH);
    case {'eu', 'euclidean'}
        %disp('Euclidean');
        %(a-b)^2 = a^2+b^2-2ab
        aa = sum(Hs.*Hs);  
        ab = Hs'*Hs; 
        aa = repmat(aa, [size(aa,2), 1]);
        dist = sqrt( aa + aa' - 2*ab)/sqrt(2);
    case {'hi', 'intersection'}
        % the normalisation in denominator with min(num(H1), num(H2)) not
        % needed if histogram adds up to 1 I think
        %disp('Histogram intersection');
        aa = repmat(Hs, numH, 1);
        bb = reshape(Hs, M*numH, 1);
        bb = repmat(bb, 1, numH);
        dist = reshape(min(aa, bb), M, numH.^2);
        dist = 1 - reshape(sum(dist, 1), numH, numH);
    otherwise
        disp('Unknown method');
end
dist = full(dist);