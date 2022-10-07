% BOOKLPEXAMPLE  Run EZSIMPLEX on the example in section 5.2 of
% Griva, Nash, Sofer (2009).  See pages 126-127 and pages 132-133. 
% Provides a first minimal check on correctness.
% Requires: EZSIMPLEX, SFSIMPLEX.

c = [-1 -2]';
A = [-2 1; -1 2; 1 0];
b = [2 7 3]';
[x,z] = ezsimplex(c,A,b,true)
