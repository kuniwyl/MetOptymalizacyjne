close all; clear all; clc;

% Wczytywanie danych pomiarowych
load('LM04Data.mat');

lambda = 1.0; % Współczynnik regularyzacji
k_max = 35; % Maksymalna liczba iteracji

% Definicja funkcji modelującej
model = @(p, t) p(1) * exp(-p(2) * t) .* sin(p(3) * t + p(4));

% Definicja funkcji błędu (różnica między modelem a danymi)
f = @(p) model(p, t) - y;

% Początkowe wartości parametrów modelu [A, omega, phi]
params = [1.0; 0.1; 1; 0.0]; % Początkowe wartości parametrów modelu [A, a, omega, phi]

% Liczba parametrów
n = length(params);

% Przygotowanie wykresu danych pomiarowych
figure;
plot(t, y, 's', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');
hold on;

tPlot = linspace(min(t), max(t), 1000)';
plot(tPlot, model(params, tPlot), 'b', 'LineWidth', 2);
grid on;

% Definicja Jakobianu
J = @(p) [exp(-p(2) * t) .* sin(p(3) * t + p(4)), ...
          -p(1) * t .* exp(-p(2) * t) .* sin(p(3) * t + p(4)), ...
          p(1) * exp(-p(2) * t) .* t .* cos(p(3) * t + p(4)), ...
          p(1) * exp(-p(2) * t) .* cos(p(3) * t + p(4))];

% Inicjalizacja przechowywania wyników
X = zeros(n, k_max + 1);
X(:, 1) = params;

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
    f_war(k) = sum(f(xNew).^2);
end

% Optymalne wartości parametrów
xOptimal = X(:, end);

% Rysowanie wykresu modelu z optymalnymi wartościami parametrów
plot(tPlot, model(xOptimal, tPlot), 'k', 'LineWidth', 2);
legend('Dane pomiarowe', 'Model początkowy', 'Model optymalny');
xlabel('Czas t [s]');
ylabel('y = A\sin(\omega t + \varphi) [a.u.]');


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

% Wyświetlanie końcowych parametrów
fprintf('A = %f, a = %f, omega = %f, phi = %f\n', xOptimal(1), xOptimal(2), xOptimal(3), xOptimal(4));