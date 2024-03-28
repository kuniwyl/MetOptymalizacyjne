clc; clear; close all;

% Wczytanie danych
load('inertialData.mat'); % Załóżmy, że plik zawiera zmienne t i y

% Początkowe przybliżenia parametrów [k, T]
initialParams = [1, 1]; 

% Optymalizacja za pomocą funkcji lsqnonlin (metoda Levenberga-Marquardta)
options = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt', 'Display', 'iter');

% Definicja funkcji residualnej jako funkcji anonimowej
funResiduals = @(params) params(1) * (1 - exp(-t / params(2))) - y;

[paramEstimates, resnorm, residual, exitflag, output] = lsqnonlin(funResiduals, initialParams, [], [], options);

% Wypisanie wyników
k_est = paramEstimates(1);
T_est = paramEstimates(2);
fprintf('Oszacowane wzmocnienie k: %f\n', k_est);
fprintf('Oszacowana stała czasowa T: %f\n', T_est);

% Generowanie wykresów
t_fit = linspace(min(t), max(t), 100);
y_fit = k_est * (1 - exp(-t_fit / T_est));

figure;
plot(t, y, 'bo'); % Dane eksperymentalne
hold on;
plot(t_fit, y_fit, 'r-'); % Dopasowana krzywa
xlabel('Czas t');
ylabel('Odpowiedź skokowa y(t)');
legend('Dane eksperymentalne', 'Dopasowana krzywa');
title('Dopasowanie metodą Levenberga-Marquardta');
grid on;