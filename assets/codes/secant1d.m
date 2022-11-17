function [xk, xklist] = secant1d(df,x0,x1,tol)
% SECANT1D  Solve  min f(x), i.e. df(x) = 0, by the secant method.
% Usage:  [xk, xklist] = secant1d(df,x0,x1,tol)
% where   df  = a function which returns scalar f'(x)
%         x0  = initial iterate
%         x1  = next iterate
%         tol = stopping tolerance is |f'(xk)| < tol
% Example:
%   >> df = @(x) 3*x^2 - 2*cos(x);
%   >> [xk,xklist] = secant1d(df,0.0,1.0,1.0e-8);
%   >> format long g,  xklist'

xklist = [x0 x1];
xold = x0;
xk = x1;
for k = 2:100
    if abs(df(xk)) < tol           % stopping criterion
        break
    end
    if abs(xk - xold) < 1.0e-20    % avoid division by zero
        break
    end
    p = - (xk - xold) * df(xk) / (df(xk) - df(xold));
    xold = xk;
    xk = xk + p;
    xklist = [xklist xk];
end

