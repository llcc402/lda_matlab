% Model:
%                    sum_{d=1}^M(log(p(w_d)))
%      perp = exp( ---------------------------- ),
%                       sum_{d=1}^M N_d
% where M is the number of documents, w_d is the words in document d, N_d
% is the number of words in document d. We specify w_d as
%      w_d = prod_{i=1}^{N_d} p(w_{d,i}),
% where w_{d,i} is the prob of word i in doc d.
function perp = perplexity(data, topics, Z)
log_topics = log(topics);
log_weight = 0;
for i = 1:size(data, 1)
    for j = 1:size(data, 2)
        if data(i,j) ~= 0
            log_weight = log_weight + log_topics(Z(i,j), j) * data(i,j);
        end
    end
end

perp = exp(log_weight / sum(sum(data)));

end