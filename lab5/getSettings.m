function settings = readSettings()
	global frames;
    %% Variables
    % settings controling process flow

    % declare settings vars
    settings = struct(  'COLOR', struct('RGB', 0, 'XY', 1, 'rg', 2, 'H', 3, 'HS', 4, 'HSV', 5),...
                        'GETROI', struct('ON', 0, 'OFF', 1),...
                        'PROF', struct('ON', 0, 'OFF', 1),...
                        'CACHE', struct('ON', true, 'OFF', false));
    
    % instantiate settings
    settings.color = settings.COLOR.H;
    settings.getRoi = settings.GETROI.ON;
    settings.prof = settings.PROF.OFF;
    settings.searchNbh = [20,20];
    settings.cache = settings.CACHE.ON;
    settings.defaultRoi = [575, 230, 10, 40];
    settings.frameRange = 3147:3180;

    % other settings
    if settings.color == settings.COLOR.XY
        settings.NBins = [16,16];
    else
        settings.NBins = [16,16,16];
        %settings.NBins = [2,2,2];
    end

    % do profiling if needed
    if settings.prof == settings.PROF.ON
		profile clear
        profile on
	else
		profile off
    end

	% load frames from workspace if it exists
	if exist('frames') == 1
		disp('loading frames from workspace');
		settings.frames = frames;
	else
		disp('loading frames from frames.mat');
		settings.frames = frameReader('snowboard', settings);
		frames = settings.frames;
	end	

end
