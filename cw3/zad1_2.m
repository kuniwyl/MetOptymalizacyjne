clc;
clear;
close all;

file = load("Data01.mat");
t = file.t;
y = file.y;

N = size(y, 1);
M = N - 1;
D = [zeros(M, 1) eye(M)] + [-eye(M) zeros(M, 1)];
g = 1.5;

cvx_begin quiet 
    variable v(N)

    minimize(norm(y - v, 2) + g * norm(D * v, 1));
cvx_end

plot(t, y, '.g');
hold on;
plot(t, v, 'r');