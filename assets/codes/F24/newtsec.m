% NEWTSEC  compare Newton's and secant steps, to see:
%   * Newton is quadratically convergent
%   * secant is superlinearly convergent
%   * the length of the secant steps asymptotically
%     matches the Newtons step length

f = @(x) sin(3*x) + 5*x.^2 - 12*x;
df = @(x) 3*cos(3*x) + 10*x - 12;
ddf = @(x) -9*sin(3*x) + 10;

xold = 2;
x = 1.5;
for k = 1:6
    pN = - df(x) / ddf(x);
    pS = - df(x) * (x - xold) / (df(x) - df(xold));
    xold = x;
    x = x + pS;
    semilogy(k, abs(df(x)), 'r*', k, abs(pS), 'cs', k, abs(pS - pN)/abs(pS), 'bo')
    hold on
end
xlabel k
legend('|df(x_k)|', '|p_k|', '|p_k - (pN)_k| / |p_k|')
grid on,  hold off