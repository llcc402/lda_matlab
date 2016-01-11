% Input:
%     n     a scalar. The length of x.
%     p     a row vector. The probabilities of the atoms. It should sum to
%           one.
% Output:
%     x     a row vector of length n.
function x = discreternd(n, p)
if sum(p) ~= 1
    p = p / sum(p);
end
r = rand(1, n);
[~, ~, x] = histcounts(r, [0, cumsum(p)]);
end