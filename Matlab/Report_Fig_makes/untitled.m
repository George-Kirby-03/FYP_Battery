load moli_for_fyp.mat
figure()
t = tiledlayout('flow');

f_size = 18;
l_size = 13;
% Team 1
nexttile
plot(sim_handler.states_sol.T,sim_handler.states_sol.Pol+sim_handler.ocv_curve(sim_handler.states_sol.SoC))
hold on
plot(sim_handler.original_data.ts,sim_handler.original_data.volts)
title('\textbf{Terminal Voltage}', ...
       'interpreter','latex','fontsize',f_size)
ax = gca;
ax.FontSize = 12;
grid on
xlabel("Time ($s$)",'interpreter','latex')
ylabel("$V$","Interpreter","latex")

% Team 2
nexttile
plot(sim_handler.states_sol.T,sim_handler.states_sol.Temp)
hold on
plot(sim_handler.original_data.ts,sim_handler.original_data.tp)
title('\textbf{Temperature Rise ($\Delta^\circ$C)}', ...
       'interpreter','latex','fontsize',f_size)
ylabel("$\Delta^\circ$C", ...
       'interpreter','latex')
grid on
ax = gca;
ax.FontSize = 12;
xlabel("Time ($s$)",'interpreter','latex')
% Team 3
%nexttile([1 2]);
nexttile
yyaxis left
plot(sim_handler.states_sol.T,sim_handler.states_sol.SoC)
ylim([0 1])
ylabel("State of Charge",'interpreter','latex')
ax = gca;
ax.FontSize = 12;

hold on
yyaxis right
plot(sim_handler.original_data.ts,sim_handler.original_data.amps)
ylim([-3 1.5])
ylabel("Current ($I$)",'interpreter','latex')
title('\textbf{Current Throughput}', ...
       'interpreter','latex','fontsize',f_size)
ax = gca;
ax.FontSize = 12;
xlabel("Time ($s$)",'interpreter','latex')
grid on

nexttile
soc = linspace(0,1,100);
plot(sim_handler.states_sol.T,sim_handler.states_sol.Pol)
title('\textbf{Polarising Component ($V$)}', ...
       'interpreter','latex','fontsize',f_size)
ax = gca;
ax.FontSize = 12;
grid on
xlabel("Time ($s$)",'interpreter','latex')
ylabel("$V$","Interpreter","latex")
