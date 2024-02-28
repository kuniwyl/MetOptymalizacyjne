clc;
clear;

A = [
    0.5 0.6 -0.01 -0.02;
    0 0 1 1;
    90 100 0 0;
    40 50 0 0;
    700 800 100 199.90
];
b = [
    0;
    1000;
    2000;
    800;
    100000;
];
% x = [lek1 lek2 sur1 sur2]
% f1 = 700 800 100 199.99
% f2 = -6500 -7100 0 0
% cel= -5800 -6300 100 199.99
f = [(700 - 6500) (800 - 7100) 100 199.90];
Aeq = [];
beq = [];
lb = [0, 0, 0, 0];
up = [];
x_lin = linprog(f, A, b, Aeq, beq, lb)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = optimvar('x', 4, 1, 'LowerBound', lb);
p = optimproblem('Objective', f*x, 'ObjectiveSense', 'min');
p.Constraints.c1 = A*x <= b;
options = optimoptions('linprog', 'Algorithm', 'dual-simplex', 'OptimalityTolerance', 1e-10);
% options = optimoptions('linprog', 'Algorithm', 'interior-point',  'OptimalityTolerance', 1e-10);
sol = solve(p, 'Options', options);
x_sol_ds = sol.x;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = optimvar('x', 4, 1, 'LowerBound', lb, 'UpperBound', up);
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
    variables x4;

    0.5 * x1 + 0.6 * x2 - 0.01 * x3 - 0.02 * x4 <= 0;
    0 * x1 + 0 * x2 + 1 * x3 + 1 * x4 <= 1000;
    90 * x1 + 100 * x2 + 0 * x3 + 0 * x4 <= 2000;
    40 * x1 + 50 * x2 + 0 * x3 + 0 * x4 <= 800;
    700 * x1 + 800 * x2 + 100 * x3 + 199.90 * x4 <= 100000;
    
    x1 >= 0;
    x2 >= 0;
    x3 >= 0;
    x4 >= 0;

    minimize((700 - 6500) * x1 + (800 - 7100) * x2 + 100 * x3 + 199.90 * x4);
cvx_end
x_cvx = [x1; x2; x3; x4];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_lin
x_sol_ds
x_sol_ip
x_cvx













