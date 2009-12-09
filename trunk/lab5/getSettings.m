function settings = readSettings()
    %% Variables
    % settings controling process flow

    % declare settings vars
    settings = struct(  'COLOR', struct('RGB', 0, 'XY', 1),...
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
    settings.frameRange = 85:139;

    % other settings
    if settings.color == settings.COLOR.XY
        settings.NBins = [16,16];
    else
        settings.NBins = [16,16,16];
        %settings.NBins = [2,2,2];
    end

    % do profiling if needed
    if settings.prof == settings.PROF.ON
        profile on
	else
		profile off
    end
end