I = imread('fruit.png');
I = reshape(I,[],1,3);
K = 4;

%% Initialize cluster centers with random values
mu = [];
for i = 1:K
    r = randi([0 255],1,3);
    mu = [mu; r];
end

%% Assign to different clusters
a = zeros(length(I),length(mu));
for i = 1:length(I)
    d = [];
    for j = 1:length(mu)
        d = [d norm(double(I(i,:)) - mu(j,:))];
    end
    [~, index] = min(d);
    a(i,index) = 1;
end


        
    

