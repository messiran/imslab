function img = color2rgb(img, settings)
%COLOR2RGB Transform colorspace from one specified in settings to RGB.
% IMG = COLOR2RGB(IMG, SETTINGS)
% IMG(out) = RGB color image
% IMG(in)  = color image in colorspace specified in settings  
% SETTINGS = settings structure (see getSettings.m)  

persistent xyl2xyz xyz2srgb

%% change colorspace backto RGB
switch lower(settings.color)
    %case {settings.COLOR.RGB}   
    %   no conversion needed    
    
    case {settings.COLOR.rg}
        % b = 1-(r+g)
        img(:,:,3) = ones(size(img(:,:,1)))-sum(img,3);
     
    case {settings.COLOR.XY}
        % prepare transforms
        if isempty(xyl2xyz) || isempty(xyz2srgb)
            xyl2xyz = makecform('xyl2xyz');
            xyz2srgb = makecform('xyz2srgb');
        end
        
        %add luminance
        img(:,:,3)=ones(size(img(:,:,1)));
        
        % transform
        img = applycform(img,xyl2xyz);
        img = applycform(img,xyz2srgb);

    case {settings.COLOR.H}
        % add sv, transform to RGB
        img(:,:,2) = ones(size(img(:,:,1)));
        img(:,:,3) = img(:,:,2);
        img = hsv2rgb(img);
        
    case {settings.COLOR.HS}
        % add v, transform to RGB
        img(:,:,3) = ones(size(img(:,:,1)));
        img = hsv2rgb(img);
        
    case {settings.COLOR.HSV}
        % transform to RGB        
        img = hsv2rgb(img);

end
% transform image to uint8
img = uint8(round(img*255));