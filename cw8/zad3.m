clc; clear; close all;

n = 10;
m = 10;
A = randn(m, n);
b = randn(m, 1);

[feasible_x, objective_values] = augmentedLagrangianBooleanLS(A, b);

feasible_x

% Plot the objective values
figure;
plot(objective_values);
xlabel('Iteration');
ylabel('Objective Value');
title('Objective Value vs. Iteration for n=m=10');

function y = f(x, A, b) 
    y = A * x - b;
end

function y = g(x)
    y = x.^2 - 1;
end

function obj = objective(x, A, b)
    obj = norm(A*x - b)^2;
end

function [feasible_x, objective_values] = augmentedLagrangianBooleanLS(A, b)
    mu = 1.0;
    max_iter = 100;

    [m, n] = size(A);
    z = zeros(n, 1);
    x = A\b; % Initial guess (minimizer of the least squares problem)
    lambda_ = zeros(n, 1); % Initial Lagrange multipliers
    objective_values = [];

    for k = 1:max_iter
        xOld = x;
        fun = @(x) [f(x, A, b); sqrt(mu) * g(x) + (1/(2 * sqrt(mu)) * z)];
        opts = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt', 'Display', 'off');
        x = lsqnonlin(fun, x, [], [], opts);

        feasible_x = sign(x); % Obtain feasible x by rounding
        
        z = z + 2 * mu * g(feasible_x);
        
        objective_values(end+1) = objective(feasible_x, A, b);

        if (norm(g(feasible_x)) >= 0.25 * norm(g(sign(xOld))))
            mu = mu * 2;
        end
    end
end