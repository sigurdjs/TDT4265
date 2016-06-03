%% Import images 
I1 = imread('images/skolen-1.png');
I2 = imread('images/skolen-2.png');

%% Convert to grayscale
I1 = rgb2gray(I1);
I2 = rgb2gray(I2);

[height,width] = size(I1);

% Calculate and extract SURF features from both images
points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);
numToConsider = round(0.2*min(length(points1),length(points2)));

[features1,points1]  = extractFeatures(I1,points1.selectStrongest(numToConsider));
[features2,points2]  = extractFeatures(I2,points2.selectStrongest(numToConsider));

%% Find potential matches by finding the smallest euclidian norm of the features
matches = zeros(numToConsider,1);
val = zeros(numToConsider,1);

for i = 1:numToConsider
    [val(i),matches(i)] = min(sum(abs(bsxfun(@minus,features1,features2(i,:))),2));
end

%% Remove outliers with Hough transform
points1 = points1(matches);
v1 = -points1.Location;
scaleRatio = points1.Scale./points2.Scale;
deltaAng = points1.Orientation - points2.Orientation;

offset = zeros(length(deltaAng),2);
for i = 1:length(deltaAng)
    R = [cos(deltaAng(i)) sin(deltaAng(i)); -sin(deltaAng(i)) cos(deltaAng(i))];
    offset(i,:) = R*(v1(i,:)');
end
xLocations = points2.Location(:,1) + offset(:,1);
yLocations = points2.Location(:,2) + offset(:,2);

angBin = 0:pi/4:(2*pi);
scBin = 0.5:1:10;
xBin = 1:(width/10):width;
yBin = 1:(height/10):height;

H = zeros(length(angBin),length(scBin),length(xBin),length(yBin));

for i = 1:length(matches)
    [~,angInd] = min(abs(deltaAng(i) - angBin));
    [~,scInd] = min(abs(scaleRatio(i) - scBin));
    [~,xInd] = min(abs(xLocations(i) - xBin));
    [~,yInd] = min(abs(yLocations(i) - yBin));
    H(angInd,scInd,xInd,yInd) = H(angInd,scInd,xInd,yInd) + 1;
end

nCorrectMatches = max(H(:));
[bestA,bestSc,bestX,bestY] = ind2sub(size(H),find(H == nCorrectMatches));

correctIndices = [];
for i = 1:length(matches)
    [~,angInd] = min(abs(deltaAng(i) - angBin));
    [~,scInd] = min(abs(scaleRatio(i) - scBin));
    [~,xInd] = min(abs(xLocations(i) - xBin));
    [~,yInd] = min(abs(yLocations(i) - yBin));
    
    if (angInd ==  bestA(1)  && scInd == bestSc(1)) && (xInd == bestX(1) && yInd == bestY(1))
        correctIndices = [correctIndices i];
    end
end

    

%% Plot matches in one image
I = [I1 I2];
imshow(I);

hold on;
points2.Location = bsxfun(@plus,points2.Location,[width 0]);  
plot(points1(correctIndices));
plot(points2(correctIndices));
for i = 1:length(correctIndices)
        p1 = points1(correctIndices(i)).Location;
        p2 = points2(correctIndices(i)).Location;
        line([p1(1),p2(1)],[p1(2),p2(2)]);
end
hold off;


