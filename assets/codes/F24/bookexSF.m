% BOOKEXSF  Test SFSIMPLEX on the example in section 5.2 of
% Griva, Nash, Sofer (2009); see pages 132-133. 
% Requires: EZSIMPLEX, SFSIMPLEX.
% See also: BOOKEXEZ.

c = [-1 -2 0 0 0]';
A = [-2 1 1 0 0; -1 2 0 1 0; 1 0 0 0 1];
b = [2 7 3]';
x = [0 0 2 7 3]';  % SFSIMPLEX requires an initial basic feasible solution
[x,z,iters] = sfsimplex(c,A,b,x,true)
assert(x, [3 5 3 0 0]', 1.0e-8)  % observed,expected,tolerance
assert(iters, 4)
fprintf('PASS\n')
