Im = imread('colors-2.png');
[M,N,~] = size(Im);
% imshow(I);
I = reshape(Im,[],1,3);
K = 16;

%% Initialize cluster centers with random values

mu = randi([0 255],K,3);
disp(mu);
%% Assign to different clusters
a = zeros(length(I),length(mu));
m = zeros(length(I),3,length(mu));
d = zeros(length(I),length(mu));
prevsize = zeros(length(mu),1);
cursize = ones(length(mu),1);
while(cursize ~= prevsize)
    prevsize = cursize;
    i = 1:length(I);
    for j = 1:length(mu)
    %     disp(bsxfun(@minus,double(I(i,:)), mu(j,:)));
        m(:,:,j) = bsxfun(@minus,double(I(i,:)), mu(j,:));
        d(:,j) = abs(sum(m(:,:,j),2)); 
    end
    [~, index] = min(d,[],2);
    for i = 1:length(index);
        a(i,index(i)) = 1;
    end
    n = zeros(length(mu),1);
    for j = 1:length(mu)
        indexes = find(a(:,j));
        cursize(j) = length(indexes);
        if isempty(indexes)
            disp('something fucked up');
            mu(j,:) = randi([0 255],3,1);
        elseif isnan(length(indexes))
            disp('something else went wrong');
        else
            mu(j,:) = (1/length(indexes)).*sum(I(indexes,:));
        end
    end
end
figure(1);
j = 1;
for i = 1:K
    im = ones(length(a),1,3)*255;
    ind = find(a(:,i));
    im(ind,1,:) = repmat(mu(i,:),length(ind),1);
    im = uint8(reshape(im,M,N,3));
    subplot(2,2,j);
    imshow(im);
    j = j + 1;
    if mod(i,4) == 0
        figure((i/4) + 1);
        j = 1;
    end
end
figure,imshow(Im);