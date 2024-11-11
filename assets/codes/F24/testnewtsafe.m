function testnewtsafe(tol)
% TESTNEWTSAFE Try out NEWTSAFE on
%   min x_1^4 + x_2^2 - 2 x_1^2 + 3
% starting from random initial iterates.  Note that
% points (-1,0) and (1,0) are minima, while (0,0)
% is a saddle point.

    if nargin < 1
        tol = 1.0e-10;
    end
    for j=1:20
        x0 = 4 * randn(2,1);
        [x, z, xlist, fixlist] = newtsafe(@myf, x0, tol);
        fprintf('j=%2d: %d iterations', j, length(fixlist))
        if any(fixlist)
            for k = find(fixlist)
                fprintf('  (indefinite Hessian fix j=%d)\n', k)
            end
        else
            fprintf('\n')
        end
        if abs(abs(x(1)) - 1) + abs(x(2)) > 2 * tol
            error('minimum not found')
        end
    end

end % function testnewtsafe

    function [z, g, H] = myf(x)
        z = x(1)^4 + x(2)^2 - 2*x(1)^2 + 3;
        g = [4*x(1)^3 - 4*x(1); 2*x(2)];
        H = [12*x(1)^2 - 4, 0.0; 0.0, 2];
    end
