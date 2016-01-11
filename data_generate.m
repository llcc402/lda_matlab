% Input:
%      M         a scalar. The number of documents.
%      D         a scalar. The size of the dictionary.
%      K         a scalar. The number of topics.
%      alpha     a scalar. The parameter of the dirhchlet distribution when
%                generate the mixing measure.
%      beta      a scalar. The parameter of the dirichlet distribution when
%                generate the topics.
%      L         a row vector.
% Output:
%      data      a matrix of three columns. The first column is the name of
%                the documents, the second column is the name of the word 
%                and the third column is the number of appearance of the
%                word in the corresponding document.
function data = data_generate(M, D, K, alpha, beta, L)

if nargin < 5
    beta = 1;
end
if nargin < 4
    alpha = 1;
end
if nargin < 3
    K = 5;
end
if nargin < 2
    D = 100;
end
if nargin < 1
    M = 20;
end
if nargin < 6
    L = poissrnd(30, [1, M]);
end

%--------------------------------------------------------------------------
% STEP 1: generate mixing measure
%--------------------------------------------------------------------------
mixing = zeros(M, K);
for i = 1:M
    mixing(i,:) = dirichletrnd(alpha * ones(1, K));
end

%--------------------------------------------------------------------------
% STEP 2: generate topics
%--------------------------------------------------------------------------
topics = zeros(K, D);
for i = 1:K
    topics(i,:) = dirichletrnd(beta * ones(1, D));
end

%--------------------------------------------------------------------------
% STEP 3: generate latent variables
%--------------------------------------------------------------------------
Z = cell(1, M);
for i = 1:M
    Z{i} = zeros(1, L(i));
    for j = 1:L(i)
        Z{i}(j) = discreternd(1, mixing(i,:));
    end
end

%--------------------------------------------------------------------------
% STEP 4: generate data
%--------------------------------------------------------------------------
data = zeros(M, D);
for i = 1:M
    for j = 1:L(i)
        t = discreternd(1, topics(Z{i}(j), :));
        data(i, t) = data(i, t) + 1;
    end
end

end












