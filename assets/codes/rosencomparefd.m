function rosencomparefd(tol)
% ROSENCOMPAREFD  Compare SR1BT (symmetric rank-one quasi-Newton with
% back-tracking line search) to SR1BTFD which uses finite-differenced
% derivatives.
% Requires: ROSENBROCK, ROSENOBJ, SR1BT, SR1BTFD

x0 = [0 0]';
xstar = [1 1]';

% SR1 quasi-Newton: user-provided f returns objective value *and* gradient
fprintf('calling SR1BT ...\n');
[xk, xklist] = sr1bt(x0,@rosenbrock,tol);
err = norm(xk - xstar);
fprintf('    %d iterations gives error %.2e\n',length(xklist)-1, err);

% using finite-differenced derivatives: user-provide f only returns objective
fprintf('calling SR1BTFD ...\n');
[xk, xklist] = sr1btfd(x0,@rosenobj,tol);
err = norm(xk - xstar);
fprintf('    %d iterations gives error %.2e\n',length(xklist)-1, err);
end

    function f = rosenobj(x)
    % ROSENOBJ Objective-only version of the famous banana-contoured
    % quartic function.  Compare ROSENBROCK

    if length(x) ~= 2,  error('x must be length 2 vector'),  end
    f = 100 * (x(2) - x(1)^2)^2 + (1 - x(1))^2;
    end