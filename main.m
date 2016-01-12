clear
clc
% generate data set with 100 docs and 10 topics. The size of the dictionary
% is 300, and each doc has 80 words on average.
M = 100;
D = 300;
K = 10;
alpha = .1;
beta = .1;
lambda = 80;
[data, mixing, topics] = data_generate(M, D, K, alpha, beta,...
    poissrnd(lambda, [1, M]));

% fix hyper-parameters as the same when generating, and run the Gibbs
% sampling for 500 iterations
tic;
maxIter = 500;
[mixing_mean, topics_mean, Z] = lda(data, K, maxIter, alpha, beta);
toc

% change the order of the topics_mean and mixing_mean 
kl = zeros(K);
for i = 1:K
    for j = 1:K
        kl(i,j) = symKL(topics(i,:),topics_mean(j,:));
    end
end
[~,ix] = min(kl,[],2);
topics_mean = topics_mean(ix,:);
mixing_mean = mixing_mean(:,ix);

% compare the first topic
figure(2)
plot(1:D,topics(1,:),'-o', 1:D, topics_mean(1,:),'--*')
title('The distribution of the first topic')
xlabel('word')
ylabel('probability')
legend('theoretical', 'drawn')

% compare the first mixing measure
figure(3)
plot(1:K, mixing(1,:),'-o', 1:K, mixing_mean(1,:),'--*')
title('The distribution of the first mixing measure')
xlabel('topic')
ylabel('probability')
legend('theoretical', 'drawn')
