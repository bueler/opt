% FDGRADIENT  Uses finite differences to approximate a gradient.
% Compare approximation errors from different ways to calculate h.

% exact function (and exact derivatives for testing)
f = @(x) exp(10*x(1) + 2*x(2)^2);
df = @(x) f(x) * [10; 4 * x(2)];                 % true gradient
Hf = @(x) f(x) * [100,       40 * x(2);          % true Hessian
                  40 * x(2), (4 + 16 * x(2)^2)];

% finite-difference approximations
df1fd = @(x,h) (f([x(1) + h; x(2)]) - f(x)) / h;
df2fd = @(x,h) (f([x(1); x(2) + h]) - f(x)) / h;

% use h formulas from page 425
xx = [-1; 1];  HH = Hf(xx);
simplerh = sqrt(eps);
besth1 = sqrt( 2 * f(xx) * eps / abs(HH(1,1)) );
besth2 = sqrt( 2 * f(xx) * eps / abs(HH(2,2)) );

% how accurate are the gradient approximations?
best = [df1fd(xx,besth1); df2fd(xx,besth2)];
fprintf('error using best    = %.2e\n', norm(best - df(xx)))
simpler = [df1fd(xx,simplerh); df2fd(xx,simplerh)];
fprintf('error using simpler = %.2e\n', norm(simpler - df(xx)))
