% SALMON  Solve the salmon problem from the 5 example
% optimization problems handout
%   https://bueler.github.io/opt/assets/worksheets/F24/5exs.pdf
% Calls SFSIMPLEX.

% put problem into standard form; note x3 has been shifted
c = [2 3 4 0 0]';
A = [1 1 1 0 0; 1 0 0 1 0; 0 0 1 0 1];
b = [17 2 6]';
x0 = [0 17 0 2 6]';  % BFS for basic vars x2,x4,x5

% run simplex (output is "tilde"d for now); print steps
[xtilde, ztilde] = sfsimplex(c,A,b,x0,true);

% undo transformation; print result
x = xtilde;
x(3) = x(3) + 4
z = ztilde + 16