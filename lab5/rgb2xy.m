%in rgb image
%out xy image
function imgOut = rgb2xy(imgIn)

% prepare transforms
C1 = makecform('srgb2xyz');
C2 = makecform('xyz2xyl');

% transform
imgIn = applycform(imgIn,C1);
imgIn = applycform(imgIn,C2);

%remove luminance
imgOut = imgIn(:,:,1:2);

