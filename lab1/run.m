close all
img=im2double(rgb2gray(imread('images/nemo1.jpg')));
h = figure;
imshow(img);

rect = getrect(h)
x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);

        
%x = 249;
%y = 104;
%w = 62;
%h = 71;

nemo = img(y:y+h, x:x+w);
figure
imshow(nemo)

nbins = 50;

histogram = hist(nemo,[0:1/nbins:1]);
histogram = sum(histogram');
histogramNorm = histogram / sum(sum(histogram))


[imgH, imgW] = size(img)
imgProb = zeros(imgH, imgW);

% img = nemo;
% [imgH, imgW] = size(img)

for i = 1:imgH
    for j = 1:imgW
        i
        p = img(i,j);
        %pHist = hist(p, nbins);

        if p == 0
            pHist = 1;
        else
            pHist = ceil(p*nbins);
        end

        imgProb(i,j) = histogramNorm(pHist);
    end
end

figure;
imshow(imgProb, []);


