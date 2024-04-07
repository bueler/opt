function kleeminty(n)
% KLEEMINTY  A famous bad example of a linear programming (LP) problem where
% the simplex method becomes as slow as a brute-force tour of the extreme
% points.  See wikipedia page for "Klee-Minty cube"
%     https://en.wikipedia.org/wiki/Klee-Minty_cube
% for detailed problem.  Here it is a minimization LP problem in
% dimension n in convenient form:
%     min   z = - 2^(n-1) x1 - 2^(n-2) x2 - ... - xn
%     s.t.  x1                                           <= 5
%           4 x1 + x2                                    <= 25
%           8 x1 + 4 x2 + x3                             <= 125
%           16 x1 + 8 x2 + 4 x3 + x4                     <= 625
%           ...
%           2^n x1 + 2^(n-1) x2 + ... + 4 x_{n-1} + x_n  <= 5^n
%           x1 >= 0, x2 >= 0, ..., x_n >= 0
% (The Griva, Nash, Sofer (2009) textbook has a differently-scaled
% version in section 9.3.)
% Usage:   kleeminty(n)
% where:
%          n = dimension; defaults to n = 4.
% Requires: EZSIMPLEX, SFSIMPLEX

if nargin < 1,  n = 4;  end

% set up problem
c = -2.^(n-1:-1:0)';
A = eye(n,n);
for k = 2:n
   A(k,1:k-1) = 2.^(k:-1:2);
end
b = 5.^(1:n)';

% show
fprintf('Klee-Minty cube in dimension %d:\n',n)
disp('c'' =')
disp(c')
disp('A =')
disp(A)
disp('b'' =')
disp(b')

% call simplex method
[x, z] = ezsimplex(c,A,b,true,2^n+1)   % show iterations; raise maxiter
