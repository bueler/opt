% STRAIGHT  Solve continuum optimization problem
%   min             f(u) = int_0^1 (1/2) (u'(x))^2 dx
%   u(0)=a, u(1)=b
% by discretization.  Here u(x) is piecewise-linear, with values
% u_j = u(x_j), j=1,...,n, where x_j = j h and h = 1 / (n+1).
% Constructs a symmetric positive-definite matrix Q, and vector c
% and scalar d, so that the discrete problem is unconstrained
% optimization over u in R^n:
%   min  fhat(u) = (1/2) u' Q u - c' u + d
% Generates a plot.  (The answer is boring and exact.)
% This method is powerful and generalizable!

a = 3.0;  % boundary data; choose what you want
b = 0.0;
n = 9;    % choose the size you want; this gives clear plot

% set up a linear system from the discretization
h = 1.0 / (n+1);   % grid spacing
d = (a^2 + b^2) / (2 * h);
Q = zeros(n,n);  c = zeros(n,1);
for j = 1:n
    if j==1
        Q(j,1:2) = [2 -1];
        c(j) = a / h;
    elseif j==n
        Q(j,n-1:n) = [-1 2];
        c(j) = b / h;
    else
        Q(j,j-1:j+1) = [-1 2 -1];
    end
end
Q = Q / h;

% solve
ustar = Q \ c      % minimizer
fstar = 0.5 * ustar' * Q * ustar - c' * ustar + d

% plot
x = 0.0:h:1.0;     % length n+2
plot(x,[a ustar' b],'r-'), hold on
plot(x(2:end-1), ustar, 'ro-'), hold off
xlabel x, ylabel u, grid on
title('u(x) solves  min (1/2) \int_0^1 (du/dx)^2 dx')
