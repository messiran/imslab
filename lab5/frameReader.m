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
		frame = rgb2color(im2double(imread(sFile)), settings);
		frame = frame(1:settings.downSampleRate:end,1:settings.downSampleRate:end,:);
		[m,n,p] = size(frame);

        frames = zeros([m, n, p, length(settings.frameRange)]);

		fprintf('progress %02.1f%%\n', 0);
        for i = 1:length(settings.frameRange)
            fprintf('\b\b\b\b\b\b %4.1f%%', i/length(settings.frameRange) * 100);
            switch lower(movieName) 
                case {'voetbal'}
                    sFile = sprintf('framesVoetbal/Frame%04d.png',settings.frameRange(i));
                case{'snowboard'}
                    sFile = sprintf('framesSnowboard/%08d.png',settings.frameRange(i));
                case{'parachute'}
                    sFile = sprintf('framesParachute/%08d.png',settings.frameRange(i));
            end
            frame = rgb2color(im2double(imread(sFile)), settings);
			% downsample
            frames(:,:,:,i) = frame(1:settings.downSampleRate:end,1:settings.downSampleRate:end,:);
        end
        disp('saving to frames.mat...');
        save frames.mat frames;
        disp('done');
    end

	disp('globalizing frames');
	framesGlobal = frames;

