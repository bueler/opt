% ROSENCOMPARE  Compare SDBT (steepest descent with
% back-tracking line search) versus SR1BT (symmetric
% rank-one quasi-Newton with back-tracking line
% search) on the ROSENBROCK function.
% Requires: ROSENBROCK, BT, SDBTRECORD, SR1BT

x0 = [0 0]';   % exact min is at xstar = [1 1]'
tol = 1.0e-5;  % warning: SDBTRECORD slow with this choice!
               %          adjust maxiters as needed

% visualization only (background contours)
[xx,yy] = meshgrid(-1:.01:2,-1:.01:2);  zz = zeros(size(xx));
for j=1:301
    for k=1:301
        zz(j,k) = rosenbrock([xx(j,k);yy(j,k)]);
    end
end

% steepest descent
[xk, xklist] = sdbtrecord(@rosenbrock, x0, tol, 20000);
tstr = sprintf('SDBT: %d iterations',length(xklist)-1);
disp(tstr)
figure(1), grid on
plot(xklist(1,:),xklist(2,:),'ro-')
hold on, contour(xx,yy,zz,10.^(-4:0.4:7),'k'), hold off
title(tstr)

% SR1 quasi-Newton
[xk, xklist] = sr1bt(@rosenbrock, x0, tol);
tstr = sprintf('SR1BT: %d iterations',length(xklist)-1);
disp(tstr)
figure(2), grid on
plot(xklist(1,:),xklist(2,:),'ro-')
hold on, contour(xx,yy,zz,10.^(-4:0.4:7),'k'), hold off
title(tstr)
