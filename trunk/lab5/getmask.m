function mask = getmask(dims, rect, type)

x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);

center = [x+w/2, y+h/2];
width = [w/2, h/2];
[X,Y] = meshgrid(1:dims(2), 1:dims(1));
switch lower(type)
    case {'border'}
        mask = logical(zeros(dims));
        mask(y,     x:x+w, :)=1;
        mask(y+h,   x:x+w, :)=1;
        mask(y:y+h, x    , :)=1;
        mask(y:y+h, x+w  , :)=1;
    case {'ellipse'}
        %squared widths
        sqwidth = width.^2;

        % Ellipse mask with origin (rectx,recty) with major axis parralel
        % to x
        mask = ((X - center(1)).^2 / sqwidth(1)) + ((Y - center(2)).^2 / sqwidth(2)) <= 1;
        mask = repmat(mask, [1,1,dims(3)]);
    case {'uniform'}
        mask = logical(ones(RC(1), RC(2)));
end
