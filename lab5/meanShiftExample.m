
q = [1/2, 1/4, 1/4]
img = [2, 1, 3, 1, 1]

for binNo=1:3
    p(binNo) = sum(img == binNo);
end

%normalize
p = p/sum(p) % p = [3/5 1/5 1/5]


p
q

% u = x pos van img
% m = width image 
m = size(img,2);
w = zeros(1, m);
for u = 1:m% 1..5
    bin = img(u)
    w(u) = sqrt(p(bin)/q(bin))
end
w

x = [-1 -1/2 0 1/2 1]

B = sum(w)

A = 0
for u = 1:m% 1..5
    A = A + x(u) * w(u)
end
    
gradient = A/B

