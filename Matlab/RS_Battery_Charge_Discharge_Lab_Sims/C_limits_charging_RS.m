close all;
clear; clc;
load RS_Params.mat
ocv = linspace(0,1,150);
p.r1 = 0.07;
p.r0 = 0.16- p.r1;

%To see current limit in C till V cutoff (3.6V)
% (3.6 - ocv(soc))/R_0+1)/1.5

curve = ((3.6 - polyval(ocv_curve_2,ocv))/(p.r1+p.r0))/1.5;
figure();
plot(ocv,curve)
xlim("auto")
ylim("auto")
grid on
title("\textbf{Permissable Charge Current Along Charge Profile}", "Interpreter", "latex", "FontSize", 17)
xlabel("SoC", "FontSize", 15, "FontWeight", "bold")
ylabel("Current (C)", "Position", [-0.0253 2.5000 -1.0000], "FontSize", 16, "FontWeight", "bold")
 
ax = gca;
chart = ax.Children(1);
datatip(chart,0.8054,1.233);
datatip(chart,0.604,1.365);
datatip(chart,0.4027,1.396);
datatip(chart,0.2013,1.648);
hLine = findobj(gcf,"Type","line")
hLine.LineWidth = 4