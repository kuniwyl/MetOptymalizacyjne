clc;
clear;

A = [
    107 500 0;
    -107 -500 0;
    45 40 60;
    70 121 65;
    -70 -121 -65;
];
b = [
    10000;
    -5000;
    1000;
    2250;
    -2000;
];
f = [0.15 0.25 0.05];
Aeq = [];
beq = [];
lb = [0, 0, 0];
up = [10, 10, 10];
x_lin = linprog(f, A, b, Aeq, beq, lb, up);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = optimvar('x', 3, 1, 'LowerBound', lb, 'UpperBound', up);
p = optimproblem('Objective', f*x, 'ObjectiveSense', 'min');
p.Constraints.c1 = A*x <= b;
options = optimoptions('linprog', 'Algorithm', 'dual-simplex', 'OptimalityTolerance', 1e-10);
% options = optimoptions('linprog', 'Algorithm', 'interior-point',  'OptimalityTolerance', 1e-10);
sol = solve(p, 'Options', options);
x_sol_ds = sol.x;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = optimvar('x', 3, 1, 'LowerBound', lb, 'UpperBound', up);
p = optimproblem('Objective', f*x, 'ObjectiveSense', 'min');
p.Constraints.c1 = A*x <= b;
% options = optimoptions('linprog', 'Algorithm', 'dual-simplex', 'OptimalityTolerance', 1e-10);
options = optimoptions('linprog', 'Algorithm', 'interior-point',  'OptimalityTolerance', 1e-10);
sol = solve(p, 'Options', options);
x_sol_ip = sol.x;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cvx_begin quiet
    variables x1;
    variables x2;
    variables x3;

    107 * x1 + 500 * x2 <= 10000;
    107 * x1 + 500 * x2 >= 5000;
    45 * x1 + 40 * x2 + 60 * x3 <= 1000;
    70 * x1 + 121 * x2 + 65 * x3 <= 2250;
    70 * x1 + 121 * x2 + 65 * x3 >= 2000;
    
    x1 <= 10;
    x2 <= 10;
    x3 <= 10;

    minimize(0.15 * x1 + 0.25 * x2 + 0.05 * x3);
cvx_end
x_cvx = [x1; x2; x3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_lin
x_sol_ds
x_sol_ip
x_cvx













