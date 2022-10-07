function [x,z] = ezsimplex(c,A,b,showiters,maxiters)
% FIXME NEEDS TESTING ONCE SFSIMPLEX IS WRITTEN
% EZSIMPLEX  Solve a linear programming problem in the special, easy
% form:      minimize    z = c'*x
%            subject to  A*x <= b
%                        x >= 0
% where c is length n, A is m x n, and b >= 0 is length m.
% Usage:  [x, z] = ezsimplex(c,A,b)
%         [x, z] = ezsimplex(c,A,b,true)    % show iterations
%         [x, z] = ezsimplex(c,A,b,?,K)     % maximum of K iterations
% Requires ISBFS and SFSIMPLEX.  See BOOKLPEXAMPLE and KLEEMINTY
% for test examples.

% set optional arguments to defaults
if nargin < 4,  showiters = false;  end
if nargin < 5,  maxiters = 100;  end

% get sizes and check inputs
[m n] = size(A);
b = b(:);   c = c(:);                % force into columns
if length(b) ~= m,  error('A and b do not have compatible sizes'),  end
if any(b < 0),  error('b >= 0 required'),  end
if length(c) ~= n,  error('A and c do not have compatible sizes'),  end

% add slack variables and define a basic feasible solution
fprintf('original variables x_%d,..,x_%d\n',1,n)
fprintf('adding slack variables x_%d,..,x_%d\n',n+1,n+m)
A = [A eye(m,m)];
c = [c; zeros(m,1)];
x = [zeros(n-m,1); b];
if ~isbfs(x),  error('something wrong: x is not b.f.s.'),  end

% now the problem is in standard form, so solve it
[x,z] = sfsimplex(c,A,b,x,showiters,maxiters);
