function settings = getSettings(varargin)
%GETSETTINGS initialises all needed setting including reading all frames
% SETTINGS = GETSETTINGS(varargin)
% SETTINGS = a struct with all needed settings for the meanshift tracker
% varargin = argument (key-value)tuples, 
%   1st argument {'color', 'N', 'getRoi'}
%   2nd argument the corresponding value for settings
% it is not advised to use varargin, but to edit this file.
% All other variables have to be defined in the getSettings file itself. 

% declare settings vars
% CAPITALS indicate unchangebles
settings = struct(  'COLOR', struct('RGB', 0, 'XY', 1, 'rg', 2, 'H', 3, 'HS', 4, 'HSV', 5),...
                    'GETROI', struct('ON', 1, 'OFF', 0),...
                    'PROF', struct('ON', 0, 'OFF', 1),...
                    'CACHE', struct('ON', true, 'OFF', false));

%% instantiate default settings
% define colorspace
settings.color = settings.COLOR.RGB;

% define if region of interest should manually be selected 
settings.getRoi = settings.GETROI.ON; 

% set profiling on off
settings.prof = settings.PROF.OFF;

% enable framereader caching
settings.cache = settings.CACHE.ON;

% set default ROI
settings.Roi = [575, 230, 10, 40];

% set frames source
settings.movieName = 'voetbal';

% set frame range to be read
%settings.frameRange = 3147:3247;
settings.frameRange = 85:139;
%settings.frameRange = 85:115;

% set bucketnumbers for histogramming, N per dimension
settings.N = 16;

% set rate by which frames should be downsampled without smoothing
settings.downSampleRate = 2;

% set skip frames for tracking
settings.skipFramesStepsize = 1;

% set if movie should be saved and or shown
settings.saveAndShowMovie = 0;

% set where image should be cropped
settings.imageCropRange = 1:250;

% set the color of tracking bounding box
settings.TrackColor = [0, 0, 0]; % black

% set number of histogram bins N per color space dimension
switch(lower(settings.color))
    case {settings.COLOR.H}
        settings.NBins = settings.N;
    case {settings.COLOR.XY, settings.COLOR.rg, settings.COLOR.HS}
        settings.NBins = settings.N * ones(1,2);
    case {settings.COLOR.RGB, settings.COLOR.HSV}
        settings.NBins = settings.N * ones(1,3);
end                    


%% overwrite defaults if there were inputs
if(mod(nargin, 2)~=0)
    error('Need even inputs')
end

% set input arguments {color, n, getroi}
for i=1:2:nargin
    switch lower(varargin{i})
        case {'n'}
            settings.N = varargin{i+1};
        case {'color'}
            settings.color = varargin{i+1};
        case {'getroi'}
            settings.getRoi = varargin{i+1};
    end
end

% read all frames using the frame reader
settings.frames = FrameReader(settings);

%% get region of interest if getRoi is on and roi.mat does not exist
if (settings.getRoi == settings.GETROI.ON && exist('Roi.mat')~=2)
    handle = figure;
    imshow(color2rgb(settings.frames(:,:,:,1),settings));
    rect = getrect(handle);
    Roi = [floor(rect(1)),...
           floor(rect(2)),...
           floor(rect(3)),...
           floor(rect(4))];
    save('Roi.mat', 'Roi');
    close(handle);
elseif (exist('Roi.mat')==2) % load roi.mat
        load('Roi.mat');
end
settings.Roi = Roi;

%% do profiling if needed
if settings.prof == settings.PROF.ON
    profile clear
    profile on
else
    profile off
end

function frames = FrameReader(settings)
%FRAMEREADER reads frames as specified in settings
% FRAMES = FRAMEREADER(SETTINGS)
% FRAMES = a m*n*d*i frame matrix where
%   m*n is the image size
%   d is dependent on the colorspace
%   i is the number of frames in the movie
% SETTINGS = settings structure (see getSettings.m)  

movieName = settings.movieName;

% if we can cache do so & else read in png's
if(exist('frames.mat')==2 && settings.cache == settings.CACHE.ON)
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

    % reading 1st frame to get framesizes
    frame = im2double(imread(sFile));
    % crop image
    frame = frame(settings.imageCropRange,settings.imageCropRange,:);
    % downsample
    frame = frame(1:settings.downSampleRate:end,1:settings.downSampleRate:end,:);
    % color convert
    frame = rgb2color(frame, settings);
    [m,n,p] = size(frame);

    % declare frames before reading all in for optimization
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
        % color convert
        frame = rgb2color(frame, settings);
        % store in frames
        frames(:,:,:,i) = frame;
    end
    disp(' ');
    disp('saving to frames.mat...');
    save frames.mat frames;
    disp('done');
end