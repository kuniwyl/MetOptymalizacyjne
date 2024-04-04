function [x_min, iter] = newtonMethodDamping(x0, tol, alpha, beta, f, grad, hess)
x = x0;
iter = 0;

while true
    G = grad(x);
    H = hess(x);
    
    epsilon = 1e-6;
    H_reg = H + epsilon * eye(length(x));
    
    dx = -H_reg\G;
    
    t = 1;
    while f(x + t*dx) > f(x) + alpha*t*G'*dx
        t = beta*t;
    end
    
    x_new = x + t*dx;
    
    if norm(x_new - x) < tol
        break;
    end
    
    x = x_new;
    iter = iter + 1;
end

x_min = x;
end
