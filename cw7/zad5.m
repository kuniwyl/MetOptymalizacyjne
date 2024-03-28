clc; clear; close all;

% Wczytanie danych pomiarowych
load('reductionData.mat'); % Załóżmy, że plik zawiera zmienne 't' i 'y'

% Początkowe przybliżenia parametrów [k, gamma, beta]
initialParams = [1, 1, 1]; % Ustawienie wstępnych wartości parametrów

% Definicja modelu oscylacyjnego zgodnie z równaniem (60)
h_osc = @(params, t) params(1) * (1 - exp(-params(2)*t) .* (params(2)/params(3) * cos(params(3)*t) + sin(params(3)*t)/params(3)));

% Funkcja rezydualna, która oblicza różnicę między modelem a danymi
residuals = @(params) h_osc(params, t) - y;

% Opcje dla algorytmu Levenberga-Marquardta
options = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt', 'Display', 'iter');

% Wykonanie dopasowania modelu do danych za pomocą funkcji lsqnonlin
[paramEstimates, resnorm, residual, exitflag, output] = lsqnonlin(residuals, initialParams, [], [], options);

% Oszacowane parametry
k_est = paramEstimates(1);
gamma_est = paramEstimates(2);
beta_est = paramEstimates(3);

% Wyniki
fprintf('Oszacowane wzmocnienie k: %f\n', k_est);
fprintf('Oszacowany parametr gamma: %f\n', gamma_est);
fprintf('Oszacowany parametr beta: %f\n', beta_est);

% Generowanie danych do wykresu
t_fit = linspace(min(t), max(t), 100);
y_fit = h_osc(paramEstimates, t_fit);

% Rysowanie wykresu
figure;
plot(t, y, 'b.'); % Dane eksperymentalne
hold on;
plot(t_fit, y_fit, 'r-'); % Dopasowana krzywa
xlabel('Czas t [s]');
ylabel('Odpowiedź skokowa h(t)');
legend('Dane eksperymentalne', 'Dopasowana krzywa');
title('Dopasowanie odpowiedzi skokowej drugiego rzędu');
grid on;

% Zakończenie procesu optymalizacji
if exitflag == 1
    disp('Algorytm osiągnął rozwiązanie.');
else
    disp('Algorytm nie osiągnął rozwiązania, sprawdź dane wejściowe lub zmień parametry początkowe.');
end