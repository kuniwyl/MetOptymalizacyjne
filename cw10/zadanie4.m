clc;
clear;
A = [0.4873, -0.8732; 0.6072, 0.7946; 0.9880, -0.1546; -0.2142, -0.9768; -0.9871, -0.1601; 0.9124, 0.4093];
b = [1; 1; 1; 1; 1; 1];
c = [-0.5; 0.5];
t_init = 1;
gamma = 2.5;
epsilon = 1e-3;
[x_opt, t_final, num_iterations] = solveLPwithSBM(A, b, c, t_init, gamma, epsilon);

disp(['Rozwiązanie x_opt: ', mat2str(x_opt)]);
