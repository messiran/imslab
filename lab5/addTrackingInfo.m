function frames = addTrackingInfo(frames, track, w, h)
    for i = 1:size(frames, 4)
        frame = frames(:,:,:,i);
        % Put rectangle around hit
        mask = getmask(size(frame),[track(i,1,1), track(i,2,1), w, h], 'border');
        frame(mask)=0;
        mask = getmask(size(frame),[track(i,1,1)+w/2-3, track(i,2,1)+h/2-3, 6, 6], 'ellipse');
        frame(mask)=0;
        mask = getmask(size(frame),[track(i,1,1)+w/2-1, track(i,2,1)+h/2-1, 2, 2], 'ellipse');
        frame(mask)=1;
        frames(:,:,:,i) = frame;
    end
end

