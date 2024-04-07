% SR1QUADRATIC  Use symmetric rank-one quasi-Newton algorithm with
% exact line search to minimize a quadratic function
%   f(x) = (1/2) x^T Q x - c^T x

Q = [5 2 1; 2 7 3; 1 3 9];       % eig(Q) confirms Q is positive definite
c = [-9; 0; -8];

tol = 1.0e-10;                   % does not matter since x_3=x_* exactly
xk = [0 0 0]';
fprintf('%2d: %16.12f %16.12f %16.12f\n', 0, xk(1), xk(2), xk(3))
dfxk = Q * xk - c;
B = eye(3,3);                    % first step is steepest-descent: B=I
for k = 1:100
    if norm(dfxk) < tol          % absolute tolerance on gradient f
        break
    end
    pk = - B \ dfxk;             % quasi-Newton search direction
    alpha = - dfxk' * pk / (pk' * Q * pk);  % exact line search (page 404)
    sk = alpha * pk;             % step we take
    xk = xk + sk;                % do update
    fprintf('%2d: %16.12f %16.12f %16.12f\n', k, xk(1), xk(2), xk(3))
    olddfxk = dfxk;
    dfxk = Q * xk - c;
    yk = dfxk - olddfxk;
    v = yk - B * sk;
    B = B + v * (v / (v' * sk))';  % symmetric rank-one update
end

fprintf('error = %.2e\n', norm(xk - (Q \ c)))
