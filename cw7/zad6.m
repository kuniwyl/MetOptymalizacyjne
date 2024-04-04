close all
clear all
clc

% ZAD 1
load("LM01Data")
f = @(x) x(1)*sin(x(2)*t+x(3))-y;
x0 = [1.0, 100*pi, 0.0];

xOptimal1 = lsqnonlin(f, x0)

% ZAD 2
load("LM04Data")
a = 2;
f = @(x) x(1) *exp(-t * a).*sin(x(2)*t+x(3))-y;
x0 = [1, 7*pi, 0];

xOptimal2 = lsqnonlin(f, x0)

% ZAD 3
load("inertialData")
x0 = [0.01 0.01];
% 49
f = @(x) x(1) * (1 - exp(-t/x(2))) - y;
xOptimal3 = lsqnonlin(f,x0)

% ZAD 4
load("twoInertialData.mat")
x0 = [1.1 1.2 1.3];
% 55
f = @(x) x(1) * (1 - (1 / (x(2) - x(3))) * ((x(2) * exp(-t/x(2))) - (x(3) * exp(-t/x(3)))) ) - y
%  * ((x(2) * exp(-t/x(2))) - (x(3) * exp(-t/x(3)))) 
xOptimal4 = lsqnonlin(f,x0)

% ZAD 5
load("reductionData.mat")
y = y * 1000;
t = t * 1000;
x0 = [1 1 1];
% 65
f = @(x) x(1) * (1 - exp(-x(2) * t) .* (cos(x(3) * t) + (x(2) / x(3)) * sin(x(3) * t))) - y;
xOptimal5 = lsqnonlin(f,x0) / 1000
