function [x_opt, t_final, num_iterations] = solveLPwithSBM(A, b, c, t_init, gamma, epsilon)
    x_0 = findFeasibleStartingPoint(A, b);
    [x_opt, t_final, num_iterations] = sequentialBarrierMethod(A, b, c, t_init, gamma, epsilon, x_0);
end