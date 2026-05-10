close all
clear
load RS_Param_Retry.mat
ocv = linspace(0,1,150);
p.r1 = 0.075;
p.r0 = 0.015;

%To see current limit in C till V cutoff (3.6V)
% (3.6 - ocv(soc))/R_0+1)/1.5

curve = ((3.65 - ocv_curve_2(ocv))/(p.r1+p.r0))/1.5;
figure();
plot(ocv,curve)
xlim("auto");
ylim("auto");
grid on
title("\textbf{Permissable Charge Current Along Charge Profile}", "Interpreter", "latex", "FontSize", 17);
xlabel("SoC", "FontSize", 15, "FontWeight", "bold");
ylabel("Current (C)", "FontSize", 16, "FontWeight", "bold");
 
ax = gca;
chart = ax.Children(1);
datatip(chart,0.8054,1.233);
datatip(chart,0.604,1.365);
datatip(chart,0.4027,1.396);
datatip(chart,0.2013,1.648);
hLine = findobj(gcf,"Type","line");
hLine.LineWidth = 4;

Norm_factor = 8/1.65;
%%
figure();

C_RS_Upper = [1.65, 1.39, 1.37, 1.23];
C_RS_Lower = [0.716, 0.34, 0.34, 0.34];
C_Attia_Upper = [8, 7, 5.6, 4.81];
C_Attia_Lower = [3.6, 3.6, 3.6, 0];
C_Norm_Upper = C_Attia_Upper/Norm_factor;
C_Norm_Lower = C_Attia_Lower/Norm_factor;
hold on

for i=1:4
    rectangle('Position',[(i-1)*0.2,C_Attia_Lower(i),0.2,C_Attia_Upper(i)-C_Attia_Lower(i)], 'FaceColor',[0.43, 0.77, 1], 'FaceAlpha',.3)
end
for i=1:4
    rectangle('Position',[(i-1)*0.2,C_RS_Lower(i),0.2,C_RS_Upper(i)-C_RS_Lower(i)], 'FaceColor',[0.439, 1, 0.882], 'FaceAlpha',.8)
end
for i=1:4
    rectangle('Position',[(i-1)*0.2,C_Norm_Lower(i),0.2,C_Norm_Upper(i)-C_Norm_Lower(i)], 'FaceColor',[0.6, 0.439, 1], 'FaceAlpha',.8)
end
grid on
title("\textbf{CC charging Segments Comparison}", "Interpreter", "latex", "FontSize", 17);
xlabel("SoC", "FontSize", 17, "FontWeight", "bold");
ylabel("Current (C)", "FontSize", 17, "FontWeight", "bold");
hold off

%%




t = linspace(0, 2, 2000);

C4 = 0.35;
C13 = 0.09;

CC13_min = 0.6 ./ (t - C13);
CC4_min  = 0.2 ./ (t - C4);
CC4_min_n_sum = 0;
for i=1:3
    CC4_min_n_sum = CC4_min_n_sum + 0.2/C_Norm_Upper(i);
end
CC4_min_n = 0.2 ./ (t - CC4_min_n_sum);
CC13_min_n = 0.6 ./ (t - (0.2./C_Norm_Upper(end)));

figure; hold on; grid on;
plot(t, CC13_min, 'LineWidth', 1.5)
plot(t, CC4_min,  'LineWidth', 1.5)
plot(t, CC13_min_n, 'LineWidth', 1.5)
plot(t, CC4_min_n,  'LineWidth', 1.5)
xlim([0.4 1.115])
ylim([0.20 4])
legend(["$\mathbf{CC}_{1:3,min}$", "$\mathbf{CC}_{4,min}$","$\mathbf{CC}_{1:3,min,norm}$", "$\mathbf{CC}_{4,min,norm}$" ], "FontSize", 15, "Interpreter", "latex", "LineWidth", 1, "Position", [0.7925 0.8296 0.0906, 0.0673])
title("Attia to RS Parameter descisions", "FontSize", 18)
xlabel("$t_{0-80\%} (hours)$", "Interpreter", "latex", "FontSize", 20)
ylabel("$C$", "Interpreter", "latex", "FontSize", 19)
xlim([0.436 1.151])
ylim([-0.01 3.79])
zlim([-1.000 1.000])
hDataTip = findobj(gca,"DataIndex",1000);
set(hDataTip,"X",0.4102,"Y",-251.6);
hDataTip = findobj(gca,"DataIndex",411);
set(hDataTip,"X",0.4262,"Y",2.28,"Location","northwest");
mathbfCC_13minLine = findobj(gcf, "DisplayName", "$\mathbf{CC}_{1:3,min}$");
datatip(mathbfCC_13minLine,1.001,0.7164);
mathbfCC_4minLine = findobj(gcf, "DisplayName", "$\mathbf{CC}_{4,min}$");
datatip(mathbfCC_4minLine,0.9995,0.3398);
mathbfCC4minnorm = findobj(gcf,"DisplayName","$\mathbf{CC}_{4,min,norm}$");
mathbfCC4minnorm.LineWidth = 2.5000;
mathbfCC4minnorm.LineStyle = "-.";
mathbfCC13minnorm = findobj(gcf,"DisplayName","$\mathbf{CC}_{1:3,min,norm}$");
mathbfCC13minnorm.LineWidth = 2.5000;
mathbfCC13minnorm.LineStyle = "-.";
hold off;

x = linspace(0.1, 0.425, 100);
t = linspace(0.3, 0.9, 100);

[X, T] = meshgrid(x, t);
Z = 0.2 ./ (X .* T - 0.2*0.593);
Z(abs(X .* T - 0.2*0.593) < 1e-2) = NaN;

%%
figure
hold on

surf(X, T, Z)
scatter3(0.425, 0.383, 0.2 ./ (0.425.*0.383 - 0.2*0.593), 80, 'r', 'filled')
contour(X, T, Z, 'k', 'LineWidth', 0.8)
shading interp
colorbar

xlabel('x')
ylabel('t')
zlabel('f(x,t)')
grid on

annotation("textarrow", [0.2826 0.3321], [0.5393 0.3929], "String", "Optimal balance scaling chosen", "FontSize", 11, "FontWeight", "bold")
annotation("textarrow", [0.1521 0.127], [0.2976 0.2298], "String", "True Scaling", "FontSize", 12, "FontWeight", "bold")
 
view([180.0 -90.0])
grid on
title("$CC_{4} $ After parameter adjustment", "Interpreter", "latex", "FontSize", 19, "LineWidth", 3.5);
xlabel("Protocol Scale Factor $x$", "Interpreter", "latex", "FontSize", 17);
ylabel("$t_{0-80\%}$", "Interpreter", "latex", "FontSize", 21);
zlabel("f(x,t");
 
ZSurface = findobj(gcf, "DisplayName", "Z");
datatip(ZSurface,0.3298,0.5061,4.141);


