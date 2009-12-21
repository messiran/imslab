function img = transformColor(img, settings)

%% change colorspace
switch lower(settings.color)
    %case {settings.COLOR.RGB}
    
    case {settings.COLOR.rg}   
        r = ones(size(img(:,:,1))) * 1/3;
        g = r;
        
        norm = sum(img,3);
        mask = norm > 0;
        r(mask) = img(:,:,1)./norm;
        g(mask) = img(:,:,2)./norm;
        img(:,:,1) = r;
        img(:,:,2) = g;
        
    case {settings.COLOR.XY}
        % prepare transforms
        C1 = makecform('srgb2xyz');
        C2 = makecform('xyz2xyl');

        % transform
        img = applycform(img,C1);
        img = applycform(img,C2);

        %remove luminance
        img = img(:,:,1:2);
    case {settings.COLOR.H}
        img = rgb2hsv(img);
        img = img(:,:,1);
        
    case {settings.COLOR.HS}
        img = rgb2hsv(img);
        img = img(:,:,1:2);
    
    case {settings.COLOR.HSV}
        img = rgb2hsv(img);
end

