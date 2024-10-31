function [z, xk, k] = sdbt(f, x0, tol)
% SDBT  Solve unconstrained optimization problem
%   min f(x)
% by steepest descent (gradient descent) with back-tracking
% line search.  User supplies a function f which returns
% both the objective value and the gradient.  The user also
% supplies an initial iterate x0 and a convergence tolerance,
% where the stopping criterion is
%   ||grad f(x_k)|| < tol.
% Example using a function from EASYQ:
%   >> x0 = [2 20]';
%   >> [z, xk, k] = sdbt(@easyq, x0, 1.0e-10)
% Calls BT.  Compare SDBTRECORD which also records and
% reports the iterates.

xk = x0(:);
maxiters = 10000;
for k = 1:maxiters
    [fk, dfk] = f(xk);           % get objective value and gradient
    if norm(dfk) < tol
        z = fk;
        break                    % success
    end
    pk = - dfk(:);               % steepest descent
    alpha = bt(xk, pk, dfk, f);  % back-tracking
    xk = xk + alpha * pk;
end
