function x = phaseone(A,b)
% PHASEONE  Compute an initial basic feasible solution (BFS) x0
% to a standard-form LP problem with feasible set
%   A x = b
%   x >= 0
% using the "phase-1" technique described in section 5.4 of
% Griva, Nash, & Sofer (2008).  This example from section 5.2
% solves the phase 1 problem and then uses the BFS in phase 2:
%   >> A = [-2 1 1 0 0; -1 2 0 1 0; 1 0 0 0 1],  b = [2 7 3]'
%   >> x0 = phaseone(A,b)
%   >> c = [-1 -2 0 0 0]'
%   >> [x, z] = sfsimplex(c,A,b,x0,true)
% Requires SFSIMPLEX.

[m n] = size(A);
b = b(:);      % force into column
if length(b) ~= m,  error('A and b do not have compatible sizes'),  end
if any(b < 0),  error('b >= 0 required for standard form'),  end

newA = [A eye(m,m)];
newc = [zeros(n,1); ones(m,1)];
newx = [zeros(n,1); b];
[xart, zart] = sfsimplex(newc,newA,b,newx,false);
if zart > 0.0
    error('phase 1 failed to find a basic feasible solution')
end
fprintf('phase 1 complete ... found basic feasible solution\n')
x = xart(1:n);
