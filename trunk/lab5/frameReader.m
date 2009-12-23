function frames = frameReader(settings)
    global framesGlobal;

    movieName = settings.movieName;

    %frames = framesGlobal;

    % load frames from workspace if it exists

    % if exist('framesGlobal')==1 && ~isempty(framesGlobal) 
    %     disp('loading frames from workspace');
    %     frames = framesGlobal;
    if(exist('frames.mat')==2 && settings.cache)
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
		frame = im2double(imread(sFile));
		% crop image
		frame = frame(settings.imageCropRange,settings.imageCropRange,:);
		% downsample
		frame = frame(1:settings.downSampleRate:end,1:settings.downSampleRate:end,:);
		frame = rgb2color(frame, settings);
		[m,n,p] = size(frame);

        frames = zeros([m, n, p, length(settings.frameRange)]);

		fprintf('progress %02.1f%%\n', 0);
        for i = 1:settings.skipFramesStepsize:length(settings.frameRange)
            fprintf('\b\b\b\b\b\b %4.1f%%', i/length(settings.frameRange) * 100);
            switch lower(movieName) 
                case {'voetbal'}
                    sFile = sprintf('framesVoetbal/Frame%04d.png',settings.frameRange(i));
                case{'snowboard'}
                    sFile = sprintf('framesSnowboard/%08d.png',settings.frameRange(i));
                case{'parachute'}
                    sFile = sprintf('framesParachute/%08d.png',settings.frameRange(i));
            end
			frame = im2double(imread(sFile));
			% crop image
			frame = frame(settings.imageCropRange,settings.imageCropRange,:);
			% downsample
			frame = frame(1:settings.downSampleRate:end,1:settings.downSampleRate:end,:);
            frame = rgb2color(frame, settings);
            frames(:,:,:,i) = frame;
        end
		disp('');
        disp('saving to frames.mat...');
        save frames.mat frames;
        disp('done');
    end

	disp('globalizing frames');
	framesGlobal = frames;

