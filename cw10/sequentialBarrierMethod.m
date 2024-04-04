function [x_opt, t, k, central_points] = sequentialBarrierMethod(A, b, c, t_init, gamma, epsilon, x_0)
    k = 0;
    t = t_init;
    m = size(A, 1);
    
    central_points = zeros(length(x_0), 1000);
    
    objectiveFunction = @(x, t) c'*x - (1/t)*sum(log(b - A*x));
    gradient = @(x, t) c + A'*(1./(b - A*x))/t;
    hessian = @(x, t) A'*diag(1./((b - A*x).^2))*A/t;
    
    while true
        
        grad = @(x) gradientLogBarrier(x, A, b);
        hess = @(x) hessianLogBarrier(x, A, b);
        
        [x_k, ~] = newtonMethodDamping(x_0, epsilon, 0.01, 0.5, @(x) objectiveFunction(x, t), grad, hess);
        
        central_points(:, k+1) = x_k;
        
        if m/t <= epsilon
            x_opt = x_k;
            break;
        end
        
        t = gamma * t;
        x_0 = x_k;
        k = k + 1;
    end
    
    central_points = central_points(:, 1:k);
end
    
function grad_phi = gradientLogBarrier(x, A, b)
    grad_phi = -A' * (1./(b - A*x));
end
    
function hess_phi = hessianLogBarrier(x, A, b)
    m = size(A, 1);
    hess_phi = zeros(size(A,2), size(A,2));
    for i = 1:m
        ai = A(i,:)';
        bi = b(i);
        hess_phi = hess_phi + (ai * ai') / (bi - ai'*x)^2;
    end
end
