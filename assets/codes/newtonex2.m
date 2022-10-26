% NEWTONEX2  Solve unconstrained optimization problem
%   min f(x)
% for local minimum, where
%   f(x) = x(1)^4 + x(1)^2 * x(2)^2 + 2 x(2)^2 - 5 x(1) + x(2)
% Uses Newton's method starting at x0 = [1; 0].

f = @(x) x(1)^4 + x(1)^2 * x(2)^2 + 2 * x(2)^2 - 5 * x(1) + x(2);
df = @(x) [4 * x(1)^3 + 2 * x(1) * x(2)^2 - 5;
           2 * x(1)^2 * x(2) + 4 * x(2) + 1];
ddf = @(x) [12 * x(1)^2 + 2 * x(2)^2,  4 * x(1) * x(2);
            4 * x(1) * x(2),           2 * x(1)^2 + 4];

format long
x = [1; 0];  x'
x = x - ddf(x) \ df(x);  x'
x = x - ddf(x) \ df(x);  x'
x = x - ddf(x) \ df(x);  x'
x = x - ddf(x) \ df(x);  x'
x = x - ddf(x) \ df(x);  x'   % agrees with previous to all digits

norm(df(x))   % is tiny ==> stationary point
eig(ddf(x))   % both are positive ==> strict local minimum
