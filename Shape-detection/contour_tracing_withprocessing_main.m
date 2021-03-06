% Load image
image = imread('mynt.png');
BW = rgb2gray(image);
BW = edge(BW,'canny',[0.01 0.6]);
se = strel('disk',10);
BW = imclose(BW,se);
BW = imcomplement(BW);
% Preprocessing of image
% BW = im2bw(image);          % convert image to black and white image
BW = padarray(BW,[1 1],1);  % pad image around the edges with white pixels
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
% Identify image (object) properties
Properties = ObjectProperties(chains,contours,M);
figure(2);
imshow(image);
N = padarray(Properties.figure,[100 100],'both');
N = flipud(N);
figure(3);
imshow(N);

% Determine shape
DetermineNoisyShape(Properties);
