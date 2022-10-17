function x = phaseone(A,b)
% PHASEONE  Compute an initial basic feasible solution x to a
% standard-form LP problem with feasible set
%   A x = b
%   x >= 0
% Requires SFSIMPLEX.

[m n] = size(A);
b = b(:);      % force into column
if length(b) ~= m,  error('A and b do not have compatible sizes'),  end
if any(b < 0),  error('b >= 0 required for standard form'),  end

newA = [A eye(m,m)];
newc = [zeros(n,1); ones(m,1)];
x0 = [zeros(n,1); b];
xart = sfsimplex(newc,newA,b,x0,false);
fprintf('phase 1 complete ... x is basic feasible solution\n')
x = xart(1:n);
