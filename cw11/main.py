import numpy as np
from scipy.optimize import fsolve
import matplotlib.pyplot as plt

# Define the objective function and constraints
def fun(x):
    return np.array([(x[0] - 1)**2, (x[1] - 1)**2, (x[2] - 1)**2])

def g1(x):
    return x[0]**2 + 0.5*x[1]**2 + x[2]**2 - 1

def g2(x):
    return 0.8*x[0]**2 + 2.5*x[1]**2 + x[2]**2 + 2*x[0]*x[2] - x[0] - x[1] - x[2] - 1

# Augmented Lagrangian Method
def levenberg_marquardt(x, lambda_val, mu, fun, g1, g2):
    x_new = fsolve(lambda x: compute_equations(x, lambda_val, mu, fun, g1, g2), x, xtol=1e-8)
    lambda_new = lambda_val + mu * np.array([g1(x_new), g2(x_new)])
    return x_new, lambda_new

# Define equations for the Levenberg–Marquardt method subproblem
def compute_equations(x, lambda_val, mu, fun, g1, g2):
    return np.concatenate([jacobian(x, fun) @ fun(x) + jacobian(x, [g1, g2]).T @ lambda_val,
                           np.array([g1(x)**2 + g2(x)**2 - mu])])

# Define Jacobian matrix
def jacobian(x, fun):
    epsilon = 1e-8
    n = len(x)
    m = len(fun(x))
    J = np.zeros((m, n))
    for i in range(n):
        x_plus_epsilon = x.copy()
        x_plus_epsilon[i] = x_plus_epsilon[i] + epsilon
        J[:, i] = (fun(x_plus_epsilon) - fun(x)) / epsilon
    return J

# Initialize values
x = np.zeros(3)
z = np.zeros(2)
mu = 1
lambda_val = np.ones(2)
epsilon = 1e-5
rho = 2

# Initialize storage for residuals and penalty parameter
feasibility_residuals = []
optimality_residuals = []
penalty_parameters = []

k = 1
while True:
    # Update x using the Levenberg–Marquardt method
    x, lambda_val = levenberg_marquardt(x, lambda_val, mu, fun, g1, g2)

    # Update z and mu
    z = z + mu * np.array([g1(x), g2(x)])
    mu = rho * mu

    # Compute residuals
    feasibility_residual = np.linalg.norm(np.concatenate([g1(x), g2(x)]))
    optimality_residual = np.linalg.norm(2 * jacobian(x, fun) @ fun(x) + jacobian(x, [g1, g2]).T @ z)

    # Store residuals and penalty parameter
    feasibility_residuals.append(feasibility_residual)
    optimality_residuals.append(optimality_residual)
    penalty_parameters.append(mu)

    # Check convergence
    if feasibility_residual < epsilon and optimality_residual < epsilon:
        break

    k += 1

# Plot residuals and penalty parameter
fig, axes = plt.subplots(3, 1, figsize=(8, 12))

axes[0].plot(feasibility_residuals, 'o-')
axes[0].set_title('Feasibility Residuals')
axes[0].set_xlabel('Iteration')

axes[1].plot(optimality_residuals, 'o-')
axes[1].set_title('Optimality Residuals')
axes[1].set_xlabel('Iteration')

axes[2].plot(penalty_parameters, 'o-')
axes[2].set_title('Penalty Parameter')
axes[2].set_xlabel('Iteration')

plt.tight_layout()
plt.show()
