function img = transformColor(img, settings)
%% change colorspace
if settings.color == settings.COLOR.XY
    % goto xy space
    img = rgb2xy(imgOrigIn);
end

