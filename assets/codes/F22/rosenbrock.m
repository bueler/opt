function [f, df, Hf] = rosenbrock(x)
% ROSENBROCK Famous banana-contoured quartic function with unique global minimum.

if length(x) ~= 2,  error('x must be length 2 vector'),  end
f = 100 * (x(2) - x(1)^2)^2 + (1 - x(1))^2;
if nargout > 1
    df = [- 400 * x(1) * (x(2) - x(1)^2) - 2 * (1 - x(1));
          200 * (x(2) - x(1)^2)                           ];
end
if nargout > 2
    Hf = [1200*x(1)^2-400*x(2)+2,  -400*x(1);
          -400*x(1),               200];
end

