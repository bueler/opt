function [z, xlist] = sdbtrecord(f, x0, tol)
% SDBTRECORD  Solve unconstrained optimization problem
%   min f(x)
% by steepest descent (gradient descent) with back-tracking
% line search.  User supplies a function f which returns
% both the objective value and the gradient.  The user also
% supplies an initial iterate x0 and a convergence tolerance,
% where the stopping criterion is
%   ||grad f(x_k)|| < tol.
% Example using a function from EASYQ:
%   >> x0 = [2 20]';
%   >> [z, xlist] = sdbtrecord(@easyq, x0, 1.0e-10)
%   >> plot(xlist(1,:), xlist(2,:), '-o')
%   >> grid on,  axis equal,  xlabel('x_1'),  ylabel('x_2')
% Calls BT.
% This version *inefficiently* records all iterates x_k.
% Compare SDBT, which does not do that.

xlist = [x0(:)];
maxiters = 10000;
for k = 1:maxiters
    [fk, dfk] = f(xlist(:,k));           % get objective value and gradient
    if norm(dfk) < tol
        z = fk;
        break                            % success
    end
    pk = - dfk(:);                       % steepest descent
    alpha = bt(xlist(:,k), pk, dfk, f);  % back-tracking
    xlist(:,k+1) = xlist(:,k) + alpha * pk;
end
