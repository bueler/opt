function Z = nullmat(A, ind)
% NULLMAT  Compute a null matrix Z of a wide matrix A = [B N] by the
% "variable reduction" formula
%   Z = [- inv(B) * N; I]
% The input column indices (ind) identify the columns which form B.
% The remaining columns form N.  Note that "A = [B N]" might not be
% literal, but it needs to be achievable by reordering the columns.
% Example:
%   >> A = [1 1 1 1; 1 -1 -1 1];
%   >> Z = nullmat(A, 1:2);       % result is 4 x 2
%   >> norm(A * Z)
%   ans = 0
#   >> rank(Z)
#   ans = 2

% size, and input checking
[m n] = size(A);
assert(m <= n, 'only works with m<=n, for [m n]=size(A)')
assert(isindex(ind), 'input ind must be valid indices')
assert(all(ind >= 1 && ind <= n), 'indices ind must be in {1,...,n}')

% generate Z
BB = A(:, ind);
cind = setdiff(1:n, ind);  % complementary indices
NN = A(:, cind);
II = eye(n - m, n - m);
Z = zeros(n, n - m);
Z(ind,:) = - BB \ NN;
Z(cind,:) = II;
