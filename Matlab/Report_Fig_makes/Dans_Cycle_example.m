load("../../cycle_exports/MOLI_28/MOLI_cycle_4.mat")

f_size = 18;
color_one = [1,0,127/255]; 
color_two = [115, 252, 3]/255; 

figure;
yyaxis right
p1 = gca;
p1.YColor = color_one;  
plot(tt, tp, 'color', color_two, 'linewidth', 3)
ylabel('\textbf{Current (I)}','interpreter','latex','fontsize',f_size);

yyaxis left
p2 = gca;
p2.YColor = color_two; 
plot(tt, u1, 'color', color_one, 'linewidth', 3)
ylabel('\textbf{Temperature Rise ($\Delta^\circ$C)}', ...
       'interpreter','latex','fontsize',f_size);
xlabel("\textbf{Time(s)}", "Interpreter", "latex", "FontSize", 18)
hLine = findobj(gcf,"Type","line")
hLine(2).LineWidth = 3.5000
hLine(2).LineStyle = "-"
hLine(1).LineStyle = "-."
grid on
box on

hold off
