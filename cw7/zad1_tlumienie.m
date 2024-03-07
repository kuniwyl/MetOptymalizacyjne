% Dane funkcji
P = [7, sqrt(3); sqrt(3), 5]/8; % Macierz P
xc = [1; 1]; % Wektor xc

% Definicja funkcji f0(x)
f0 = @(x) exp(x(1) + 3*x(2) - 0.1) + exp(-x(1) - 0.1) + (x - xc)' * P * (x - xc);

% Punkt startowy
x0 = [2; -2];

% Dokładność rozwiązania
epsilon = 1e-4;

% Procedura backtracking line search
alpha = 0.5;
beta = 0.5;

% Metoda Newtona
x = x0;
g = gradient_f0(x, P, xc);
v = -inv(hessian_f0(x,P))*g;
dek_N = -g'*v;
while norm(g) > epsilon
    s = 1;
    while f0(x+s*v) > f0(x) +s*alpha*g'*v;
        s = beta * s;
        s;
    end
    x = x + s*v;
    dek_N = -g'*v;
    g = gradient_f0(x, P, xc);
    v = -inv(hessian_f0(x,P))*g;
    f_value = f0(x);
    x
    f_value
end

% Definicje gradientu i hesjanu
function g = gradient_f0(x, P, xc)
    g = [exp(x(1)+3*x(2)-0.1) - exp(-x(1)-0.1) ; 3*exp(x(1)+3*x(2)-0.1)] + 2*P*(x - xc);
end

function H = hessian_f0(x, P)
    H = [exp(x(1)+3*x(2)-0.1) + exp(-x(1)-0.1), 3*exp(x(1)+3*x(2)-0.1); 3*exp(x(1)+3*x(2)-0.1), 9*exp(x(1)+3*x(2)-0.1)]+2*P;
end
