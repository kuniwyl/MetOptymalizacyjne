close all
clear all
clc

load("inertialData")
k_max = 35;

h = @(x, t) x(1) * (1 - exp(-t/x(2)));
f = @(x) x(1) * (1 - exp(-t/x(2))) - y;

x0 = [1 1]; % initial values of model parameters
n = length(x0);

J = @(x) [1 - exp(-t/x(2)) -(x(1)/x(2)^2)*exp(-t/x(2))];

% Lavenberg-Matquardt Algorithm
X = zeros(n,k_max+1);
X(:,1) = x0;
L = 1.0;
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
xOptimal = X(:,end)


nfontslatex = 18;
nfonts = 14;

figure
plot01 = plot(t,y,".","MarkerEdgeColor","r","MarkerFaceColor","r");
hold on
tPlot = linspace(t(1),t(end),1e+3);
plot02 = plot(tPlot,h(x0,tPlot),"b","LineWidth",2);
hold on
plot03 = plot(tPlot,h(xOptimal,tPlot),"k","LineWidth",2);

legend([plot01,plot02,plot03],"measurement", "first guess", "final fit")
grid on
set(gca,"FontSize",nfonts);
ylabel("$y = A\sin(\omega t + \phi)$ [a.u.]","Interpreter","Latex","FontSize",nfontslatex)
xlabel("$t$ [s]","Interpreter","Latex","FontSize",nfontslatex)