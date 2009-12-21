function frames = frameReader(method, settings)

if (exist('frames.mat')==2 & settings.cache)
	disp('loading frames.mat');
	load frames.mat;
	disp('done loading frames.mat');
else
	switch lower(method) 
		case {'voetbal'}
			sFile = sprintf('framesVoetbal/Frame%04d.png',settings.frameRange(1));
		case{'snowboard'}
			sFile = sprintf('framesSnowboard/%08d.png',settings.frameRange(1))
		case {'parachute'}
			sFile = sprintf('framesParachute/Frame%04d.png',settings.frameRange(1));
	end

	% declare frames for optimization
	frames = zeros([size(rgb2color(im2double(imread(sFile))), settings),length(settings.frameRange)]);

	for i = 1:length(settings.frameRange)
		switch lower(method) 
			case {'voetbal'}
				sFile = sprintf('framesVoetbal/Frame%04d.png',settings.frameRange(i));
			case{'snowboard'}
				sFile = sprintf('framesSnowboard/%08d.png',settings.frameRange(i))
			case{'parachute'}
				sFile = sprintf('framesParachute/%08d.png',settings.frameRange(i))
		end
		frames(:,:,:,i) = rgb2color(im2double(imread(sFile)), settings);
	end
	save frames.mat frames;
end

