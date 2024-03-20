clc;
clear;
close all;

k_max = 10;
X = zeros(k_max, 2);
u = ones(k_max, 1); % Initialize u
u(1) = 1;
z = zeros(k_max, 1);
z(1) = 1;
initialParams = [0.5; -0.5];
OR = zeros(k_max, 1);
FR = zeros(k_max, 1);

f = @(x) [
    x(1) + exp(-x(2)); 
    x(1)^2 + 2*x(2) + 1
];
JF = @(x) [1, -exp(-x(2)); 2*x(1), 2];

g = @(x) x(1) + x(1)^3 + x(2) + x(2)^2;
JG = @(x) [1 + 3*x(1)^2, 1 + 2*x(2)];

x = [0.5; -0.5]
JF(x)'
JG(x)'
COR = @(x, z) norm(2 * JF(x)' * f(x) + JG(x)'*z);
CFR = @(x) norm(g(x));

F0 = @(x, u, z) norm([f(x); sqrt(u) * g(x) + (1/2*sqrt(u)) * z])^2;
JF0 = @(x, u) [
    1, -exp(-x(2));
    2*x(1), 2;
    sqrt(u) * (1 + 3 * x(1)^2), sqrt(u) * (1 + 2 * x(2))];


X(1,:) = [0.5; -0.5];
for i = 1:k_max
    F0 = @(x) norm([f(x); sqrt(u(i)) * g(x) + (1/(2*sqrt(u(i)))) * z(i)])^2;
    options = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt', 'Display', 'iter');
    newX = lsqnonlin(F0, X(i, :), [], [], options);
   
    OR = COR(newX, z);


    X(i + 1, :) = newX;
    z(i + 1) = z(i) + 2 * u(i) * g(newX);
    if ( norm(g(newX)) < 0.25 * norm(g(X(i, :))) ) 
        u(i + 1) = u(i);
    else
        u(i + 1) = 2 * u(i);
    end
end
X
u
z
