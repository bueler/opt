function [z, xk, xklist] = sdquad(x0,Q,c,tol,maxiters)
% SDQUAD  Steepest-descent optimization for quadratic functions
%    f(x) = (1/2) x^T Q x - c^T x
% Uses exact line search.  Stopping criterion is tolerance on the
% norm of the gradient.  Compare steepest-descent with back-tracking
% in SDBT.  Usage:
%    [z, xk, xklist] = sdquad(x0,Q,c,tol)
% where
%    x0          length n vector with initial iterate
%    Q           square n x n matrix; normally positive definite
%    c           length n vector
%    tol         stop when norm of gradient is less than this number
% and (outputs)
%    z           objective value at xk
%    xk          kth iterate
%    xklist      all iterates as matrix

if nargin < 5
    maxiters = 20000;            % never take more steps than this
end
c = c(:);  xk = x0(:);           % force into column shape
if nargout > 2                   % start keeping track of iterates
    xklist = [xk];               %     if user wants that
end
for k = 1:maxiters
    fxk = 0.5 * xk' * Q * xk - c' * xk;
    dfxk = Q * xk - c;
    z = fxk;
    if norm(dfxk) < tol          % absolute tolerance on gradient f
        break
    end
    pk = - dfxk;                 % steepest descent
    alpha = - dfxk' * pk / (pk' * Q * pk);   % use exact line search
    xk = xk + alpha * pk;        % overwrites old point
    if nargout > 2
        xklist = [xklist xk];    % append latest point to list
    end
end
