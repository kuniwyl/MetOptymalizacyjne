clc; clear; close all;

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

[X, Y] = meshgrid(-5:0.1:5, -5:0.1:5);
for i=1:size(X,1)
    for j=1:size(Y,1)
        Z(i,j) = f0([X(i,j); Y(i,j)]);
    end
end

figure;  
hold on;

% Metoda Newtona
x = x0;
plot(x(1), x(2), 'ro');
g = gradient_f0(x, P, xc);
v = -inv(hessian_f0(x,P))*g;
dek_N = -g'*v;
while dek_N > epsilon
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

    plot(x(1), x(2), 'ro'); % Punkty iteracyjne
    % Dodanie poziomicy przechodzącej przez punkt iteracyjny
    contour(X, Y, Z, [f_value, f_value], 'LineColor', 'b', levels=250);

    % Dodanie etykiety z wartością na poziomicach
    text(x(1), x(2), num2str(f_value), 'Color', 'red', 'FontSize', 10);
end

contour(X, Y, Z, [2.47, 2.47], 'LineColor', 'b');
contour(X, Y, Z, [3.62,3.62], 'LineColor', 'b');
contour(X, Y, Z, [5.34, 5.34], 'LineColor', 'b');
contour(X, Y, Z, [7.59, 7.59], 'LineColor', 'b');
contour(X, Y, Z, [19.2, 19.2], 'LineColor', 'b');
contour(X, Y, Z, [50, 50], 'LineColor', 'b');
contour(X, Y, Z, [200, 200], 'LineColor', 'b');
contour(X, Y, Z, [600, 600], 'LineColor', 'b');
ylim([-2, 2]);
xlim([-4, 3]);

hold off
title('Wykres poziomic i punkty iteracyjne');
xlabel('x');
ylabel('y');
x_Newton = x
x_Newton_value = f0(x)


% CVX
cvx_begin quiet
    variable x(2)
    minimize(f0(x))
cvx_end
x_CVX = x
x_CVX_value = f0(x)

% fminsearch
[x_fmin, fval_fmin] = fminsearch(f0, x0);
x_fminsearch = x_fmin
x_fminsearch_value = fval_fmin


hold off;
grid on;

% Definicje gradientu i hesjanu
function g = gradient_f0(x, P, xc)
    g = [exp(x(1)+3*x(2)-0.1) - exp(-x(1)-0.1) ; 3*exp(x(1)+3*x(2)-0.1)] + 2*P*(x - xc);
end

function H = hessian_f0(x, P)
    H = [exp(x(1)+3*x(2)-0.1) + exp(-x(1)-0.1), 3*exp(x(1)+3*x(2)-0.1); 3*exp(x(1)+3*x(2)-0.1), 9*exp(x(1)+3*x(2)-0.1)]+2*P;
end
