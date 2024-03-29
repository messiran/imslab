
q = [5/10, 2/10, 1/10, 1/10, 1/10];
img = [1, 1, 3, 1, 5;...
       1, 2, 3, 4, 5;...
       1, 2, 3, 4, 5;...
       1, 2, 3, 4, 5;...
       1, 2, 3, 4, 5];

for binNo=1:length(q)
    p(binNo) = sum(sum(img == binNo));
end

%normalize
p = p/sum(p) % p = [3/5 1/5 1/5]


p
q

% u = x pos van img
% m = width image 
m = prod(size(img))
img = reshape(img, [m, 1])

w = zeros(1, m);
for u = 1:m% 1..5
    bin = img(u);
    w(u) = sqrt(p(bin)/q(bin));
end
w

%x = [-1 -1/2 0 1/2 1]
[X,Y] = meshgrid(-2:2,2:-1:-2)
x = [reshape(X, [m,1]),reshape(Y, [m,1])]

B = sum(w)

A = 0;
for u = 1:m% 1..5
    A = A + x(u,:) * w(u);
end
    
gradient = -A/B

