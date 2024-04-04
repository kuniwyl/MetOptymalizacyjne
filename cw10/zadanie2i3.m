A = [0.4873, -0.8732; 0.6072, 0.7946; 0.9880, -0.1546; -0.2142, -0.9768; -0.9871, -0.1601; 0.9124, 0.4093];
b = [1; 1; 1; 1; 1; 1];
c = [-0.5; 0.5];

x_0 = findFeasibleStartingPoint(A, b);  
t_init = 1;
gamma = 2.5;
epsilon = 1e-6;

[x_opt, t_final, num_iterations, central_points] = sequentialBarrierMethod(A, b, c, t_init, gamma, epsilon, x_0);

disp(['Rozwiązanie x_opt: ', mat2str(x_opt)]);
disp(['t_final: ', num2str(t_final)]);
disp(['Liczba iteracji: ', num2str(num_iterations)]);


x1_range = linspace(-2.5, 2, 400);
x2_range = linspace(-1.5, 3, 400);
[X1, X2] = meshgrid(x1_range, x2_range);


figure;
hold on;
title('Rysunek 5');
xlabel('x_1');
ylabel('x_2');

for i = 1:size(A,1)
    ai = A(i,:);
    bi = b(i);
    
    % Przecięcia i rysowanie linii
    x1_intercept = (bi - ai(2)*x2_range) / ai(1);
    x2_intercept = (bi - ai(1)*x1_range) / ai(2);
    
    plot(x1_intercept, x2_range, 'k--', 'LineWidth', 1);
    plot(x1_range, x2_intercept, 'k--', 'LineWidth', 1);
end

% Wierzchołki obszaru dopuszczalnego
V = [0.1562 0.9127 1.0338 0.8086 -1.3895 -0.8782;
    -1.0580 -0.6358 0.1386 0.6406 2.3203 -0.8311];
k = convhull(V(1,:),V(2,:));
fill(V(1,k),V(2,k),[0.8 0.8 0.8],'EdgeColor','none');
alpha(0.5);

% Do tego punktu dążymy
plot(0.9126, -0.6359, 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 8);

axis([-2.5 2 -1.5 3]);
hold off;


figure;
hold on;
title('Rysunek 6');

% policzenie wartości funkcji bariery
BarrierFunction = @(x1, x2) -sum(log(b - A * [x1; x2]));

% wartości funkcji bariery
Z = zeros(size(X1));

% policzenie wartości funkcji bariery tylko dla punktów w obszarze dopuszczalnym
for i = 1:numel(X1)
    if all(A * [X1(i); X2(i)] < b)
        Z(i) = BarrierFunction(X1(i), X2(i));
    else
        Z(i) = NaN;  % ignorujemy punkty spoza obszaru dopuszczalnego
    end
end

% Mapa cieplna
contourf(X1, X2, Z, 50, 'LineColor', 'none');
colorbar;
colormap jet;

%Wynik SBM
plot(x_opt(1), x_opt(2), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);

% Punkt startowy
plot(x_0(1), x_0(2), 'ks', 'MarkerFaceColor', 'k', 'MarkerSize', 8);

% Minima iteracji zewnętrznych
for i = 1:num_iterations
    plot(central_points(1,i), central_points(2,i), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);
end

% Linie poziome funkcji celu
[C, h] = contour(X1, X2, c(1)*X1 + c(2)*X2, 10, 'k--', 'LineWidth', 1);
clabel(C, h, 'FontSize', 8);


xlabel('x1');
ylabel('x2');
axis square;
grid on;
hold off;