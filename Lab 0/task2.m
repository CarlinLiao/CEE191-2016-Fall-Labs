%% 2.2 Arrays

clc
D = [ 2 4 -3; 3 9 -1 ]
E = [ 1 2; 3 4 ]
F = [ -5 5; 5 3 ]
G = D(1:2,1:2)
H = blkdiag(E,F,G)
detH = det(H)
detEFG = det(E)*det(F)*det(G)

%% 2.3 Plotting

clf
clear
clc
x = linspace(-3*pi,3*pi,100);
plot(x,sin(x))
hold on
plot(x,cos(x))
title('y = sin(x), y = cos(x)','FontSize',15)
legend('sin(x)','cos(x)','Location','southeast')
xlabel('x','FontSize',15)
ylabel('y','FontSize',15)
gca.XTick = [-3*pi -2*pi -pi 0 pi 2*pi 3*pi];
