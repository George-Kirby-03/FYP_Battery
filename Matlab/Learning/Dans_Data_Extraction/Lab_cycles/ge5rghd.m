t = linspace(0, 2, 2000);

CC13_min = 0.6 ./ (t - 0.08);
CC4_min  = 0.2 ./ (t - 0.279);

% Mask singularities
CC13_min(abs(t - 0.08) < 1e-2) = NaN;
CC4_min(abs(t - 0.279) < 1e-2) = NaN;

CC13_min_n  = 0.6 ./ (t - 0.098);
CC4_min_n  = 0.2 ./ (t - 0.308);

% Mask singularities
CC13_min_n(abs(t - 0.098) < 1e-2) = NaN;
CC4_min_n(abs(t - 0.308) < 1e-2) = NaN;

figure; hold on; grid on;
plot(t, CC13_min, 'LineWidth', 1.5)
plot(t, CC4_min,  'LineWidth', 1.5)
plot(t, CC13_min_n, 'LineWidth', 1.5)
plot(t, CC4_min_n,  'LineWidth', 1.5)
xlim([0.049 1.115])
ylim([0.20 6.44])
legend(["$\mathbf{CC}_{1:3,min}$", "$\mathbf{CC}_{4,min}$"], "FontSize", 15, "Interpreter", "latex", "LineWidth", 1, "Position", [0.7925 0.8296 0.0906, 0.0673])
title("Attia to RS Parameter descisions", "FontSize", 18)
xlabel("$t_{0-80\%} (hours)$", "Position", [0.5562 -0.2034 -1.0000], "Interpreter", "latex", "FontSize", 20)
ylabel("$C$", "Interpreter", "latex", "FontSize", 19)
 
mathbfCC_13minLine = findobj(gcf, "DisplayName", "$\mathbf{CC}_{1:3,min}$")
datatip(mathbfCC_13minLine,0.3862,1.96,"Location","northwest");
mathbfCC_4minLine = findobj(gcf, "DisplayName", "$\mathbf{CC}_{4,min}$")
datatip(mathbfCC_4minLine,0.3862,1.866);
mathbfCC13min = findobj(gcf,"DisplayName","$\mathbf{CC}_{1:3,min}$")
mathbfCC13min.LineWidth = 4.5000
mathbfCC4min = findobj(gcf,"DisplayName","$\mathbf{CC}_{4,min}$")
mathbfCC4min.LineWidth = 4


