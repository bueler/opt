% MYEXEZ  Test EZSIMPLEX on Ed's example. 
% Requires: EZSIMPLEX, SFSIMPLEX.
% See also: MYEXSF.

c = [-1 -1]';
A = [-1 1; 2 1];
b = [3 10]';
[x,z,iters] = ezsimplex(c,A,b,true)
assert(all(abs(x - [7/3 16/3]') < 1.0e-8))
assert(iters == 3)
fprintf('PASS\n')
