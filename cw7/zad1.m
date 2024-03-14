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

% Początkowy rysunek
[X, Y] = meshgrid(-10:0.1:10, -10:0.1:10);
Z = sqrt((X - 0).^2 + (Y - 0).^2);

figure;  
hold on;

% Metoda Newtona
x = x0;
plot(x(1), x(2), 'ro');
g = gradient_f0(x, P, xc);
v = -inv(hessian_f0(x,P))*g;
dek_N = -g'*v;
iteration = 1; % Licznik iteracji

while norm(g) > epsilon
    x = x + v;
    dek_N = -g'*v;
    g = gradient_f0(x, P, xc);
    v = -inv(hessian_f0(x,P))*g;
    norm_g = norm(g);
    f_value = f0(x);
    f_value
    
    plot(x(1), x(2), 'ro'); % Punkty iteracyjne
    % Dodanie poziomicy przechodzącej przez punkt iteracyjny
    contour(X, Y, Z, [f_value, f_value], 'LineColor', 'b');

    % Dodanie etykiety z wartością na poziomicach
    text(x(1), x(2), num2str(f_value), 'Color', 'red', 'FontSize', 10);
end


hold off
title('Wykres poziomic i punkty iteracyjne');
xlabel('x');
ylabel('y');
x
disp("tu jest x")
% CVX
cvx_begin
    variable x(2)
    minimize(f0(x))
cvx_end
x

% fminsearch
[x_fmin, fval_fmin] = fminsearch(f0, x0);
x_fmin
fval_fmin
disp("tu jest x_min")

hold off;

% Definicje gradientu i hesjanu
function g = gradient_f0(x, P, xc)
    g = [exp(x(1)+3*x(2)-0.1) - exp(-x(1)-0.1) ; 3*exp(x(1)+3*x(2)-0.1)] + 2*P*(x - xc);
end

function H = hessian_f0(x, P)
    H = [exp(x(1)+3*x(2)-0.1) + exp(-x(1)-0.1), 3*exp(x(1)+3*x(2)-0.1); 3*exp(x(1)+3*x(2)-0.1), 9*exp(x(1)+3*x(2)-0.1)]+2*P;
end
