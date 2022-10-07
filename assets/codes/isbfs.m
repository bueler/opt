function p = isbfs(x,A,b)
% ISBFS  For a standard form linear programming problem
% with feasible set
%     A x = b,  x >= 0,
% determine if the input vector x is a nondegenerate basic
% feasible solution.  Returns p = true if x is of the correct
% length, has nonnegative entries, and its nonzero entries
% indicate columns of matrix A which form an invertible square
% matrix B.  Determines invertibility of B using criterion
% "cond(B) <= 1.0e15".  Generates a warning if x does not
% accurately solve A x = b.  Returns p = false otherwise.

p = false;                           % early returns are with false
x = x(:);                            % force x to be a column vector
if any(x < 0),  return,  end         % x not feasible
[m, n] = size(A);
if length(x) ~= n,  return,  end     % x is wrong size
BB = A(:,x > 0);
[_, nB] = size(BB);
if nB ~= m,  return,  end            % B is wrong size
if cond(BB) > 1.0e15,  return,  end  % B is not really invertible
if norm(b) == 0.0 || norm(A * x - b) / norm(b) > 1.0e-6
    warning('x is not close to a solution of Ax=b')
end
p = true;
