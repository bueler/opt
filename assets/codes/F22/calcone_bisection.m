% CALCONE_BISECTION  Find min of calculus I function by bisection search
% to solve f'(x) = 0.

% f = @(x) (x.^2 + sin(x)).^2 - 10.0 * (cos(5.0 * x) + 1.5 * x);  % not actually used
df = @(x) 2.0 * (x.^2 + sin(x)) .* (2.0 * x + cos(x)) ...
          + 10.0 * (5.0 * sin(5.0 * x) - 1.5);

% need to start with [a,b] which brackets solution to f'(x)=0
a = 1.0;
b = 1.5;

% bisection search for f'(x)=0
tol = 0.5e-6;
while b - a > tol
    % [a b]   % uncomment to see current bracket
    c = (a + b) / 2
    if df(c) * df(a) < 0
        b = c;
    else
        a = c;
    end
end
c = (a + b) / 2
