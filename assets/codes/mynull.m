function Z = mynull(A)
% MYNULL Constructs a null space matrix for m x n matrix A, with full row rank,
% using the QR decomposition.

[m n] = size(A);
if m > n,  error('A must be  m x n  with m <= n'),  end
if rank(A) < m,  warning('numerical rank(A) < m'),  end
[Q R] = qr(A');
Z = Q(:,m+1:n);
