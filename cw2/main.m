clc;
clear;

file = load("main2\isoPerimData.mat");

C = file.C;
F = file.F;
L = file.L;
N = file.N;
a = file.a;
y_fixed = file.y_fixed;
h = a / N;

y_fixed(F);
y_maximize_with_limit = maximize_with_limit(N, L, C, F, h, y_fixed);
y_minimize_with_nagative = minimize_with_nagative(N, L, C, F, h, y_fixed);
y_minimize_without_nagative = minimize_without_nagative(N, L, C, F, h, y_fixed);
y_maximize_without_limit = maximize_without_limit(N, L, C, F, h, y_fixed);

fprintf('maximize A = %f \n', h * sum(y_maximize_with_limit(:, 1)))
fprintf('minimize A = %f \n', h * sum(y_minimize_with_nagative(:, 1)))
fprintf('minimize without negative A = %f \n', h * sum(y_minimize_without_nagative(:, 1)))
fprintf('maximize without limited curve A = %f \n', h * sum(y_maximize_without_limit(:, 1)))

x = linspace(0, a, N + 1);

subplot(1,4,1);
plot(x, y_maximize_with_limit(:, 1));
hold on;
grid on;
xlabel('x/a');
ylabel('y(x)');
title('maksymalizacja')
plot(x(F), y_fixed(F), 'ro');

subplot(1,4,2);
plot(x, y_minimize_with_nagative(:, 1));
hold on;
grid on;
xlabel('x/a');
ylabel('y(x)');
title('minimalizacja')
plot(x(F), y_fixed(F), 'ro');

subplot(1,4,3);
plot(x, y_minimize_without_nagative(:, 1));
hold on;
grid on;
xlabel('x/a');
ylabel('y(x)');
title('minimalizacja bez negatywów')
plot(x(F), y_fixed(F), 'ro');

subplot(1,4,4);
plot(x, y_maximize_without_limit(:, 1));
hold on;
grid on;
xlabel('x/a');
ylabel('y(x)');
title('maksymalizacja bez ograniczeń')
plot(x(F), y_fixed(F), 'ro');
