function x_0 = findFeasibleStartingPoint(A, b)
    % Dodanie pomocniczej zmiennej 
    n = size(A, 2);
    A_aux = [A, -ones(size(A,1),1)]; % Powiększenie A o pomocniczą zmienną
    c_aux = [zeros(n,1); 1]; 
    
    % Rozwiązanie pomocniczego problemu
    x_aux_0 = zeros(n+1, 1); % Początkowy punkt
    t_init = 1;
    gamma = 2;
    epsilon = 1e-6;
    
    % Z SBM odnajdujemy ścisły punkt początkowy
    [x_aux, ~, ~] = sequentialBarrierMethod(A_aux, b, c_aux, t_init, gamma, epsilon, x_aux_0);
    
    if x_aux(end) < 0
        x_0 = x_aux(1:n); % Jeśli się uda to zwróć
    else
        error('Nie udało się znaleźć ścisłego punktu początkowego');
    end
end