clc; clear all; close all;

% Definicja funkcji φ(s)
phi = @(s) 40 * s.^3 + 20 * s.^2 - 44 * s + 29;

% Definicja funkcji afinicznej
l = @(s, alpha) 29 - alpha * 44 * s;

% Wartość alpha
alpha = 0.4;
beta = 0.9;

% Wartości s
s_values = linspace(0, 2.5, 1000);

% Obliczenie wartości funkcji dla danej wartości alpha
l_values = l(s_values, alpha);
phi_values = phi(s_values);

% Generowanie wykresu
figure;
hold on;
ylim([-30, 50]);

% Wykres funkcji φ(s)
phiP = plot(s_values, phi_values, 'DisplayName', '\phi(s) = 40s^3+20^s-44s+29');
% Wykres funkcji afinicznej l(s, alpha)
p_black = plot(s_values, l(s_values, 0.0), 'black', 'DisplayName', 'y = \phi(0) + \alpha\phi(0)s');
plot(s_values, l(s_values, 0.1), 'black');
plot(s_values, l(s_values, 0.2), 'black');
plot(s_values, l(s_values, 0.3), 'black');
plot(s_values, l(s_values, 0.4), 'black');
plot(s_values, l(s_values, 0.5), 'black');
plot(s_values, l(s_values, 1.0), 'black');

% Dodanie etykiet dla osi x, y i tytułu wykresu
xlabel('s');
ylabel('Wartość');
title('Porównanie funkcji \phi(s) i l(s, \alpha) dla danego \alpha');
grid on;

% Wykonaj pętlę while
s = 1;
while phi(s) >= l(s,alpha)
    % Dodanie punktu na wykresie funkcji φ(s)
    plot(s, phi(s), 'ro');
    % Dodanie punktu na wykresie funkcji l(s, alpha)
    plot(s, l(s, alpha), 'go');
    % Aktualizacja wartości s
    s = beta * s;
end
% Dodanie punktu na wykresie funkcji φ(s)
plot(s, phi(s), 'ro');
% Dodanie punktu na wykresie funkcji l(s, alpha)
plot(s, l(s, alpha), 'go');
s
legend([phiP, p_black], 'Location', 'best');
hold off;
