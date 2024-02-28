clc;
clear;
close all;

file = load("Data01.mat");
t = file.t;
y = file.y;

N = size(y, 1);
M = N - 1;
D = [zeros(M, 1) eye(M)] + [-eye(M) zeros(M, 1)];
g = 11;

A = [
    eye(N) -eye(N) zeros(N, M);
    -eye(N) -eye(N) zeros(N, M);
    -D zeros(M, N) -eye(M);
    D zeros(M, N) -eye(M);
];
b = [
    y;
    -y;
    zeros(M, 1);
    zeros(M, 1);
];
f = [zeros(1, N), ones(1, N), zeros(1, M)] + g * [zeros(1, N), zeros(1, N), ones(1, M)];
x = linprog(f, A, b);

plot(t, y, '.g')
hold on;
plot(t, x(1:N), 'r')