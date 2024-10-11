% BOOKEXEZ  Test EZSIMPLEX on the example in section 5.2 of
% Griva, Nash, Sofer (2009); see pages 126-127. 
% Requires: EZSIMPLEX, SFSIMPLEX.
% See also: BOOKEXSF.

c = [-1 -2]';
A = [-2 1; -1 2; 1 0];
b = [2 7 3]';
[x,z,iters] = ezsimplex(c,A,b,true)
assert(x, [3 5]', 1.0e-8)  % observed,expected,tolerance
assert(iters, 4)
fprintf('PASS\n')
