% FIT  Find least squares fit, of shifted exponential form, to noisy data.
% Use mostly by-hand analysis to minimize a 3-variable quadratic function by
% computing the gradient (df) and then solving a linear system (df(c) = 0).

% the data
x = [0.000 0.100 0.200 0.300 0.400 0.500 0.600 0.700  0.800  0.900  1.000];
y = [4.914 3.666 2.289 1.655 1.029 0.739 0.393 0.090 -0.197 -0.721 -0.971];

% generate gradient  df(c) = A c - b  from symmetric matrix A and vector b
ex = exp(-5.0*x);
A = zeros(3,3);
A(1,1) = 11.0;
A(1,2) = sum(x);      A(2,1) = A(1,2);
A(1,3) = sum(ex);     A(3,1) = A(1,3);
A(2,2) = sum(x.^2);
A(2,3) = sum(x.*ex);  A(3,2) = A(2,3);
A(3,3) = sum(ex.^2);
b = [sum(y), sum(x.*y), sum(ex.*y)]';

% solve system  df(c) = 0
c = A \ b

% plot result, with original data
plot(x,y,'ko','markersize',10),  hold on
xfine = 0:.01:1;                  % to plot smooth curve, use many x-values
plot(xfine,c(1) + c(2)*xfine + c(3)*exp(-5.0*xfine),'k')
hold off,  xlabel x,  ylabel y
