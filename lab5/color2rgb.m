function img = color2rgb(img, settings)

%% change colorspace backto RGB
switch lower(settings.color)
    %case {settings.COLOR.RGB}
    
    case {settings.COLOR.rg}
        img(:,:,3) = ones(size(img(:,:,1)))-sum(img,3);
     
    case {settings.COLOR.XY}
        % prepare transforms
        C1 = makecform('xyl2xyz');
        C2 = makecform('xyz2srgb');

        %add luminance
        img(:,:,3)=ones(size(img(:,:,1)));
        
        % transform
        img = applycform(img,C1);
        img = applycform(img,C2);

    case {settings.COLOR.H}
        img(:,:,2) = ones(size(img(:,:,1)));
        img(:,:,3) = img(:,:,2);
        img = hsv2rgb(img);
        
    case {settings.COLOR.HS}
        img(:,:,3) = ones(size(img(:,:,1)));
        img = hsv2rgb(img);
        
    case {settings.COLOR.HSV}
        img = hsv2rgb(img);
end

