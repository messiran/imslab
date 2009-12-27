function mask = getMask(rect, type)
%GETMASK get a "mask" of type
% MASK = GETMASK(RECT, TYPE)
% MASK = a [width+1*height+1*d] array
% RECT = a vector of length 4 with [x, y, width, height]
% TYPE = {epanechnikov, location}
% returns an epanechnikov kernel or a window with relative x,y locations
% reshaped as a 1 or 2 column vector.

w = rect(3);
h = rect(4);

switch lower(type)
    case {'epanechnikov', 'epa', 'epo', 'echni'}
        % 2D epanechnikov kernel
        % we use a square kernel where the corners are 1
        % K_E = 1/2 * (1/cd)*(d+2)*(1-||x||^2)
        % d = dimensions = 2
        % cd = number of data points
        % K_E = 1/2 * (1/cd)*(2+2)*(1-(sqrt(x^2+y^2))^2)
        % K_E = 2/cd *(1-(x^2+y^2))
        % 2/cd is a scaling which gets taken care of in normalisation
        % K_E = (1-(x^2+y^2))/(normalisation value)
        % return reshaped as a 1 column vector
        bound = sqrt(1/2);
        xRange = [-bound:2*bound/w:+bound];
        yRange = [-bound:2*bound/h:+bound];
        [X, Y] = meshgrid(xRange, yRange);
        
        mask = (1-(X.^2+Y.^2));
		mask(mask<0)=0;
        % normalise & reshape
        mask = reshape(mask/sum(sum(mask)), [1, (w+1)*(h+1)]);
    case {'location', 'loc'}
        % location return a 2 column reshaped meshgrid of size w+1, h+1
        % around zero(0,0).
        [X, Y] = meshgrid([-w/2:w/2], [-h/2:h/2]);
        mask = [reshape(X,[prod(size(X)),1]), reshape(Y,[prod(size(Y)),1])];
end