clc; clear;
p = 1/8*[7, sqrt(3);sqrt(3), 5];
% Define the optimization function with its variables
f = @(x) exp(x(1)+3*x(2)-0.1)+exp(-x(1)-0.1)+(x-[1;1])'*p*(x-[1;1]);
% Define the gradient of the function
grad_f = @(x) [exp(x(1)+3*x(2)-0.1)-exp(-x(1)-0.1); 3*exp(x(1)+ 3*x(2)-0.1)] + 2*p*(x-[1;1]);

% Initial conditions
x = [2; -2];
H = eye(2);
alpha = 0.5;
beta = 0.5;
tol = 1e-4;

iter = 0;

% Quasi-Newton method loop
maxIter = 10000; % For example
while true && iter < maxIter
    g = grad_f(x);
    if norm(g) < tol
        break;
    end
    
    % Update direction using Hessian approximation
    p = -H*g;
    
    % Line search (Backtracking)
    t = 1;
    while f(x + t*p) > f(x) + alpha*t*g'*p
        t = beta*t;
    end
    
    % Update x
    s = t*p;
    x_new = x + s;
    
    % Update gradient and Hessian approximation
    y = grad_f(x_new) - g;
    del_x = x_new - x;
    
    rho = 1/(y'*s);
    % Poprawka rzędu jeden
    H_new = H + ((del_x - H*y)*(del_x - H*y)') / ((del_x - H*y)'*y);

    % Poprawka Davidona-Fletchera-Powella DFP
    %H_new = H + (del_x*del_x') / (del_x'*y) - (H*y)*(H*y)' / (y'*H*y);

    %poprawka Broydena-Fletchera-Goldfarba-Shanno (BFGS) wersja z innych źródeł
    %H_new = H - (H*y*(H*y)') / (y'*H*y) + (del_x*del_x') / (del_x'*y) ...
      %  + ((del_x*y'*H + H*y*del_x') / (y'*H*y));
    H = H_new;
    
    x = x_new;
end

% Display the result
disp('Optimal x:');
disp(x);
disp('Optimal function value:');
disp(f(x));

% Zadanie 2
clear;
% Define the optimization function with its variables
f = @(x) 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;
% Define the gradient of the function
grad_f = @(x) [-400*x(1)*(x(2) - x(1)^2) - 2*(1 - x(1));
    200*(x(2) - x(1)^2)];

% Initial conditions
x = [0; 0];
H = eye(2);
alpha = 0.5;
beta = 0.5;
tol = 1e-4;

iter = 0;

% Quasi-Newton method loop
maxIter = 10000; % For example
while true && iter < maxIter
    g = grad_f(x);
    if norm(g) < tol
        break;
    end
    
    % Update direction using Hessian approximation
    p = -H*g;
    
    % Line search (Backtracking)
    t = 1;
    while f(x + t*p) > f(x) + alpha*t*g'*p
        t = beta*t;
    end
    
    % Update x
    s = t*p;
    x_new = x + s;
    
    % Update gradient and Hessian approximation
    y = grad_f(x_new) - g;
    del_x = x_new - x;
    
    rho = 1/(y'*s);
    % Poprawka rzędu jeden
    %H_new = H + ((del_x - H*y)*(del_x - H*y)') / ((del_x - H*y)'*y);

    % Poprawka Davidona-Fletchera-Powella DFP
    H_new = H + (del_x*del_x') / (del_x'*y) - (H*y)*(H*y)' / (y'*H*y);

    %poprawka Broydena-Fletchera-Goldfarba-Shanno (BFGS) wersja z innych źródeł
    %H_new = H - (H*y*(H*y)') / (y'*H*y) + (del_x*del_x') / (del_x'*y) + ((del_x*y'*H + H*y*del_x') / (y'*H*y));
    H = H_new;
    x = x_new;
end

% Display the result
disp('Optimal x:');
disp(x);
disp('Optimal function value:');
disp(f(x));
