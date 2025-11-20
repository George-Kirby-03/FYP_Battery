%Function to neatly produce T-Pgen comparison plots
function TPplot(t,T,Pgen)

f_size= 26;
figure
hold on
colororder({'#EDB120','#77AC30'})
yyaxis left
plot(t,T,'linewidth',1.5)
ylabel('Cell Temperature ($^{\circ}$C)','fontSize',f_size,'interpreter','latex')
yyaxis right
plot(t,Pgen,'linewidth',1.5)
ylabel('Heat Generated (W)','fontSize',f_size,'interpreter','latex')
xlabel('Time (s)','fontSize',f_size,'interpreter','latex')
set(gca,'FontSize',f_size);