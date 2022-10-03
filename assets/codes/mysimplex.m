function [x,z] = mysimplex(c,A,b,showiters,maxiters)
% MYSIMPLEX  Solve a linear programming problem in the special form
%   minimize    z = c'*x
%   subject to  A*x <= b
%               x >= 0
% where c is length n, A is m x n, and b >= 0 is length m.  This code
% does not claim to be efficient, but I believe it is correct.
% Usage:  [x, z] = mysimplex(c,A,b)
%         [x, z] = mysimplex(c,A,b,true)    % show iterations
%         [x, z] = mysimplex(c,A,b,?,K)     % maximum of K iterations
% See Griva, Nash, Sofer (2009) section 5.2 for algorithm.
% See BOOKLPEXAMPLE and KLEEMINTY for test examples.

% set optional arguments to defaults
if nargin < 4,  showiters = false;  end
if nargin < 5,  maxiters = 100;  end

% get sizes and check inputs
[m n] = size(A);
b = b(:);   c = c(:);                % force into columns
if length(b) ~= m,  error('A and b do not have compatible sizes'),  end
if any(b < 0),  error('b >= 0 required'),  end
if length(c) ~= n,  error('A and c do not have compatible sizes'),  end
fprintf('original variables x_%d,..,x_%d\n',1,n)

% add slack variables
fprintf('adding slack variables x_%d,..,x_%d\n',n+1,n+m)
A = [A eye(m,m)];
c = [c; zeros(m,1)];

% the slack variables define a basic feasible solution
Bset = n+1:n+m;
Nset = 1:n;

% main loop: move from one basic feasible solution to the next
for k = 1:maxiters
    % get current basis variables (hatb) and reduced costs (hatcN)
    cB = c(Bset);
    cN = c(Nset);
    B = A(:,Bset);
    N = A(:,Nset);
    hatb = B \ b;
    y = B' \ cB;
    hatcN = cN - N' * y;
    % optionally print a lot of stuff
    if showiters
        fprintf('iteration %d:\n',k)
        Bsf = sprintf('  Bset = %s\n',repmat(' %d ',1,length(Bset)));
        fprintf(Bsf,Bset)
        Nsf = sprintf('  Nset = %s\n',repmat(' %d ',1,length(Nset)));
        fprintf(Nsf,Nset)
        hatcNsf = sprintf('  ^cN = %s\n',repmat(' %g ',1,length(hatcN)));
        fprintf(hatcNsf,hatcN)
        [x,z] = getcurrent(c,hatb,Bset);
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
        fprintf('ending: detected unbounded on iteration %d\n',k)
        break
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
    Nset = setdiff(1:n+m,Bset);   % Nset ends up sorted
end
if k >= maxiters,  warning('maximum number of iterations reached'),  end
[x,z] = getcurrent(c,hatb,Bset);

    function [x, z] = getcurrent(c,hatb,Bset)
    % GETCURRENT  Uses Bset and hatb to build current x.  Uses c to get z.
    x = zeros(size(c));
    x(Bset) = hatb;
    z = c' * x;
    end
end
