clc;
clear;

file = load("Data01.mat");
t = file.t;
y = file.y;

% O = [a, b]
% s = [x1, x2, x3, ....

N = size(y, 1);
c = [zeros(N, 1), ones(N, 1)];
O = [t, ones(N, 1)];
I = eye(N);

A = [
    O -I;
    -O -I;
];
b = [
    y;
    -y;
];
f = [zeros(1, 2), ones(1, N)];
x_lp = linprog(f, A, b);
v_lp = x_lp(1) * t + x_lp(2);

O_mp = pinv(O);
x_ls = O_mp * y;
v_ls = x_ls(1) * t + x_ls(2);

x_lp = x_lp(1:2);
x_lp
x_ls

y_for_plot = y;
y_for_plot(34) = (y(33) + y(35)) / 2;
y_for_plot(90) = (y(89) + y(91)) / 2;

plot(t, y_for_plot, '.r');
hold on;
plot(t, v_lp, 'black');
plot(t, v_ls, 'blue');