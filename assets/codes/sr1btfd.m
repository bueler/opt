function [xk, xklist] = sr1btfd(x0,f,tol,maxiters)
% SR1BTFD  Symmetric rank-one quasi-Newton algorithm using back-tracking line
% search, but only requiring the user to provide an objective function.
% The gradients are computed through finite-differencing.  Compare SR1BTFD.
% Usage:
%    [xk, xklist] = sr1btfd(x0,f,tol)
% where
%    x0          vector with initial iterate
%    f           function handle (e.g. "f" if f is anonymous or "@f" if f is
%                f.m); f() needs to return function value f(x_k)
%    tol         stop when norm of gradient is less than this number
% and (outputs)
%    xk          Nth iterate
%    xklist      all iterates as N+1 column matrix
% Example: ROSENCOMPAREFD

if nargin < 4
    maxiters = 20000;            % never take more steps than this
end
xk = x0(:);                      % force into column shape
if nargout > 1
    xklist = [xk];
end
n = length(xk);

B = eye(n,n);                    % first step is steepest-descent: B=I
[fxk, dfxk] = fdgrad(xk,f);
for k = 1:maxiters
    if norm(dfxk) < tol          % absolute tolerance on gradient f
        break
    end
    pk = - B \ dfxk;             % quasi-Newton step
    if dfxk' * pk >= 0.0
        fprintf('warning: non-descent direction at step %d .. revert to steepest-descent\n',k)
        pk = - dfxk;
    end
    alpha = bt(xk,pk,dfxk,f);    % back-tracking line search
    oldxk = xk;
    olddfxk = dfxk;
    xk = xk + alpha * pk;        % do update
    if nargout > 1
        xklist = [xklist xk];    % append latest point to list
    end
    [fxk, dfxk] = fdgrad(xk,f);
    sk = xk - oldxk;             % sk, yk used to update B; see GNS p. 413
    yk = dfxk - olddfxk;
    v = yk - B * sk;
    denom = v' * sk;
    if denom == 0
        break                    % in this case we are certainly done
    end
    B = B + v * (v / denom)';    % symmetric rank-one update
end
end % function

    function alpha = bt(xk,pk,dfxk,f)
    % BT Apply backtracking using standard default parameters.
    Dk = dfxk' * pk;
    fxk = f(xk);
    mu = 1.0e-4;  % modest sufficient decrease
    rho = 0.5;    % backtracking by halving
    alpha = 1.0;  % alpha_0=1 because of Newton, and by Thm 11.7
    while f(xk + alpha * pk) > fxk + mu * alpha * Dk
        alpha = rho * alpha;
    end
    end % function

    function [fxk, dfxk] = fdgrad(xk,f)
    % FDGRAD  Compute a finite difference approximation to the
    % gradient using a simple estimate of the parameter h.
    fxk = f(xk);
    n = length(xk);
    dfxk = zeros(n,1);
    h = sqrt(eps);  % the "simpler" formula page 425
    for i = 1:n
        xkh = xk;
        xkh(i) = xk(i) + h;             % x_i + h
        dfxk(i) = (f(xkh) - fxk) / h;
    end
    end % function

