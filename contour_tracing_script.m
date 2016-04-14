
% Load image
image = imread('test.png');

% Preprocessing of image
BW = im2bw(image);          % convert image to black and white image
BW = padarray(BW,[1 1],1);  % pad image around the edges with white pixels

% Contour Tracing
contours = mooreNeighborhoodTracing( BW );

% Recreation of contours in an image
sizeOfBW = size(BW);
n = length(contours);
M = ones(sizeOfBW);

for row = 1:n
    x = contours(row,1);
    y = contours(row,2);
    M(x,y) = 0; 
end
%imshow(M);

% % Identify image (object) properties
% [major_axis_diameter, minor_axis_diameter] = computeDiameterProperties( contours ); 
% [edges, vertices] = computeNrOfEdgesAndVertices( contours );
% 
% 
% if ( major_axis_diameter - minor_axis_diameter < 5 )
%    disp(' CIRCLE ') 
% end
