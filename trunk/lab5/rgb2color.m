function img = rgb2color(img, settings)

%% change colorspace
switch lower(settings.color)
    %case {settings.COLOR.RGB}
    
    case {settings.COLOR.rg}
        R = img(:,:,1);
        G = img(:,:,2);
        r = ones(size(img(:,:,1))) * 1/3;
        g = r;
        
        norm = sum(img,3);
        mask = norm > 0;
        r(mask) = R(mask)./norm(mask);
        g(mask) = G(mask)./norm(mask);
      
        img = cat(3,r,g);
        
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

