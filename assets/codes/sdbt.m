function [xk, xklist] = sdbt(x0,f,tol,maxiters)
% SDBT  Steepest-descent optimization with back-tracking line search.  Stopping
% criterion is tolerance on the norm of the gradient.
% Usage:
%    [xk, xklist] = sdbt(x0,f,tol)
% where
%    x0          vector with initial iterate
%    f           function handle (e.g. "f" if f is anonymous or "@f" if f is
%                f.m); f() needs to return function value f(x_k) and gradient
%                grad f(x_k) as first two outputs:    [fxk, dfxk] = f(xk)
%    tol         stop when norm of gradient is less than this number
% and (outputs)
%    xk          Nth iterate
%    xklist      all iterates as N+1 column matrix
% Example: find minimum of ROSENBROCK function, and show contours
%   >> x0 = [0 0]';
%   >> [xk, xklist] = sdbt(x0,@rosenbrock,1.0e-4);
%   >> norm(xk - [1;1])
%   >> plot(xklist(1,:),xklist(2,:))   % iterates path
%   >> [xx,yy]=meshgrid(-1:.01:2,-1:.01:2);  zz = zeros(size(xx));
%   >> for j=1:301, for k=1:301,  zz(j,k) = rosenbrock([xx(j,k);yy(j,k)]);  end,  end
%   >> hold on, contour(xx,yy,zz,10.^(-4:0.4:7),'k')

if nargin < 4
    maxiters = 20000;            % never take more steps than this
end
xk = x0(:);                      % force into column shape
if nargout > 1
    xklist = [xk];
end
for k = 1:maxiters
    [fxk, dfxk] = f(xk);
    if norm(dfxk) < tol          % absolute tolerance on gradient f
        break
    end
    pk = - dfxk;                 % steepest descent
    alpha = bt(xk,pk,dfxk,f);    % back-tracking line search
    xk = xk + alpha * pk;
    if nargout > 1
        xklist = [xklist xk];    % append latest point to list
    end
end
end % function

    function alpha = bt(xk,pk,dfxk,f)
    % BT Apply backtracking using standard default parameters.
    Dk = dfxk' * pk;
    fxk = f(xk);
    if Dk >= 0.0,  error('pk is not a descent direction ... stopping'),  end
    c = 1.0e-4;  % modest sufficient decrease
    rho = 0.5;   % backtracking by halving
    alpha = 1.0;
    while f(xk + alpha * pk) > fxk + c * alpha * Dk
        alpha = rho * alpha;
    end
    end % function

