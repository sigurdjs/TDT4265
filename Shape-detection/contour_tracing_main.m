% Load image
image = imread('image.png');

% Preprocessing of image
BW = im2bw(image);          % convert image to black and white image
BW = padarray(BW,[1 1],1);  % pad image around the edges with white pixels
imshow(BW);
% Contour Tracing
[contours,chains] = mooreNeighborhoodTracing( BW );

% Recreation of contours in an image
sizeOfBW = size(BW);
n = length(contours);
M = zeros(sizeOfBW);
for row = 1:n
    x = contours(row,1);
    y = contours(row,2);
    image(sizeOfBW(1)-y, x, 1) = 0;
    image(sizeOfBW(1)-y, x, 2) = 255;
    image(sizeOfBW(1)-y, x, 3) = 0;
    M(y,x) = 1; 
end
M = flipud(M);
figure(1);
imshow(image);
% Identify image (object) properties
Properties = ObjectProperties(chains,contours,M);
N = padarray(Properties.figure,[100 100],'both');
N = flipud(N);
figure(2);
imshow(N);

% Determine shape
DetermineNoisyShape(Properties);
