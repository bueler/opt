function [xk, xklist] = sr1bt(x0,f,tol,maxiters)
% SR1BT  Symmetric rank-one quasi-Newton algorithm using back-tracking line
% search.  Based on pages 413--415 of Griva, Nash, Sofer (2009).  Reverts to
% a steepest-descent step when a non-descent step is detected.
% Usage:
%    [xk, xklist] = sr1bt(x0,f,tol)
% where
%    x0          vector with initial iterate
%    f           function handle (e.g. "f" if f is anonymous or "@f" if f is
%                f.m); f() needs to return function value f(x_k) AND gradient
%                grad f(x_k) as first two outputs:    [fxk, dfxk] = f(xk)
%    tol         stop when norm of gradient is less than this number
% and (outputs)
%    xk          Nth iterate
%    xklist      all iterates as N+1 column matrix
% Compare SDBT which does (slow) steepest-descent and back-tracking.
% Example: ROSENCOMPARE

if nargin < 4
    maxiters = 20000;            % never take more steps than this
end
xk = x0(:);                      % force into column shape
if nargout > 1
    xklist = [xk];
end
n = length(xk);

B = eye(n,n);                    % first step is steepest-descent: B=I
[fxk, dfxk] = f(xk);
for k = 1:maxiters
    if norm(dfxk) < tol          % absolute tolerance on gradient f
        break
    end
    pk = - B \ dfxk;             % quasi-Newton step
    if dfxk' * pk >= 0.0
        fprintf('warning: non-descent direction at step %d (use steepest-descent)\n',k)
        pk = - dfxk;
    end
    alpha = bt(xk,pk,dfxk,f);    % back-tracking line search
    oldxk = xk;
    olddfxk = dfxk;
    xk = xk + alpha * pk;        % do update
    if nargout > 1
        xklist = [xklist xk];    % append latest point to list
    end
    [fxk, dfxk] = f(xk);
    sk = xk - oldxk;             % sk, yk used to update B; see GNS p. 413
    yk = dfxk - olddfxk;
    v = yk - B * sk;
    denom = v' * sk;
    if denom == 0
        break                    % in this case we are certainly done
    end
    if abs(denom) < 1.0e-14
        warning(strcat('divide by near-zero in symmetric rank-one update',...
                       ' at iteration %d; convergence?'),k)
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

