function augmented_lagrangian_task_lsq

    function y = f(x)
        y = [x(1) + exp(-x(2)); x(1)^2 + 2*x(2) + 1];
    end

    function grad = df(x)
        % Gradient of f(x)
        grad = [1 + 2*x(1), -exp(-x(2)); 0, 2];
    end

    function y = g(x)
        y = x(1) + x(1)^3 + x(2) + x(2)^2;
    end

    function grad = dg(x)
        % Gradient of g(x)
        grad = [1 + 3*x(1)^2, 1 + 2*x(2)];
    end

    % Augmented Lagrangian
    function y = L_A(x, z, mu)
        y = [
            f(x);
            sqrt(mu) * g(x) + (1/(2*sqrt(mu)) * z)
        ];
        %y = norm(f(x))^2 + z*g(x) + mu*norm(g(x))^2;
    end

    % Objective function for lsqnonlin
    function y = obj_fun(x, z, mu)
        y = norm(L_A(x, z, mu))^2;
    end

    % Initialization
    k_max = 10;
    x = [0.5; -0.5];  % Starting point
    % Bad data in task: in task z = 1 which produce bad results
    z = 0;            % Lagrange multiplier
    mu = 1;           % Penalty parameter
    res_x = zeros(k_max, 2);

    % Optimization options
    options = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt', 'Display', 'off');

    % Augmented Lagrangian method iteration
    for k = 1:k_max  % Maximum number of iterations
        % Solve the minimization problem using lsqnonlin
        oldX = x;
        res_x(k, :) = x;
        [x, ~] = lsqnonlin(@(x)obj_fun(x, z, mu), x, [], [], options);

        % Update z
        z = z + 2 * mu * g(x);

        % Store history
        optimality_residuals(k) = norm(2*df(x)'*f(x) + dg(x)'*z);
        feasibility_residuals(k) = norm(g(x));
        
        if (norm(g(x)) >= 0.25 * norm(g(oldX)))
            mu = mu * 2;
        end
        
        mus(k) = mu;
    end


    [X,Y] = meshgrid(-3:0.01:3);
    for i=1:size(X,1)
        for j=1:size(Y,1)
            Z(i,j) = norm(f([X(i,j); Y(i,j)]))^2;
            g_Z(i,j) = g([X(i,j); Y(i,j)]);
        end
    end
    figure;  
    hold on; grid on;
    xlim([-1, 1]); ylim([-1, 1]);
    for i=1:size(res_x)
        plot(res_x(i, 1), res_x(i, 2), 'ro');
    end
    contour(X, Y, g_Z, 'LineColor', 'r');
    for i = 2:2:16
        contour(X, Y, Z, [i, i], 'LineColor', 'b');
    end
    
    res_x

    k = (1:k_max)';
    log10_FR = log(feasibility_residuals');
    log10_OR = log(optimality_residuals');
    t = table(k, log10_FR, log10_OR);
    t

end
