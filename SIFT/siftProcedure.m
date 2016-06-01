I = imread('Images/fruit.png');
I = rgb2gray(I);
[M,N] = size(I);

scaleStep = 0.2;
maxScaleFactor = 10;
k = 1:scaleStep:maxScaleFactor;
L = zeros(M,N,length(k));
D = zeros(M,N,length(k) - 1);
for i = 1:length(k)
    L(:,:,i) = imgaussfilt(I,k(i)); 
end

for i = 1:length(k) - 1
    D(:,:,i) = L(:,:,i) - L(:,:,i+1);
    if mod(i,10) == 0
%         figure, imshow(D(:,:,i));
    end
end
 
cand = zeros(M*N,3);    i = 1;
strel = ones(3,3,3);
strel(2,2,2) = 0;

cand = imdilate(D,strel);

