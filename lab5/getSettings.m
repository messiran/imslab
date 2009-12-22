function settings = getSettings(inpColor, inpGetRoi)
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
    settings.frameRange = 85:285;
	settings.N = 16;
	settings.downSampleRate = 2;

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
