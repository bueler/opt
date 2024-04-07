% CALCONE_GOLDEN  Find min of calculus I function by golden section search
% on the values of f(x).

f = @(x) (x.^2 + sin(x)).^2 - 10.0 * (cos(5.0 * x) + 1.5 * x);

% need to start with [a,b] containing unique minimum
a = 1.0;
b = 1.5;

% generate two interior points
phi = (sqrt(5) + 1) / 2;    % golden ratio; ~ 1.618
c = b - (b - a) / phi;
d = a + (b - a) / phi;

% golden section search for min f
tol = 0.5e-6;
while b - a > tol
    % [a c d b]   % uncomment to see current bracket
    if f(c) < f(d)
        b = d;
        d = c;
        c = b - (b - a) / phi;
    else
        a = c;
        c = d;
        d = a + (b - a) / phi;
    end
    (a + b) / 2
end
