% NEWTONEX1  Solve unconstrained scalar optimization problem
%   min f(x)
% where f(x) = - sin(x) * exp(-x^2).  Uses Newton's method
% starting at x0 = 0.5.

% define objective function
f = @(x) -sin(x) .* exp(-x.^2);

% plot helps identify initial iterate
figure(1)
xx = -3:.01:3;  plot(xx,f(xx))
grid on,  xlabel x,  title('objective function')

% we solve  f'(x) = 0  so we need f'(x) and f''(x)
df = @(x) exp(-x.^2) .* (2 * x .* sin(x) - cos(x));
ddf = @(x) exp(-x.^2) .* ( (-4 * x.^2 + 3) .* sin(x) + 4 * x .* cos(x) );

% run Newton (... without a for loop ... it would be easy to write one!)
format long
x = 0.5
x = x - df(x) / ddf(x)
x = x - df(x) / ddf(x)
x = x - df(x) / ddf(x)
x = x - df(x) / ddf(x)
x = x - df(x) / ddf(x)
f(x)     % objective value
df(x)    % check that f'(x)=0 to good accuracy
