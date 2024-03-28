
close all; clear all; clc;

load('LM01Data.mat');
k_max = 35;

% Definicja funkcji modelującej
h = @(x, t) x(1) * sin(x(2) * t + x(3));
% Definicja funkcji błędu (różnica między modelem a danymi)
f = @(x) h(x, t) - y;
% Początkowe wartości parametrów modelu [A, omega, phi]
x0 = [1.0; 100*pi; 0.0];  % Apostrof oznacza transpozycję wektora
% Liczba parametrów
n = length(x0);

% Przygotowanie wykresu danych pomiarowych
figure;
plot(t, y, 's', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');
hold on;

% Rysowanie wykresu modelu z początkowymi wartościami parametrów
tPlot = linspace(min(t), max(t), 1000)';
plot(tPlot, h(x0, tPlot), 'b', 'LineWidth', 2);
grid on;

% Definicja Jakobianu
J = @(x) [sin(x(2) * t + x(3)), x(1) * t .* cos(x(2) * t + x(3)), x(1) * cos(x(2) * t + x(3))];

% Inicjalizacja przechowywania wyników
X = zeros(n, k_max + 1);
X(:, 1) = x0;

% Parametr zaufania
L = ones(k_max, 1);

% Wartości f(x)
f_war = zeros(k_max, 1);

% Główna pętla algorytmu
for k = 1:k_max
    x = X(:, k);
    xNew = x - ((J(x)' * J(x)) + L(k) * eye(n)) \ (J(x)' * f(x));
    if norm(f(xNew)) < norm(f(x))
        X(:, k + 1) = xNew;
        L(k + 1) = 0.8 * L(k); % Zmniejszenie parametru lambda
    else
        X(:, k + 1) = x;
        L(k + 1) = 2 * L(k); % Zwiększenie parametru lambda
    end
    f_war(k) = norm(f(xNew));
end

% Optymalne wartości parametrów
xOptimal = X(:, end);

% Rysowanie wykresu modelu z optymalnymi wartościami parametrów
plot(tPlot, h(xOptimal, tPlot), 'k', 'LineWidth', 2);
legend('Dane pomiarowe', 'Model początkowy', 'Model optymalny');
xlabel('Czas t [s]');
ylabel('y = A\sin(\omega t + \varphi) [a.u.]');

% Wykresy zmian parametrów w iteracjach
figure;
subplot(3, 1, 1);
plot(0:k_max, X(1, :), 'k', 'LineWidth', 2);
ylabel('A [a.u.]');

subplot(3, 1, 2);
plot(0:k_max, X(2, :), 'k', 'LineWidth', 2);
ylabel('\omega [rad/s]');

subplot(3, 1, 3);
plot(0:k_max, X(3, :), 'k', 'LineWidth', 2);
ylabel('\varphi [rad]');
xlabel('Numer iteracji');

% Wykres historii wartości parametru ufności lambda
figure;
plot(L, 'ko-');
title('Historia wartości parametru ufności \lambda');
xlabel('Numer iteracji k');
ylabel('\lambda');

% Wykres historii wartości funkcji celu
figure;
plot(f_war, 'ko-');
title('Historia wartości funkcji celu');
xlabel('Numer iteracji k');
ylabel('||f(x)||');