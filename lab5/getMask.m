function mask = getMask(dims, rect, type)

x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);

center = [x+w/2, y+h/2];
width = [w/2, h/2];

switch lower(type)
    case {'border'}
        mask = logical(zeros(dims));
        mask(y,     x:x+w, :)=1;
        mask(y+h,   x:x+w, :)=1;
        mask(y:y+h, x    , :)=1;
        mask(y:y+h, x+w  , :)=1;
    case {'ellipse'}
        [X,Y] = meshgrid(1:dims(2), 1:dims(1));
        %squared widths
        sqwidth = width.^2;

        % Ellipse mask with origin (rectx,recty) with major axis parralel
        % to x
        mask = ((X - center(1)).^2 / sqwidth(1)) + ((Y - center(2)).^2 / sqwidth(2)) <= 1;
        mask = repmat(mask, [1,1,dims(3)]);
    case {'uniform'}
        mask = ones(h+1,w+1);
        mask = mask/sum(sum(mask));
    case {'epanechnikov', 'epa', 'epo', 'echni'}
        % K_E = 0.5 * (1/cd)*(d+2)*(1-||x||^2)
        % d = 2
        % cd = number of data points
        % d = dimensions
        bound = sqrt(1/2);
        xRange = [-bound:2*bound/w:+bound];
        yRange = [-bound:2*bound/h:+bound];
        [X, Y] = meshgrid(xRange, yRange);
        XYeuclDist = X.^2+Y.^2;
        
        cd = (w+1)*(h+1);
		
        mask = (2/cd)*(1-XYeuclDist);
		mask(mask<0)=0;
        %normalise
        mask = mask/sum(sum(mask));
    case {'location', 'loc', 'xi','lok', 'lock', 'lokc'}
        xRange = [-w/2:w/2];
        yRange = [-h/2:h/2];
        [X, Y] = meshgrid(xRange, yRange);
        mask = [reshape(X,[prod(size(X)),1]), reshape(Y,[prod(size(Y)),1])];

end
