function settings = getSettings(inpColor, inpGetRoi, inpN)
    %% Variables
    % settings controling process flow

    % declare settings vars
    settings = struct(  'COLOR', struct('RGB', 0, 'XY', 1, 'rg', 2, 'H', 3, 'HS', 4, 'HSV', 5),...
                        'GETROI', struct('ON', 1, 'OFF', 0),...
                        'PROF', struct('ON', 0, 'OFF', 1),...
                        'CACHE', struct('ON', true, 'OFF', false));
    
    % instantiate settings
    %settings.color = settings.COLOR.RGB;
    settings.color = inpColor;
    settings.getRoi = inpGetRoi; 
    settings.prof = settings.PROF.OFF;
    settings.searchNbh = [20,20];
    settings.cache = settings.CACHE.ON;
    settings.defaultRoi = [575, 230, 10, 40];
	settings.movieName = 'voetbal';
    %settings.frameRange = 3147:3247;
    settings.frameRange = 85:139;
    %settings.frameRange = 85:115;
	settings.N = inpN;
	settings.downSampleRate = 2;
	settings.skipFramesStepsize = 1;
	settings.saveAndShowMovie = 0;
	settings.imageCropRange = 1:250;
	settings.TrackColor = [0, 0, 0]; % black

	switch(lower(settings.color))
		case {settings.COLOR.H}
			settings.NBins = settings.N;
		case {settings.COLOR.XY, settings.COLOR.rg, settings.COLOR.HS}
			settings.NBins = settings.N * ones(1,2);
		case {settings.COLOR.RGB, settings.COLOR.HSV}
			settings.NBins = settings.N * ones(1,3);
    end
    
    %% get region of interest
    if (settings.getRoi == settings.GETROI.ON && (exist('Roi.mat')~=2))
        handle = figure('Visible','off');
        imshow(color2rgb(imgT,settings));
        rect = getrect(handle);
        settings.Roi =  [floor(rect(1)),...
                floor(rect(2)),...
                floor(rect(3)),...
                floor(rect(4))];
        save('Roi.mat', 'Roi');
        close(handle);
    else 
        if (exist('Roi.mat')==2)
            load('Roi.mat');
            settings.Roi = Roi;
            % convert from downsampled to normal roi
            %Roi =  Roi * 2;
        else
            disp('loading default roi');
            settings.Roi = settings.defaultRoi;
        end
    end


    % do profiling if needed
    if settings.prof == settings.PROF.ON
		profile clear
        profile on
	else
		profile off
    end

	settings.frames = frameReader(settings);

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

		fprintf('progress %04.1f%%', 0);
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
		disp(' ');
        disp('saving to frames.mat...');
        save frames.mat frames;
        disp('done');
    end

	disp('globalizing frames');
	framesGlobal = frames;


