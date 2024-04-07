% CALCONE_NEWTON  Find min of calculus I function by Newton's method
% to solve f'(x) = 0.

% f = @(x) (x.^2 + sin(x)).^2 - 10.0 * (cos(5.0 * x) + 1.5 * x);  % not actually used
df = @(x) 2.0 * (x.^2 + sin(x)) .* (2.0 * x + cos(x)) ...
          + 10.0 * (5.0 * sin(5.0 * x) - 1.5);
ddf = @(x) 2.0 * (2.0 * x + cos(x)).^2 ...
          + 2.0 * (x.^2 + sin(x)) .* (2.0 - sin(x)) + 250.0 * cos(5.0 * x);

x = 1.25          % initial estimate ... must be good enough?  note "1.0" fails
for k = 1:4       % Newton's method ... 4 steps gives 16 digits!
    x = x - df(x) / ddf(x)
end
