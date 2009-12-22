function settings = getSettings()
    %% Variables
    % settings controling process flow

    % declare settings vars
    settings = struct(  'COLOR', struct('RGB', 0, 'XY', 1, 'rg', 2, 'H', 3, 'HS', 4, 'HSV', 5),...
                        'GETROI', struct('ON', 0, 'OFF', 1),...
                        'PROF', struct('ON', 0, 'OFF', 1),...
                        'CACHE', struct('ON', true, 'OFF', false));
    
    % instantiate settings
    settings.color = settings.COLOR.RGB;
    settings.getRoi = settings.GETROI.ON;
    settings.prof = settings.PROF.OFF;
    settings.searchNbh = [20,20];
    settings.cache = settings.CACHE.ON;
    settings.defaultRoi = [575, 230, 10, 40];
	settings.movieName = 'snowboard';
    %settings.frameRange = 3147:3247;
    settings.frameRange = 8:40;
	settings.N = 16;

	switch(lower(settings.color))
		case {settings.COLOR.H}
			settings.NBins = settings.N;
		case {settings.COLOR.XY, settings.COLOR.rg, settings.COLOR.HS}
			settings.NBins = settings.N * ones(1,2);
		case {settings.COLOR.RGB, settings.COLOR.HSV}
			settings.NBins = settings.N * ones(1,3);
    end

    % do profiling if needed
    if settings.prof == settings.PROF.ON
		profile clear
        profile on
	else
		profile off
    end

	settings.frames = frameReader(settings);
