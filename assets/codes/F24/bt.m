function alpha = bt(xk,pk,dfxk,f)
% BT From a point x_k and a direction p_k, apply back-tracking
% line search to compute alpha_k in update
%   x_{k+1} = x_k + alpha_k p_k
% Requires: * vector dfxk = grad f(x_k)
%           * function f(x)
% See also SDBT.

Dk = dfxk' * pk;     % scalar directional derivative
if Dk >= 0,  error('directional derivative must be negative'),  end
mu = 1.0e-4;         % modest sufficient decrease
rho = 0.5;           % backtracking by halving
alpha = 1.0;
while f(xk + alpha * pk) > f(xk) + mu * alpha * Dk
    alpha = rho * alpha;
end
