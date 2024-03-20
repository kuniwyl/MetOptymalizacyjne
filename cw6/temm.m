function rozw4_2_fminsearch()

ts = [0.1, 1.0, 10.0]; % Wartości parametru t
x0 = [1; 1]; % Punkt startowy
xc = [1; 1]; % Centrum paraboloidy
P = (1/8)*[7, sqrt(3); sqrt(3), 5];
tol = 1e-4; % Tolerancja błędu

options = optimset('TolX', tol, 'MaxFunEvals', 1e9, 'MaxIter', 1e9);
for t = ts
    fprintf('Szukanie minimum dla t = %f\n', t);
    
    objFun = @(x) f0(x, t, xc, P);
    
    % Szukanie minimum
    [x_min, f_min] = fminsearch(objFun, x0, options);
    
    fprintf('Znalezione minimum w punkcie: [%f, %f] o wartości: %f\n', x_min(1), x_min(2), f_min);
end

end


function val = modified_log(x)
if x <= 0
    val = inf;
else
    val = log(x);
end
end

function val = f0(x, t, xc, P)
log_term = modified_log(1 - (x - xc)'*P*(x - xc));
val = t * (exp(x(1) + 3*x(2) - 0.1) + exp(-x(1) - 0.1)) - log_term;
end