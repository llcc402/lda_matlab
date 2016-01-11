% Input:
%      alpha     a row vector. 
% Output:
%      x         a row vector of the same length as alpha.
function x = dirichletrnd(alpha)

x = gamrnd(alpha, 1);
x = x / sum(x);
end