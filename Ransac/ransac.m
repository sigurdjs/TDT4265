I1 = imread('images/skolen-1.png');
I2 = imread('images/skolen-2.png');

I1 = rgb2gray(I1);
I2 = rgb2gray(I2);

points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);
numToConsider = round(0.5*min(length(points1),length(points2)));

[features1,points1]  = extractFeatures(I1,points1.selectStrongest(numToConsider));
[features2,points2]  = extractFeatures(I2,points2.selectStrongest(numToConsider));


matches = zeros(numToConsider,1);
val = zeros(numToConsider,1);

for i = 1:numToConsider
    [val(i),matches(i)] = min(sum(abs(bsxfun(@minus,features1,features2(i,:))),2));
end

[m,n] = size(I1);
I = [I1 I2];
imshow(I);
hold on;
points2.Location = bsxfun(@plus,points2.Location,[n 0]);  
plot(points1);
plot(points2);
for i = 1:numToConsider
    if matches(i) ~= 0
        p1 = points1(matches(i)).Location;
        p2 = points2(i).Location;
        line([p1(1),p2(1)],[p1(2),p2(2)]);
    end
end
hold off;


