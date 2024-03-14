% Definicja funkcji φ(s)
phi = @(s) 20 * s.^2 - 44 * s + 29;

% Definicja funkcji afinicznej
l = @(s, alpha) 29 - alpha * 44 * s;

% Wartość alpha
alpha = 0.3;
beta = 0.9;

% Wartości s
s_values = linspace(0, 2.5, 1000);

% Obliczenie wartości funkcji dla danej wartości alpha
l_values = l(s_values, alpha);
phi_values = phi(s_values);

% Generowanie wykresu
figure;
hold on;

% Wykres funkcji φ(s)
plot(s_values, phi_values, 'DisplayName', '\phi(s)');
% Wykres funkcji afinicznej l(s, alpha)
plot(s_values, l_values, 'DisplayName', ['l(s, \alpha), \alpha = ' num2str(alpha)]);

% Dodanie etykiet dla osi x, y i tytułu wykresu
xlabel('s');
ylabel('Wartość');
title('Porównanie funkcji \phi(s) i l(s, \alpha) dla danego \alpha');

% Dodanie legendy
legend('Location', 'best');


% Wykonaj pętlę while
s = 1;
while phi(s) >= l(s,alpha)
    % Dodanie punktu na wykresie funkcji φ(s)
    plot(s, phi(s), 'ro', 'DisplayName', ['s = ' num2str(s)]);
    % Dodanie punktu na wykresie funkcji l(s, alpha)
    plot(s, l(s, alpha), 'go', 'DisplayName', ['s = ' num2str(s)]);
    % Aktualizacja wartości s
    s = beta * s;
end
% Dodanie punktu na wykresie funkcji φ(s)
plot(s, phi(s), 'ro', 'DisplayName', ['s = ' num2str(s)]);
% Dodanie punktu na wykresie funkcji l(s, alpha)
plot(s, l(s, alpha), 'go', 'DisplayName', ['s = ' num2str(s)]);
s
hold off;
