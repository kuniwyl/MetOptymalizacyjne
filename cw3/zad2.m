clc;
clear;
close all;

file = load("Data01.mat");
t = file.t;
y = file.y;

% plot(t, y, '.r');
% hold on;

N = size(y, 1);
M = N - 1;
D1 = eye(M);
D1 = [zeros(M, 1) D1];
D2 = -eye(M);
D2 = [D2 zeros(M, 1)];
D = D1 + D2;

q = 1000;
A = [
    eye(N) -eye(N) zeros(N, M);
    -eye(N) -eye(N) zeros(N, M);
    zeros(1, N) zeros(1, N) ones(1, M);
    -D zeros(M, N) -eye(M);
    D zeros(M, N) -eye(M);
];
b = [
    y;
    -y;
    q;
    zeros(M, 1);
    zeros(M, 1);
];
f = [];

x = linprog(f, A, b);
x = x(N:2*N - 1, 1);

plot(t, x)
