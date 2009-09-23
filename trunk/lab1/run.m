close all
img=im2double(imread('images/nemo1.jpg'));

h = figure;
imshow(img);

rect = getrect(h)
x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);

       
% x = 249;
% y = 104;
% w = 62;
% h = 71;

nemo = img(y:y+h, x:x+w, :);
figure
imshow(nemo)

[M, N, P] = size(nemo);
nemoReshaped = reshape(nemo, [M*N, P]);

NBins = [20, 20, 20];
locs = img2histloc(nemoReshaped, NBins);

counts = full(sparse(locs, ones(M*N,1), ones(M*N,1), prod(NBins), 1));
p = counts/(M*N);



% save prob on corresponding index
[M, N, P] = size(img);
imgReshaped = reshape(img, [M*N, P]);

imgloc = img2histloc(imgReshaped, NBins);
result = p(imgloc);
result = reshape(result, [M,N]);

figure;
imshow(result,[]);

