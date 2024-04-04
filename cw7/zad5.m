close all
clear all
clc

load("reductionData.mat")
k_max = 35;

y = y * 1000;
t = t * 1000;

% 65
h = @(x, t) x(1) * (1 - exp(-x(2) * t) .* (cos(x(3) * t) + (x(2) / x(3)) * sin(x(3) * t)));
f = @(x) x(1) * (1 - exp(-x(2) * t) .* (cos(x(3) * t) + (x(2) / x(3)) * sin(x(3) * t))) - y;

x0 = [1 1 1]; % initial values of model parameters
n = length(x0);

% 67
J = @(x) [
    1 - exp(-x(2)*t).*(cos(x(3)*t)+(x(2)/x(3))*sin(x(3)*t)) ...
    x(1)*exp(-x(2)*t).*(t.*cos(x(3)*t) - ((1 - t*x(2))/x(3)).*sin(x(3)*t)) ...
    x(1)*exp(-x(2)*t).*((t+(x(2)/x(3)^2)).*sin(x(3)*t) - (x(2)/x(3))*t.*cos(x(3)*t))
];

% Lavenberg-Matquardt Algorithm
X = zeros(n,k_max+1);
X(:,1) = x0;
L = 0.5;
for k = 1:k_max
    x = X(:,k);
    xNew = x - inv(transpose(J(x)) * J(x) + L * eye(n)) * transpose(J(x)) * f(x);
    if ( norm(f(xNew)) < norm(f(x0)) )
        X(:,k+1) = xNew;
        L = 0.8*L;
    else
        X(:,k+1) = x;
        L = 2*L;
    end
end
X(:, end) / 1000
xOptimal = X(:,end);

figure;
p = 1:1:k_max+1;
plot(p, X(1,:), "Color", "black", "LineWidth", 2)
hold on;
plot(p, X(2,:), "Color", "red", "LineWidth", 2)
plot(p, X(3,:), "Color", "blue", "LineWidth", 2)

figure
plot01 = plot(t,y,".","MarkerEdgeColor","r","MarkerFaceColor","r");
hold on
tPlot = linspace(t(1),t(end));
plot02 = plot(tPlot,h(x0,tPlot),"b","LineWidth",1);
hold on
plot03 = plot(tPlot,h(xOptimal,tPlot),"k","LineWidth",1);

legend([plot01,plot02,plot03],"measurement", "first guess", "final fit")
grid on
nfontslatex = 18;
nfonts = 14;
set(gca,"FontSize",nfonts);
ylabel("$y = A\sin(\omega t + \phi)$ [a.u.]","Interpreter","Latex","FontSize",nfontslatex)
xlabel("$t$ [s]","Interpreter","Latex","FontSize",nfontslatex)