function frames = frameReader(settings)
    global framesGlobal;

    movieName = settings.movieName;

    %frames = framesGlobal;

    % load frames from workspace if it exists
    if exist('framesGlobal')==1 && ~isempty(framesGlobal) 
        disp('loading frames from workspace');
        frames = framesGlobal;
    elseif(exist('frames.mat')==2 && settings.cache)
        disp('loading frames.mat');
        load frames.mat;
        disp('done loading frames.mat');
    else
        disp('loading frames from png');
        switch lower(movieName) 
            case {'voetbal'}
                sFile = sprintf('framesVoetbal/Frame%04d.png',settings.frameRange(1));
            case{'snowboard'}
                sFile = sprintf('framesSnowboard/%08d.png',settings.frameRange(1));
            case {'parachute'}
                sFile = sprintf('framesParachute/%08d.png',settings.frameRange(1));
        end

        % declare frames for optimization
        [m,n,p] = size( rgb2color(im2double(imread(sFile)), settings));
        frames = zeros([m, n, p, length(settings.frameRange)]);

        size(frames)
        for i = 1:length(settings.frameRange)
            i
            switch lower(movieName) 
                case {'voetbal'}
                    sFile = sprintf('framesVoetbal/%08d.png',settings.frameRange(i));
                case{'snowboard'}
                    sFile = sprintf('framesSnowboard/%08d.png',settings.frameRange(i));
                case{'parachute'}
                    sFile = sprintf('framesParachute/%08d.png',settings.frameRange(i));
            end
            frames(:,:,:,i) = rgb2color( im2double(imread(sFile)), settings);
        end
        disp('saving to frames.mat...');
        save frames.mat frames;
        disp('done');
    end


