clc; clear; close all;

% Dane funkcji
P = [7, sqrt(3); sqrt(3), 5]/8; % Macierz P
xc = [1; 1]; % Wektor xc
t = 0.1;
% Definicja funkcji f0(x)
f0 = @(x) t * (exp(x(1) + 3*x(2) - 0.1) + exp(-x(1) - 0.1)) - countLog(1 - (x - xc)' * P * (x - xc));

% Punkt startowy
x0 = [2; -2];

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
 f0(x)

while dek_N > epsilon
    s = 1;
    while countLog(1 - (x + s * dek_N - xc)'*P*(x + s * dek_N - xc)) == inf || f0(x+s*v) > (f0(x) + s*alpha*g'*v)
        f0(x+s*v)
        s = beta * s
    end
    x = x + s*v;
    dek_N = -g'*v;
    g = gradient_f0(x, P, xc,t);
    v = -inv(hessian_f0(x,P,xc, t))*g;
    f_value = f0(x)
end

x
f_value

%CVX
%cvx_begin
%    variable x(2)
%    minimize(f0(x))
%cvx_end
%x
%f0(x)

% fminsearch
[x_fmin, fval_fmin] = fminsearch(f0, x0);

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