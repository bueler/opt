function [fx, dfx] = easyq(x)
% EASYQ  An easy quadratic for optimization.

fx = 5 * x(1)^2 + 0.5 * x(2)^2;
dfx = [10 * x(1);
       x(2)];
