function img = transformColor(img, settings)

%% change colorspace
if settings.color == settings.COLOR.XY
	% prepare transforms
	C1 = makecform('srgb2xyz');
	C2 = makecform('xyz2xyl');

	% transform
	img = applycform(img,C1);
	img = applycform(img,C2);

	%remove luminance
	img = img(:,:,1:2);
end

