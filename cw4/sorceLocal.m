clc;
clear;
close all;

% Dane wejściowe
m = 5;
n = 2;
y = [1.8 2.5; 2.0 1.7; 1.5 1.5; 1.5 2.0; 2.5 1.5];
d = [2.00, 1.24, 0.59, 1.31, 1.44]';

% Macierze i wektory pomocnicze
A = [-2 * y ones(m, 1)];
b = [d.^2 - vecnorm(y, 2, 2).^2];
Q = [1 0 0; 0 1 0; 0 0 0];
c = [0; 0; -0.5];

% Zadanie optymalizacyjne
cvx_begin sdp quiet
    variable t;
    variable mi;
    minimize(t - norm(b)^2);
    subject to 
        [A' * A + mi * Q, A' * b - mi * c;
            (A' * b - mi * c)', t] >= 0;
cvx_end

a = (A'*A + mi*Q);
b = (A'*b - mi*c);
z = a \ b;
x = z(1:2)

% Generowanie siatki punktów na płaszczyźnie
s = 100;
X = linspace(0, 3, s);
Y = linspace(0, 3, s);
[X, Y] = meshgrid(X, Y);
Z = zeros(s);
for i=1:s
    for j=1:s
        t_s = 0;
        x_elem = X(i,j);
        y_elem = Y(i,j);
        for k=1:5
            t_s = t_s + (norm([x_elem - y(k,1), y_elem - y(k,2)])^2 - d(k)^2)^2;
        end
        Z(i,j) = t_s;
    end
end

% Wygenerowanie wykresu poziomic funkcji celu
figure;
contour(X, Y, Z, 50);
hold on;

% Zaznaczenie położeń sensorów
scatter(y(:, 1), y(:, 2), 'ro', 'filled', 'DisplayName', 'Sensory');
scatter(x(1), x(2), 'blacko', 'filled', 'DisplayName', 'Source');

xlabel('x');
ylabel('y');
title('Wykres poziomic funkcji celu');
legend('Location', 'Best');
grid on;
