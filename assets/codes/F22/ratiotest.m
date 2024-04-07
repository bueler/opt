function alphabar = ratiotest(A,b,x,p)
% RATIOTEST  Apply the ratio test from page 81 of Griva, Nash, & Sofer (2009).
% Considers only inequality constraints  Ax >= b.  Checks feasibility of x.
% Identifies inactive constraints at x.  Returns maximum allowed step size
% alphabar  so that  x + alphabar p  is feasible.
% Usage:   alphabar = ratiotest(A,b,x,p)
% Example:  Reproduce result on page 81 in Example 3.4:
% >> x = [1 1]';  p = [4 -2]'
% >> A = [1 4; 0 3; 5 1];  b = [3 2 4]';
% >> ratiotest(A,b,x,p)
% ans =  0.16667

[m n] = size(A);
b = b(:);  x = x(:);  p = p(:);           % force columns
if (length(b) ~= m), error('incompatible sizes for A,b'), end
if (length(x) ~= n), error('incompatible sizes for A,x'), end
if (length(p) ~= n), error('incompatible sizes for x,p'), end

c = A * x - b;                            % c_i = a_i^T x - b_i
if any(c < 0), error('x is not feasible'), end

if all(c == 0)                            % no step size restriction if
    alphabar = Inf;                       %   all constraints are active
else
    d = A * p;                            % d_i = a_i^T p
    d = d(c > 0);
    c = c(c > 0);
    if all(d >= 0)                        % no step size restriction if
        alphabar = Inf;                   %   heading in unbounded direction
    else
        alpha = c(d < 0) ./ (-d(d < 0));  % alpha_i = c_i / (-d_i)  for  d_i < 0
        alphabar = min(alpha);
    end
end

