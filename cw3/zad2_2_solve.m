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

v = optimvar('v', N, 1);
E = optimvar('E', N, 1);
Q = optimvar('Q', M, 1);

p = optimproblem('ObjectiveSense', 'min');
p.Objective = ones(1, N) * E + g * ones(1, M) * Q;
p.Constraints.c1 = v - E <= y;
p.Constraints.c2 = -v - E <= -y;
p.Constraints.c4 = -D * v -Q <= 0;
p.Constraints.c5 = D * v - Q <= 0;
options = optimoptions('linprog', 'Algorithm', 'dual-simplex', 'OptimalityTolerance', 1e-10);
sol = solve(p, 'Options', options);
x = sol.v;

plot(t, y, '.g')
hold on;
plot(t, x(1:N), 'r')