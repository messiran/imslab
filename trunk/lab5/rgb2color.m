function img = rgb2color(img, settings)
%RGB2COLOR Transform colorspace from RGB to one specified in settings.
% IMG = RGB2COLOR(IMG, SETTINGS)
% IMG(out) = color image in colorspace specified in settings  
% IMG(in)  = RGB color image
% SETTINGS = settings structure (see getSettings.m)  

persistent srgb2xyz xyz2xyl

%% change colorspace
switch lower(settings.color)
    %case {settings.COLOR.RGB}
    %   no conversion needed
    
    case {settings.COLOR.rg}
        % prepare variables
        R = img(:,:,1);
        G = img(:,:,2);
        r = ones(size(img(:,:,1))) * 1/3;
        g = r;
        
        % calculate normalised rgb
        norm = sum(img,3);
        mask = norm > 0;
        r(mask) = R(mask)./norm(mask);
        g(mask) = G(mask)./norm(mask);
      
        % put all variables in 1 image
        img = cat(3,r,g);
        
    case {settings.COLOR.XY}
        % prepare transforms
        if isempty(srgb2xyz) || isempty(xyz2xyl)
            srgb2xyz = makecform('srgb2xyz');
            xyz2xyl = makecform('xyz2xyl');
        end
        
        % transform
        img = applycform(img,srgb2xyz);
        img = applycform(img,xyz2xyl);

        %remove luminance
        img = img(:,:,1:2);
    
    case {settings.COLOR.H}
        % transform to hsv, remove sv
        img = rgb2hsv(img);
        img = img(:,:,1);
        
    case {settings.COLOR.HS}
        % transform to hsv, remove v
        img = rgb2hsv(img);
        img = img(:,:,1:2);
    
    case {settings.COLOR.HSV}
        % transform to hsv
        img = rgb2hsv(img);
end