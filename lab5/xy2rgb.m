%in xy image
%out rgb image, with full luminance
function imgOut = xy2rgb(imgIn)

% prepare transforms
C1 = makecform('xyl2xyz');
C2 = makecform('xyz2srgb');

% add luminance
[M, N, P] = size(imgIn);
imgIn(:,:,3) = ones(M,N);

% transform
imgIn = applycform(imgIn,C1);
imgOut = applycform(imgIn,C2);