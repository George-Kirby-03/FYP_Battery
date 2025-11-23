%Function to neatly produce Vout-I comparison plots
function VIplot(t,V,i)
f_size= 26;
figure
hold on
colororder({'#0072BD','#D95319'})
yyaxis left
plot(t,V,'linewidth',1.5)
ylabel('Output Voltage (V)','fontSize',f_size,'interpreter','latex')
yyaxis right
stairs(t,i,'linewidth',1.5)
ylabel('Charging Current (A)','fontSize',f_size,'interpreter','latex')
xlabel('Time (s)','fontSize',f_size,'interpreter','latex')
set(gca,'FontSize',f_size);