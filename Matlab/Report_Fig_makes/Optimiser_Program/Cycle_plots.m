load paings1-200.mat

for i = 1:(size(sim_handler,2)-1)
    sim_handler{i}.original_data.Ah 
end


figure
plot(sim_handler{1}.original_data.ts,sim_handler{1}.original_data.volts)
plot(sim_handler{end-1}.original_data.ts,sim_handler{end-1}.original_data.volts)
xlim([0 7549])
ylim([2.440 3.696])
grid on
legend(["Cycle 1", "Cycle 200"], "FontSize", 11, "FontWeight", "normal", "Interpreter", "latex", "Position", [0.8002 0.7047 0.0866, 0.0522])
title("\textbf{Protocol 1 (Paings degredation model)}", "Interpreter", "latex", "FontSize", 19)
xlabel("\textbf{Time}", "Interpreter", "latex", "FontSize", 15, "FontWeight", "bold")
ylabel("\textbf{Voltage}", "Interpreter", "latex", "FontSize", 15, "LineWidth", 0.5)
Cycle200 = findobj(gcf,"DisplayName","Cycle 200");
Cycle200.LineWidth = 2;
Cycle1 = findobj(gcf,"DisplayName","Cycle 1");
Cycle1.LineWidth = 2;
hLegend = findobj(gcf,"Type","legend");
hLegend.Interpreter = "latex";
hLegend.FontWeight = "normal";
hLegend.FontSize = 11;

clear


figure
plot(sim_handler{1}.original_data.ts,sim_handler{1}.original_data.volts)
plot(sim_handler{end-1}.original_data.ts,sim_handler{end-1}.original_data.volts)
xlim([0 7549])
ylim([2.440 3.696])
grid on
legend(["Cycle 1", "Cycle 200"], "FontSize", 11, "FontWeight", "normal", "Interpreter", "latex", "Position", [0.8002 0.7047 0.0866, 0.0522])
title("\textbf{Protocol 1 (Paings degredation model)}", "Interpreter", "latex", "FontSize", 19)
xlabel("\textbf{Time}", "Interpreter", "latex", "FontSize", 15, "FontWeight", "bold")
ylabel("\textbf{Voltage}", "Interpreter", "latex", "FontSize", 15, "LineWidth", 0.5)
Cycle200 = findobj(gcf,"DisplayName","Cycle 200");
Cycle200.LineWidth = 2;
Cycle1 = findobj(gcf,"DisplayName","Cycle 1");
Cycle1.LineWidth = 2;
hLegend = findobj(gcf,"Type","legend");
hLegend.Interpreter = "latex";
hLegend.FontWeight = "normal";
hLegend.FontSize = 11;