function r = myImageFilter( image, windowsize, varargin )
%myImageFilter( IMAGE, NBHSIZE, FUNC )
%adapted from:
%http://staff.science.uva.nl/~rein/machinevision/localStatistics.pdf
%IMAGE = an image
%windowsize = windowsize
%FUNC = is function to be applied

[M N] = size( image );

r = zeros(M-windowsize(1)+1,N-windowsize(2)+1);
for j=1:N-windowsize(2)+1
  jind = (j):(j+windowsize(2)-1);
  for i=1:M-windowsize(1)+1
    iind = (i):(i+windowsize(1)-1);
    window = image(iind, jind);
    r(i,j) = locs2dist(window(:), varargin{:});
  end
end
