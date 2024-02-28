clc;
clear;
close all;

file = load('LM01Data.mat')

y_fixed = file.y;
t = file.t;
Dj = zeros([size(y_fixed, 1), 3]);
y = zeros(size(y_fixed, 1));

x = [x1, x2, x3]

plot(t, y_fixed, '.b');

