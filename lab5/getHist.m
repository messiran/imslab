function [vectLoc, vectHist] = getHist(vectKernel, img, Roi, settings) 
    x = Roi(1); y = Roi(2); w = Roi(3); h = Roi(4);
    % reshape the cropped region of interest to a standing vector
    vect = reshape(img(y:y+h, x:x+w, :), [(h+1)*(w+1), size(img,3)]);

    % construct histogram
    % get bin location
    vectLoc = img2histloc(vect, settings.NBins);

    % count buckets
    vectHist = locs2hists(vectLoc, settings.NBins, vectKernel);
