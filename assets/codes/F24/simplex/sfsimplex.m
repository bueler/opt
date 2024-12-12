function [x, z, iters] = sfsimplex(c,A,b,x,showiters,maxiters)
% SFSIMPLEX  Solve a standard form linear programming problem
%   minimize    z = c'*x
%   subject to  A*x = b
%               x >= 0
% where c is length n, A is m x n, and b >= 0 is length m, starting
% from a nondegenerate basic feasible solution x, using the revised
% simplex method.  This code does not claim to be efficient.  See Griva,
% Nash, Sofer (2009) section 5.2 for the algorithm.
% Usage:  [x, z] = sfsimplex(c,A,b,x)
%         [x, z] = sfsimplex(c,A,b,x,true)    % show iterations
%         [x, z] = sfsimplex(c,A,b,x,?,K)     % maximum of K iterations

% set optional arguments to defaults
if nargin < 5,  showiters = false;  end
if nargin < 6,  maxiters = 100;  end

% get sizes and check inputs
[m n] = size(A);
x = x(:);  b = b(:);  c = c(:);       % force vectors into columns
if length(b) ~= m,  error('A and b do not have compatible sizes'),  end
if any(b < 0),  error('b >= 0 required'),  end
if length(c) ~= n,  error('A and c do not have compatible sizes'),  end
if length(x) ~= n,  error('A and x do not have compatible sizes'),  end
if ~isbfs_(x,A,b)
    error('x is NOT a nondegenerate basic feasible solution')
end

% basic feasible solution defines sorted index sets
Bset = find(x > 0);
Nset = setdiff(1:n,Bset);

% main loop: move from one basic feasible solution to the next
for k = 1:maxiters
    % optionally print stuff
    if showiters
        fprintf('iteration %d:\n',k)
        Bsf = sprintf('  Bset = %s\n',repmat(' %d ',1,length(Bset)));
        fprintf(Bsf,Bset)
        Nsf = sprintf('  Nset = %s\n',repmat(' %d ',1,length(Nset)));
        fprintf(Nsf,Nset)
    end
    % get current basis variables (hatb) and reduced costs (hatcN)
    cB = c(Bset);
    cN = c(Nset);
    B = A(:,Bset);
    N = A(:,Nset);
    hatb = B \ b;
    y = B' \ cB;
    hatcN = cN - N' * y;
    % optionally print more stuff
    if showiters
        hatcNsf = sprintf('  ^cN = %s\n',repmat(' %g ',1,length(hatcN)));
        fprintf(hatcNsf,hatcN)
        [x,z] = getcurrent_(c,hatb,Bset);
        xsf = sprintf('  x = %s\n',repmat(' %g ',1,length(x)));
        fprintf(xsf,x)
        fprintf('  z = %g\n',z)
    end
    % test optimality
    if all(hatcN >= 0)
        fprintf('ending: optimum found on iteration %d\n',k)
        break
    end
    % get entering index (t)
    [ww, t] = min(hatcN);   % ww not used
    % check for unbounded problem
    hatAt = B \ A(:,Nset(t));
    if showiters
        hatAtsf = sprintf('  ^At = %s\n',repmat(' %g ',1,length(hatAt)));
        fprintf(hatAtsf,hatAt)
    end
    if all(hatAt <= 0)
        error('ending: detected unbounded on iteration %d\n',k)
    end
    % use ratio test to get leaving index (s)
    hatAt(hatAt <= 0) = -1;
    ratios = hatb ./ hatAt;
    ratios(ratios < 0) = Inf;
    [ww, s] = min(ratios);
    % update index sets
    tmp = Bset(s);
    Bset(s) = Nset(t);
    Nset(t) = tmp;
    Nset = setdiff(1:n,Bset);   % Nset ends up sorted
    Bset = sort(Bset);
    Nset = sort(Nset);
end
if k >= maxiters,  warning('maximum number of iterations reached'),  end
[x,z] = getcurrent_(c,hatb,Bset);
iters = k;

    function p = isbfs_(x,A,b)
    % ISBFS  Checks if x is a nondegenerate basic feasible solution
    % to a standard form linear programming problem.
    if any(x < 0), p = false; return, end    % x not feasible
    [m, t] = size(A(:,x>0));
    if t ~= m, p = false; return, end % B cannot be invertible because not square
    if cond(A(:,x > 0)) > 1.0e15, p = false; return, end  % B not invertible
    if norm(A * x - b) > 1.0e-6 * norm(b)
        warning('x is not close to a solution of Ax=b')
    end
    p = true;
    end

    function [x, z] = getcurrent_(c,hatb,Bset)
    % GETCURRENT  Uses Bset and hatb to build current x, then
    % uses c to get objective value z = c' * x.
    x = zeros(size(c));
    x(Bset) = hatb;
    z = c' * x;
    end
end
