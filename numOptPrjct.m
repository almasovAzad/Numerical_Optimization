%% Azad Almasov
%Final Project 
%Numerical Optimization
clc
clear all


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% ALL EXAMPLES ARE IN THIS SCRIPT %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% GO TO LINE 50 TO CHOOSE DESIRED EXAMPLE %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANUAL for code:
% In this example, I have 3 variables and 3 different input functions for
% each experiment. Each of these input functions changes for different
% each experiment. Input functions are given in 'inFun' function. If you
% pay attention you will see that the experiemnt number i is included in
% those equations so that they will be different for different experiemnts.
% So, for my different test examples, 'inFun' will have to be modified. I
% used conditional statement to choose desired example by the user. So all
% my examples are in this script you just need to modify the example number

% In function 'Measurement', I call these functions ('inFun' - input function,
% 'dfx' - ODE, 'eks' - numrical solution of ODE for x) inside for loop for
% each measurements. I also calculate measurements (yk) by adding error to
% each solution with mean zero and 0.1 variance. Function 'MSER' calculates
% mean square error.

% NOTE: My different examples are choosing different input functions.
% However, besides these you can go and modify error and number of
% experiments or initial guess of model paramaters or number of measurement
% time etc.

%% Example to choose:
%
% Input functions for different cases are given as follow:
% if example == 1; % You will have 3 different input functions
%     cc = sin(tt/i); % Each experiment these input functions keep changing          
%     z  = cos(tt/i)-sin(tt/i);  % i is the ith experiment 
%     uu = cos(tt/i);
%     u = [z;cc;uu];
% elseif example == 2; % You will have 2 different input functions
%     cc = sin(tt*i);          
%     z  = cos(tt*i)-sin(tt*i);
%     u = [z;cc];
% else
%     cc = sinh(tt*i); % You will have 2 different input functions  
%     z  = cosh(tt*i)-sinh(tt*i);
%     u = [z;cc];
% end
example = 1; % Choose your example from the list above


%% GIVEN:

% Choosing appropriate number of variable depending on example we chose.
if example == 1
    n = 3; % Number of independent variables. Fixed for appropriate example
else
    n = 2;
end

m  = 5;  % Number of experiments, you can modify it. For my report, I did
         % those examples for both 5 experiments case and 10 experiments
         % case just in case. I also played with random error in the
         % function 'Measurement' but did not put those results on report.
         
         % Furthermore, I have also played around with number of
         % measurements (length of measurement time), but didnt put those
         % results in the report as well.
         
         % Remember that optimization will be slower when we have more
         % experiements. Therefore, for quick check please choose 5
         % experiments.
         
% Define random A,C,x0 and u randomly depending on n (number of functions):         
rng(1); % So that whenever we run it multiple time it will generate the
        % same random values
A  = -0.4*rand(n,n,1); % Number in front of A and C is sensitive to noise.
                       % Please do not modify it so much.
rng(2);  
C  = 0.2*rand(n,n,1);

% Combined model parameter to be used in function 'eks':
B  = [A, C]

x0 = randn(n,1);

% I have defined input function u in the function 'inFun'. There, I input the
% experiment number i into each input function so that input function is
% modifieed for each experiment automatically.

tspan = 0:0.1:20; % You need this to solve ODE numerically (check function eks)
% Remember stepsize of tspan affects your precision of your numerical
% solution of ODE. You have to specify stepsize, otherwise it will chop
% tspan differently for different measurements, thus you will get
% different time length and this may cause error when you try to evaluate
% mser for different model paramters.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%PART1:   generate y (measure) satisfying system of ODEs, A,C, x0 and u:%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Solve and find x vector of solutions of system of ode:
[~, yk, t] = Measurement(B,x0,tspan,m,n,example); % Get measurements for each
                                                  % variable and each experiment

% Original mser. Compare your minimized mser with this as well as
% optimized model paramter matrix with B:
meansqrter = MSER(B,x0,tspan,m,n,yk,example)  % Check if MSER function works
                                              % well or not by giving zero
                                              % error in Measurement and
                                              % getting zero mser.
% Plot each data:
for i=1:n
    figure(i)
    for j=1:m
        plot(t,yk{j}(:,i),'*')
        xlabel('t value')
        ylabel(['Measurement of variable',num2str(i)]);
        hold on
        legend('Location','northwestoutside')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                %    %
%                                 %  %
%                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PART2: Estimate A and C given data y, input functions%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%For multivariable unconstraint minimization problems matlab has routine:

% But first guess A and C (initial guess):
rng(1) %Use different seed value so your 
A0  = -0.4*rand(n,n,1)+0.01;
rng(2) %Use different seed value so your 
C0  = 0.2*rand(n,n,1)+0.01;
% Initial guess of Combined model parameter:
B0  = [A0, C0]

%% Optimization:
%%'display','iter-detailed','Diagnostics','on','TolFun',1e-10,'TolX',1e-10,'GradObj','on','DerivativeCheck','off','Hessian','on'
options = optimoptions(@fminunc,'Display','iter', 'Algorithm','quasi-newton','TolFun',1e-10,'TolX',1e-10,'MaxIter',1000);
% options = optimset('fminsearch'); % In case we use 'fminsearch'
func = @(ff)MSER(ff,x0,tspan,m,n,yk,example);
[Best, meansqrter_est] = fminunc(func, B0, options) 

% Thus, estimated A and C model parameter matrices are:
Aest = Best(1:n,1:n);
Cest = Best(1:n,n+1:2*n);

% Find error:
err  = norm(Best-B)

% Model with estimated model paramaters:
[x_est,~,~] = Measurement(Best,x0,tspan,m,n,example);

% Plot each data with estimated model:
for i=1:n
    figure(i)
    for j=1:m
        plot(t,yk{j}(:,i),'*')
        plot(t,x_est{j}(:,i),'LineWidth',2)
        hold on
        plot(t,x_est{j}(:,i),'LineWidth',2)
        xlabel('t value')
        ylabel(['Measurement of variable, Regression result',num2str(i)]);
        hold on
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%