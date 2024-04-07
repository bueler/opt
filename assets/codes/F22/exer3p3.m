% EXER3P3  Solve Exercise 3.3 in section 11.3 of Griva, Nash, Sofer (2009).

f = @(x) 5 * x(1)^4 + 6 * x(2)^4 - 6 * x(1)^2 + 2 * x(1) * x(2) + ...
             5 * x(2)^2 + 15 * x(1) - 7 * x(2) + 13;
gradf = @(x) [20 * x(1)^3 - 12 * x(1) + 2 * x(2) + 15;
              24 * x(2)^3 + 2 * x(1) + 10 * x(2) - 7];
Hessf = @(x) [60 * x(1)^2 - 12,  2;
              2,                 72 * x(2)^2 + 10];

x = [1; 1];
fprintf('  x = %.14f, %.14f\n',x(1),x(2))
while norm(gradf(x)) > 1.0e-14
    p = - Hessf(x) \ gradf(x);
    x = x + p;
    fprintf('  x = %.14f, %.14f\n',x(1),x(2))
end
f(x)
norm(gradf(x))
eig(Hessf(x))
