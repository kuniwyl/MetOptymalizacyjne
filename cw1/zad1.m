clc;
clear;

A = -[
    0.8 0.3 0.1;
    0.01 0.4 0.7;
    0.15 0.1 0.2;
];
b = -[
    0.3;
    0.7;
    0.1;
];
f = [300, 500, 800];
Aeq = [];
beq = [];
lb = [0, 0, 0];
x_lin = linprog(f, A, b, Aeq, beq, lb);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = optimvar('x', 3, 1, 'LowerBound', lb);
p = optimproblem('Objective', f*x, 'ObjectiveSense', 'min');
p.Constraints.c1 = A*x <= b;
options = optimoptions('linprog', 'Algorithm', 'dual-simplex', 'OptimalityTolerance', 1e-10);
% options = optimoptions(%linprog ,’Algorithm’,’interior-point’,’OptimalityTolerance’,1e-10);
sol = solve(p, 'Options', options);
x_sol_ds = sol.x;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = optimvar('x', 3, 1, 'LowerBound', lb);
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

    0.8 * x1 + 0.3 * x2 + 0.1 * x3 >= 0.3;
    0.01 * x1 + 0.4 * x2 + 0.7 * x3 >= 0.7;
    0.15 * x1 + 0.1 * x2 + 0.2 * x3 >= 0.1;
    
    x1 >= 0;
    x2 >= 0;
    x3 >= 0;

    minimize(300 * x1 + 500 * x2 + 800 * x3);
cvx_end
x_cvx = [x1; x2; x3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_lin
x_sol_ds
x_sol_ip
x_cvx