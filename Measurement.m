function [xxx, ms, tt] =Measurement(A,x0,tspan,m,n,example) % It saves every experiemnt
                                               % into seperate cells
rng('default');
error = normrnd(0,0.1,[length(tspan),1])*ones(1,n); % Normal error
for j=1:m
    [t, sol{j}] = eks(A,x0,tspan,j,n,example);
    % If you want to add different noise to different experiemnts
    % put random error generation inside for loop
%     rng('default');
%     error = normrnd(0,0.05,[length(t),1])*ones(1,n); % Normal error
    y{j} = sol{j} + error; % Measurement j:1,....m
end
xxx = sol;  % Real model output
ms = y;     % Measuremnets sells for each experiment
tt = t;     % measured time cells for each measurement
end