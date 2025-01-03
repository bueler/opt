function [x, z, xlist, fixlist] = newtsafe(f, x0, tol)
% NEWTSAFE  Newton's method for optimization with two
% significant "safety" mechanisms:
%   1. *slow* eigenvalue-based guarantee that each search
%      direction is a descent direction
%   2. back-tracking based line search
% There are additional error checks, and a warning if the
% Hessian is badly conditioned.
% Usage:  [x, z] = newtsafe(f, x0, tol)
%         [x, z, xlist, fixlist] = newtsafe(f, x0, tol)
%   where the user's f(x) must return the objective value
%   and the gradient and the Hessian.
% Example: see TESTNEWTSAFE
% Calls: BT for backtracking.
% Warning: This is not a professional-quality method!

x = x0(:);
if nargout > 2
    xlist = x;
    fixlist = [];
end
n = length(x);
maxiter = 100;  % make larger if desired
for j = 1:maxiter
    [fk, dfk, Hfk] = f(x);  % user's code must return all 3
    if norm(dfk) < tol
        z = fk;
        iters = j - 1;
        return
    end
    lam = eig(Hfk);  % get vector of eigenvalues
    if ~ isreal(lam)
        error('Hessian from user is not symmetric')
    end
    if min(lam) <= 0.0  % if Hfk is not positive definite
        E = - min(lam) + 0.01 * abs(max(lam));
        Hfk = Hfk + E * eye(n,n);  % now Hfk is pos def!
        if nargout > 2
            fixlist = [fixlist, 1];
        end
    else
        if nargout > 2
            fixlist = [fixlist, 0];
        end
    end
    if cond(Hfk) > 1.0e14
        warning('Newton step equation badly conditioned; search direction may be poor')
    end
    pk = - Hfk \ dfk;  % search direction from Newton step eqn
    if pk' * dfk >= 0
        error('huh? pk is not a descent direction')
    end
    alpha = bt(x, pk, dfk, f);  % back-tracking
    if alpha <= 0
        error('huh? alpha is not positive')
    end
    x = x + alpha * pk;  % take step
    if nargout > 2
        xlist = [xlist, x];
    end
end
error('maximum iterations reached')
