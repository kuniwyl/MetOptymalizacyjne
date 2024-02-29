clc;
clear;
close all;

file = load("LM01Data.mat");
t = file.t;
y = file.y;

N = 3;
n = 80;
x_t = zeros(N, n + 1);
l = zeros(n, 1);
l(1) = 1.0;

alfa_f = @(x) x(2)*t + x(3);
dj_f = @(x) [sin(alfa_f(x)), x(1) * t .* cos(alfa_f(x)), x(1) * cos(alfa_f(x))];
f_f = @(x) x(1) * sin(alfa_f(x)) - y;

x_t(:, 1) = ones(N, 1);
x_new = zeros(N, 1);
k = 1;
while k <= n
    x = x_t(:, k);
    j = dj_f(x);
    f = f_f(x);
    inv([j' * j + l(k) * eye(N)])
    inv([j' * j + l(k) * eye(N)]) * j'
    inv([j' * j + l(k) * eye(N)]) * j' * f
    x_new = x - inv([j' * j + l(k) * eye(N)]) * j' * f;
    x_new

    if norm(f_f(x_new), 2) < norm(f_f(x), 2)
        l(k + 1) = 0.8 * l(k);
    else
        l(k + 1) = 2 * l(k);
        x_new = x;
    end
    x_t(:, k + 1) = x_new;
    k = k + 1;
end

x_start = x_t(:, 1);
y_start = x_start(1) * sin(x_start(2) * t + x_start(3));
x_end = x_t(:, end);
y_end = x_end(1) * sin(x_end(2) * t + x_end(3));
k_v = (1:k);

subplot(3,1,1);
plot(t, y_end, 'black');
hold on;
plot(t, y, '.g');
plot(t, y_start, 'red');

subplot(3,1,2);
plot(k_v, l, 'oblack');

subplot(3,1,3)
f = zeros(k, 1);
for i = 1:k 
    f(i) = norm(f_f(x_t(:, i)), 2);
end
plot(k_v, f);
