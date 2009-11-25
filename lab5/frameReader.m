function frames = frameReader(method, settings)


switch lower(method) 
    case {'voetbal'}
    if (exist('frames.mat')==2 & settings.cache)
        load frames.mat;
    else
        for i = 1:length(settings.frameRange)
            sFile = sprintf('Frame%04d.png',settings.frameRange(i));
            frames(:,:,:,i) = im2double(imread(strcat('frames/',sFile)));
            %figure; imshow(frames(:,:,:,i));
        end
        save frames.mat frames;
    end
end

