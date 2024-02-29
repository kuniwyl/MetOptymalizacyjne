clc;
clear;
close all;

file = load("LM01Data.mat");
t = file.t;
y = file.y;
t

N = 3;
n = 80;
x = ones(N, n + 1)';
l = ones(n, 1);

alfa_f = @(x, t) x(2)*t + x(3);
dj_f = @(x) [sin(alfa_f(x)), x(1) * t .* cos(alfa_f(x)), x(1) * cos(alfa_f(x))];
f_f = @(x) x(1) * sin(alfa_f(x)) - y;

k = 1;
while k <= n
    j = dj_f(x(:, k));
    f = f_f(x(:, k));
    x(:, k + 1) = x(:, k) - inv([j' * j + l(k) * eye(N)]) * j' * f;

    if norm(f_f(x(:, k + 1)), 2) < norm(f_f(x(:, k)), 2)
        l(k + 1) = 0.8 * l(k);
    else
        l(k + 1) = 2 * l(k);
        x(:, k + 1) = x(:, k);
    end
    k = k + 1;
end

x_1 = x(:, 1);
x_1
y_1 = x_1(1) * sin(x_1(2) * t + x_1(3));

x_kon = x(:, n);
x_kon
y_x = x_kon(1) * sin(x_kon(2) * t + x_kon(3));

subplot(3,1,1);
plot(t, y_x, 'black');
hold on;
plot(t, y, '.g');
plot(t, y_1, 'red');

subplot(3,1,2);
k_v = (1:k);
plot(k_v, l, 'oblack');

subplot(3,1,3);
f = f_f(x)
% f = norm(f_f(x(:, k_v)), 2);
plot(k_v, f);
