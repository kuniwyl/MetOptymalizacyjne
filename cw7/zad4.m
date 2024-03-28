% Wczytanie danych
load('twoInertialData.mat'); % Załóżmy, że plik zawiera zmienne t i y

% Początkowe przybliżenia parametrów [k, T1, T2]
% Ustawiamy je zgodnie z oczekiwanymi rozwiązaniami.
initialParams = [1, 1.1, 1];
% initialParams = [2.38, 2.45, 2.32];

% Optymalizacja za pomocą funkcji lsqnonlin (metoda Levenberga-Marquardta)
options = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt', 'Display', 'iter');

% Definicja funkcji residualnej jako funkcji anonimowej
funResiduals = @(params) params(1) * (1 - (1/(params(2)-params(3))) * ...
    (params(2) * exp(-t / params(2)) - params(3) * exp(-t / params(3)))) - y;

% Przeprowadzenie optymalizacji
[paramEstimates, resnorm, residual, exitflag, output] = lsqnonlin(funResiduals, initialParams, [], [], options);

% Wypisanie wyników
k_est = paramEstimates(1);
T1_est = paramEstimates(2);
T2_est = paramEstimates(3);
fprintf('Oszacowane wzmocnienie k: %f\n', k_est);
fprintf('Oszacowana stała czasowa T1: %f\n', T1_est);
fprintf('Oszacowana stała czasowa T2: %f\n', T2_est);

% Generowanie wykresów
t_fit = linspace(min(t), max(t), 100);
y_fit = k_est * (1 - (1/(T1_est-T2_est)) * ...
    (T1_est * exp(-t_fit / T1_est) - T2_est * exp(-t_fit / T2_est)));

figure;
plot(t, y, 'bo'); % Dane eksperymentalne
hold on;
plot(t_fit, y_fit, 'r-'); % Dopasowana krzywa
xlabel('Czas t [s]');
ylabel('Odpowiedź skokowa h(t)');
legend('Dane eksperymentalne', 'Dopasowana krzywa');
title('Dopasowanie odpowiedzi skokowej systemu podwójnie bezwładnościowego');
grid on;