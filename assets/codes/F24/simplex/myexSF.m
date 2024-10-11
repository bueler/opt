% MYEXSF  Test SFSIMPLEX on Ed's example. 
% Requires: EZSIMPLEX, SFSIMPLEX.
% See also: MYEXEZ.

c = [-1 -1 0 0]';
A = [-1 1 1 0; 2 1 0 1];
b = [3 10]';
x = [0 0 3 10]';  % SFSIMPLEX requires an initial basic feasible solution
[x,z,iters] = sfsimplex(c,A,b,x,true)
assert(x, [7/3 16/3 0 0]', 1.0e-8)  % observed,expected,tolerance
assert(iters, 3)
fprintf('PASS\n')
