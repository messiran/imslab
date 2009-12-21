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
			% 223
			sFile = sprintf('framesSnowboard/%08d.png',settings.frameRange(1))
	end

	% declare frames for optimization
	frames = zeros([size(imread(sFile)),length(settings.frameRange)]);

	for i = 1:length(settings.frameRange)
		switch lower(method) 
			case {'voetbal'}
				sFile = sprintf('framesVoetbal/Frame%04d.png',settings.frameRange(i));
			case{'snowboard'}
				% 223
				sFile = sprintf('framesSnowboard/%08d.png',settings.frameRange(i))
		end
		frames(:,:,:,i) = im2double(imread(sFile));
	end
	save frames.mat frames;
end

