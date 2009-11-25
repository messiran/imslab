close all
clear all

settings = getSettings();

%read frames
frames = frameReader('voetbal', settings);

% get target image (first frame)
imgT = transformColor(frames(:,:,:,1), settings);

%% get region of interest
if settings.getRoi == settings.GETROI.ON
    handle = figure;
    imshow(imgT);
    rect = getrect(handle)
    Roi =  [floor(rect(1)),...
            floor(rect(2)),...
            floor(rect(3)),...
            floor(rect(4))]
    close(handle);
else
    Roi = settings.defaultRoi;
end
x = Roi(1); y = Roi(2); w = Roi(3); h = Roi(4);

%% get weighting kernel for historgram counts

kernel = getMask(0, Roi, 'Epanechnikov');
% TODO reshape to column vector in a stand alone function
vectKernel = reshape(kernel, [1, (w+1)*(h+1)]);

[dummy,vectTHist] = getHist(vectKernel, imgT, Roi, settings);

xNewVect = [];
% meanShift loop
for i = 1:size(frames, 4)
    imgC = frames(:,:,:,i);
    % get candidate image
    [vectCLoc, vectCHist] = getHist(vectKernel, imgC, Roi, settings);
    
    % candidate model
    Pu = vectCHist

    % targetmodel
    Qu = vectTHist

    % define absolute start location 
    Y0 = [x+.5*w, y + .5*h]

    % the W's per bin
    Wbin = sqrt(Qu./Pu);
    
    % the W's per bin per pixel in the image
    W = Wbin(vectCLoc)
    X = getMask(2, Roi, 'location');
    % duplicate W 2 times in the width dim

    Yshift = sum((W * ones(1,2)).*X) / sum(W)
    xNew = x+Yshift(1)*.5*(w+1)
    xNewVect = [xNewVect;xNew];
    yNew = y+Yshift(2)*.5*(h+1)
    close;
    imshow(frames(:,:,:,i));
    hold on;
    rectangle('Position',[xNew,yNew, w, h]);
end

xNewVect

% %show profiler
% if settings.prof == settings.PROF.ON
%     profile viewer
% end
% 
%     
% figure
% movie(immovie(frames))
% saveMovie(frames, 'result.avi', 10, 100,'Cinepak');







% todo herhistogrammen (bij min distance opnieuw histogram berekenen???
% (regiondimensions aanpassen??))
% lokatie voorspellen mean shift

% gaus op colorimportance en locatie? mag dit met mean shift?
% learning rate

% EPANECHNIKOV DOES NOT SUM TO 1!!!

% TODO: try different scales, e.g. if a player runs away he gets smaller
