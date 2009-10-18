function frames = frameReader(method, dirty)


switch lower(method) 
    case {'voetbal'}
    numFrame = 85:96;
    if (exist('frames.mat')==2 & ~dirty)
        load frames.mat;
    else
        for i = 1:length(numFrame)
            sFile = sprintf('Frame%04d.png',numFrame(i));
            frames(:,:,:,i) = im2double(imread(strcat('frames/',sFile)));
            %figure; imshow(frames(:,:,:,i));
        end
        save frames.mat frames;
    end
end

