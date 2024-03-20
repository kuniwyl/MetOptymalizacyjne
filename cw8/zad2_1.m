function augmented_lagrangian_method
    clc; clear; close all;
    % Objective function
    function y = f(x)
        y = (x(1) - 1)^2 + (x(2) - 1)^2 + (x(3) - 1)^2;
    end

    function y = df(x)
        y = [2*(x(1) - 1), 2*(x(2)-1), 2*(x(3)-1)];
    end

    function y = g(x) 
        y = [g1(x);g2(x)];
    end

    % Constraint functions
    function y = g1(x)
        y = x(1)^2 + 0.5*x(2)^2 + x(3)^2 - 1;
    end

    function y = g2(x)
        y = 0.8*x(1)^2 + 2.5*x(2)^2 + x(3)^2 + 2*x(1)*x(3) - x(1) - x(2) - x(3) - 1;
    end

    function y = dg(x)
        y = [
            2*x(1), x(2), 2*x(3);
            1.6*x(1) + 2*x(3) - 1, 5*x(2) - 1, 2*x(3) + 2*x(1) - 1
        ];
    end

    % Augmented Lagrangian
    function y = L_A(x, z, mu)
        y = [
            f(x);
            sqrt(mu) * g(x) + (1/(2*sqrt(mu)) * z)
        ];
    end

    % Initialization
    x = [0; 0; 0];  % Starting point
    z = [0; 0];     % Lagrange multipliers
    mu = 1;         % Penalty parameter

    % For storing history
    feasibility_residuals = [];
    optimality_residuals = [];
    mus = [];

    % Optimization options
    options = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt', 'Display', 'off');

    % Augmented Lagrangian method iteration
    for k = 1:100  % Maximum number of iterations
        % Solve the minimization problem using fminunc
        xOld = x;
        [x, ~] = lsqnonlin(@(x)L_A(x, z, mu), x, [], [], options);

        % Update z
        z = z + 2 * mu * [g1(x); g2(x)];

        % Compute residuals
        optimality_residuals(k) = norm(2*df(x)'*f(x) + dg(x)'*z);
        feasibility_residuals(k) = norm([g1(x); g2(x)]);
        mus = [mus, mu];

        % Check stopping criteria
        if feasibility_residuals(k) < 1e-5 && optimality_residuals(k) < 1e-5
            'out'
            break;
        end

        if (norm([g1(x); g2(x)]) >= 0.25 * norm([g1(xOld); g2(xOld)]))
            mu = mu * 2;
        end
        
        mus(k) = mu;
    end

    x
    optimality_residuals(1:10)'
    feasibility_residuals(1:10)'

    % Plot results
    figure;
    subplot(3,1,1);
    semilogy(feasibility_residuals);
    title('Feasibility Residual vs. Iteration');
    xlabel('Iteration');
    ylabel('Feasibility Residual');

    subplot(3,1,2);
    semilogy(optimality_residuals);
    title('Optimality Condition Residual vs. Iteration');
    xlabel('Iteration');
    ylabel('Optimality Condition Residual');

    subplot(3,1,3);
    semilogy(mus);
    title('Penalty Parameter \mu vs. Iteration');
    xlabel('Iteration');
    ylabel('Penalty Parameter \mu');
end
