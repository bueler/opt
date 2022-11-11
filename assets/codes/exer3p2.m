% EXER3P2  Solve exercise 3.2 in section 11.3 of Griva, Nash, Sofer (2009).

f   = @(x) 5*x.^5 + 2*x.^3 - 4*x.^2 - 3*x + 2;
df  = @(x) 25*x^4 + 8*x^2 - 8*x - 3;
ddf = @(x) 100 * x^3 + 16 * x - 8;

xx = -2:.2:2;

for j=1:length(xx)
    xk = xx(j);
    for k=1:10
        xk = xk - df(xk) / ddf(xk);
    end
    fprintf('x0 = %4.1f:  %18.15f  %18.15f\n', xx(j), xk, f(xk))
end
