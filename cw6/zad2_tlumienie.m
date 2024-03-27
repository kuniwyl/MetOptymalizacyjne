clc; clear; close all;

% Dane funkcji
P = [7, sqrt(3); sqrt(3), 5]/8; % Macierz P
xc = [1; 1]; % Wektor xc
<<<<<<< HEAD
t = 0.1;
%t = 1;
%t = 10;

=======
t = 10;
>>>>>>> 04c60a93a74e7b155689bf9b1c70b0700158bdc3
% Definicja funkcji f0(x)
f0 = @(x) t * (exp(x(1) + 3*x(2) - 0.1) + exp(-x(1) - 0.1)) - countLog(1 - (x - xc)' * P * (x - xc));

% Punkt startowy
x0 = [1; 1];

% Dokładność rozwiązania
epsilon = 1e-4;

% Procedura backtracking line search
alpha = 0.3;
beta = 0.8;

% Metoda Newtona
x = x0;
g = gradient_f0(x, P, xc,t);
v = -inv(hessian_f0(x,P,xc, t))*g;
dek_N = -(g')*v;
 f0(x);

while dek_N > epsilon
    s = 1;
    while countLog(1 - (x + s * dek_N - xc)'*P*(x + s * dek_N - xc)) == inf || f0(x+s*v) > (f0(x) + s*alpha*g'*v)
        f0(x+s*v);
        s = beta * s;
    end
    x = x + s*v;
    dek_N = -g'*v;
    g = gradient_f0(x, P, xc,t);
    v = -inv(hessian_f0(x,P,xc, t))*g;
    f_value = f0(x);
end

disp(['Optimal point: ', mat2str(x)]);
disp(['Optimal point: ', mat2str(x)]);

% fminsearch
options = optimset('Display', 'iter', 'TolFun', epsilon);
[x_fmin, fval_fmin] = fminsearch(f0, x0,options);

disp(['fminsearch Optimal point: ', mat2str(x_fmin)]);
options = optimset('Display', 'iter', 'TolFun', epsilon);
[x_fmin, fval_fmin] = fminsearch(f0, x0,options);

disp(['fminsearch Optimal point: ', mat2str(x_fmin)]);


f0 = t * (exp(x(1) + 3*x(2) - 0.1) + exp(-x(1) - 0.1)) - log(1 - (x - xc)'*P*(x - xc));
% CVX
cvx_begin
    variable x(2);
    % Cel optymalizacji
    minimize(t * (exp(x(1) + 3*x(2) - 0.1) + exp(-x(1) - 0.1)) - log(1 - (x - xc)'*P*(x - xc)));
    minimize(t * (exp(x(1) + 3*x(2) - 0.1) + exp(-x(1) - 0.1)) - log(1 - (x - xc)'*P*(x - xc)));
    % Ograniczenie
cvx_end

% Display the results
disp(['CVX Optimal point: ', mat2str(x)]);

% Display the results
disp(['CVX Optimal point: ', mat2str(x)]);

% Definicje gradientu i hesjanu
function g = gradient_f0(x, P, xc, t)
    g = t*[exp(x(1) + 3*x(2) - 0.1) - exp(-x(1) - 0.1); 
        3 * exp(x(1) + 3*x(2) - 0.1)] ...
        + 2*P*(x - xc)/(1 - (x-xc)'*P*(x-xc));
end

function H = hessian_f0(x, P,xc, t)
    H = t*[ exp(x(1)+3*x(2)-0.1) + exp(-x(1)-0.1),  3*exp(x(1)+3*x(2)-0.1); 
            3*exp(x(1)+3*x(2)-0.1),                 9*exp(x(1)+3*x(2)-0.1)] ...
    +(4*P*(x-xc)*(x-xc)'*P)/((1-(x-xc)'*P*(x-xc))^2)...
    +2*P/(1-(x-xc)'*P*(x-xc));
end

function v = countLog(x)
    if x <= 0
        v = inf;
    else
        v = log(x);
    end
end




