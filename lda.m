% Input:
%      data           a matrix of M * D, where M is the number of docs and D is
%                     the size of the dictionary.
%      K              a scalar. The number of topics.
%      maxIter        a scalar. The number of iterations for the Gibbs sampling.
%      alpha          a scalar. The hyper-parameter of mixing.
%      beta           a scalar. The hyper-parameter of topics.
% Output:
%      mixing_mean    a matrix of order M * K, where K is the numer of topics.
%      topics_mean    a matrix of order K * D.
%      Z              a matrix of order M * K. Z(i,j) is the name of the topic
%                     of word j in doc i.
function [mixing_mean, topics_mean, Z] = lda(data, K, maxIter, alpha, beta)
if nargin < 5
    beta = 1;
end
if nargin < 4
    alpha = 1;
end
if nargin < 3
    maxIter = 100;
end

%--------------------------------------------------------------------------
% STEP 1: Init
%--------------------------------------------------------------------------
[M, D] = size(data);

mixing = zeros(M, K); % used for iteration
for i = 1:M
    mixing(i,:) = dirichletrnd(ones(1, K));
end
mixing_mean = mixing; % used for output

topics = zeros(K, D); % used for iteration
for i = 1:K
    topics(i,:) = dirichletrnd(ones(1, D));
end
topics_mean = topics; % used for output

Z = zeros(M, D);
L = sum(data, 2); % L is a vector with elements the lengths of the docs
perp = zeros(1, maxIter);
recorded = 0; % count the recorded mixing and topics

%--------------------------------------------------------------------------
% STEP 2: Gibbs sampling
%--------------------------------------------------------------------------
for iter = 1:maxIter
    % sampling Z
    for i = 1:M
        for j = 1:D
            if data(i,j) ~= 0
                Z(i,j) = get_z(data, topics, mixing, L, i, j);
            end
        end
    end
    
    % sampling topics
    for i = 1:K
        topics(i, :) = get_topics(data, Z, beta, i);
    end

    % sampling mixture measure
    for i = 1:M
        mixing(i, :) = get_mixing(Z, alpha, data, i, K);
    end
    if iter > maxIter / 2
        topics_mean = topics_mean + topics;
        mixing_mean = mixing_mean + mixing;
        recorded = recorded + 1;
    end

    % evaluate perplexity
    perp(iter) = perplexity(data, topics, Z);

end

%--------------------------------------------------------------------------
% STEP 3: evaluate the output variables and plotting
%--------------------------------------------------------------------------
mixing_mean = mixing_mean / recorded;
topics_mean = topics_mean / recorded;

plot(1:maxIter, perp)
title('Perplexity v.s. Gibbs iterations')
xlabel('iteration')
ylabel('perplexity')

end

function z = get_z(data, topics, mixing, L, i, j)

prob = zeros(1, size(topics, 1));
for k = 1:length(prob)
    prob(k) = log(mixing(i, k)) + log(topics(k, j)) * data(i,j) + ...
        log(1 - topics(k, j)) * (L(i) - data(i,j));
end
prob = prob - max(prob);
prob = exp(prob);
if sum(prob) == 0
    error('prob is 0')
end
if isnan(sum(prob))
    error('prob is nan')
end
prob = prob / sum(prob);
z = discreternd(1, prob);

end

function topic = get_topics(data, Z, beta, i)

Z = Z == i;
counts = sum(data .* Z);
topic = dirichletrnd(beta + counts);

end

function mixing = get_mixing(Z, alpha, data, i, K)

counts = accumarray((Z(i,:) + 1)', data(i,:));
counts = counts(2:end);
counts = counts';
if length(counts) < K
    counts = [counts, zeros(1,K - length(counts))];
end
mixing = dirichletrnd(counts + alpha);

end











