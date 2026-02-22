load("../../cycle_exports/MOLI_28/MOLI_cycle_4.mat")

idx = find((-0.1<u1) & (u1<0.05),1,'last');

f_size = 18;
color_two = [1,0,127/255]; 
color_one = [0.1,0.8,1]; 

figure;
yyaxis left
p1 = gca;
p1.YColor = color_one;  
plot(tt(idx:end), y(idx:end), 'color', color_one, 'linewidth', 3)
ylabel('Voltage','interpreter','latex','fontsize',f_size);

yyaxis right
p2 = gca;
p2.YColor = color_two; 
plot(tt(idx:end), u1(idx:end), 'color', color_two, 'linewidth', 3)
ylabel('Current','interpreter','latex','fontsize',f_size);

xlabel('Time','interpreter','latex','fontsize',f_size);
title('\textbf{CC-CV Charging Protocol}','interpreter','latex','fontsize',f_size+2);

grid on
box on

hold off
