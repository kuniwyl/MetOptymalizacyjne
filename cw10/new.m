% Define the objective function and constraints
fun = @(x) (x(1) - 1)^2 + (x(2) - 1)^2 + (x(3) - 1)^2;
g1 = @(x) x(1)^2 + 0.5*x(2)^2 + x(3)^2 - 1;
g2 = @(x) 0.8*x(1)^2 + 2.5*x(2)^2 + x(3)^2 + 2*x(1)*x(3) - x(1) - x(2) - x(3) - 1;

% Augmented Lagrangian Method
x = [0; 0; 0];
z = [0; 0];
mu = 1;
lambda = 1;
epsilon = 1e-5;
rho = 2; % You can adjust the value of rho

% Initialize storage for residuals and penalty parameter
feasibility_residuals = [];
optimality_residuals = [];
penalty_parameters = [];

k = 1;
while true
    % Update x using the Levenberg–Marquardt method
    [x, lambda] = levenbergMarquardt(x, lambda, mu, fun, g1, g2);
    
    % Update z and mu
    z = z + mu * [g1(x); g2(x)];
    mu = rho * mu;
    
    % Compute residuals
    feasibility_residual = norm([g1(x); g2(x)], 2);
    optimality_residual = norm(2 * jacobian(x, fun) * transpose(feval(x)) + jacobian(x, [g1; g2])' * z, 2);
    
    % Store residuals and penalty parameter
    feasibility_residuals = [feasibility_residuals; feasibility_residual];
    optimality_residuals = [optimality_residuals; optimality_residual];
    penalty_parameters = [penalty_parameters; mu];
    
    % Check convergence
    if feasibility_residual < epsilon && optimality_residual < epsilon
        break;
    end
    
    k = k + 1;
end

% Plot residuals and penalty parameter
figure;
subplot(3, 1, 1);
plot(feasibility_residuals, 'o-');
title('Feasibility Residuals');
xlabel('Iteration');

subplot(3, 1, 2);
plot(optimality_residuals, 'o-');
title('Optimality Residuals');
xlabel('Iteration');

subplot(3, 1, 3);
plot(penalty_parameters, 'o-');
title('Penalty Parameter');
xlabel('Iteration');

% Penalty Method
x = [0; 0; 0];
mu = 1;

% Initialize storage for residuals and penalty parameter
feasibility_residuals_penalty = [];
optimality_residuals_penalty = [];
penalty_parameters_penalty = [];

k = 1;
while true
    % Update x using the Levenberg–Marquardt method with penalized objective
    [x, ~] = levenbergMarquardt(x, 0, mu, @(x) fun(x) + mu * (g1(x)^2 + g2(x)^2), []);
    
    % Update mu
    mu = rho * mu;
    
    % Compute residuals
    feasibility_residual = norm([g1(x); g2(x)], 2);
    optimality_residual = norm(2 * jacobian(x, fun) * transpose(feval(x)) + jacobian(x, [g1; g2])' * mu * [g1(x); g2(x)], 2);
    
    % Store residuals and penalty parameter
    feasibility_residuals_penalty = [feasibility_residuals_penalty; feasibility_residual];
    optimality_residuals_penalty = [optimality_residuals_penalty; optimality_residual];
    penalty_parameters_penalty = [penalty_parameters_penalty; mu];
    
    % Check convergence
    if feasibility_residual < epsilon && optimality_residual < epsilon
        break;
    end
    
    k = k + 1;
end

% Plot residuals and penalty parameter for Penalty Method
figure;
subplot(3, 1, 1);
plot(feasibility_residuals_penalty, 'o-');
title('Feasibility Residuals (Penalty Method)');
xlabel('Iteration');

subplot(3, 1, 2);
plot(optimality_residuals_penalty, 'o-');
title('Optimality Residuals (Penalty Method)');
xlabel('Iteration');

subplot(3, 1, 3);
plot(penalty_parameters_penalty, 'o-');
title('Penalty Parameter (Penalty Method)');
xlabel('Iteration');

% Define Levenberg–Marquardt method for subproblem
function [x_new, lambda_new] = levenbergMarquardt(x, lambda, mu, fun, g1, g2)
    options = optimoptions('fsolve', 'Display', 'off');
    x_new = fsolve(@(x) computeEquations(x, lambda, mu, fun, g1, g2), x, options);
    lambda_new = lambda + mu * [g1(x_new); g2(x_new)];
end

% Define equations for the Levenberg–Marquardt method subproblem
function equations = computeEquations(x, lambda, mu, fun, g1, g2)
    equations = [jacobian(x, fun); jacobian(x, [g1; g2])]' * [feval(x); g1(x)^2 + g2(x)^2 - mu];
end

% Define Jacobian matrix
function J = jacobian(x, fun)
    epsilon = 1e-8;
    n = length(x);
    m = length(fun(x));
    J = zeros(m, n);
    for i = 1:n
        x_plus_epsilon = x;
        x_plus_epsilon(i) = x_plus_epsilon(i) + epsilon;
        J(:, i) = (fun(x_plus_epsilon) - fun(x)) / epsilon;
    end
end
