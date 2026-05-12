load moli_for_fyp.mat
figure()
t = tiledlayout('TileSpacing','tight', 'Padding','tight');
sim_handler.current_sol
f_size = 18;
l_size = 13;
% Team 1
nexttile
plot(sim_handler.states_sol.T,sim_handler.states_sol.Pol+sim_handler.ocv_curve(sim_handler.states_sol.SoC)+ sim_handler.current_sol.R0*sim_handler.states_sol.Current)
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
load MOLI_cycle_4_greyest.mat
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
nexttile
plot(sim_handler.states_sol.T,sim_handler.states_sol.SoC)
ylim([0 1])
ylabel("SoC (\%)",'interpreter','latex')
ax = gca;
ax.FontSize = 12;
title('\textbf{State Of Charge}', ...
       'interpreter','latex','fontsize',f_size)
ax = gca;
ax.FontSize = 12;
xlabel("Time ($s$)",'interpreter','latex')
grid on

nexttile
plot(sim_handler.original_data.ts,sim_handler.original_data.amps)
title('\textbf{Current Profile}', ...
       'interpreter','latex','fontsize',f_size)
ax = gca;
ax.FontSize = 12;
grid on
xlabel("Time ($s$)",'interpreter','latex')
ylabel("Current ($I$)",'interpreter','latex')


%%
load Baseline_A_1_1000.mat
sim_handler = sim_handler{6};
sim_handler.current_sol
figure()
t = tiledlayout('TileSpacing','tight', 'Padding','tight');

f_size = 18;
l_size = 13;
% Team 1
nexttile
plot(sim_handler.states_sol.T,sim_handler.states_sol.Current*sim_handler.current_sol.R0+sim_handler.states_sol.Pol+sim_handler.ocv_curve(sim_handler.states_sol.SoC))
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
nexttile
plot(sim_handler.states_sol.T,sim_handler.states_sol.SoC)
ylim([0 1])
ylabel("SoC (\%)",'interpreter','latex')
ax = gca;
ax.FontSize = 12;
title('\textbf{State Of Charge}', ...
       'interpreter','latex','fontsize',f_size)
ax = gca;
ax.FontSize = 12;
xlabel("Time ($s$)",'interpreter','latex')
grid on

nexttile
plot(sim_handler.original_data.ts,sim_handler.original_data.amps)
title('\textbf{Current Profile}', ...
       'interpreter','latex','fontsize',f_size)
ax = gca;
ax.FontSize = 12;
grid on
xlabel("Time ($s$)",'interpreter','latex')
ylabel("Current ($I$)",'interpreter','latex')

%% MSE calcs
load moli_for_fyp.mat
svol = sim_handler.states_sol.Current*sim_handler.current_sol.R0+sim_handler.states_sol.Pol+sim_handler.ocv_curve(sim_handler.states_sol.SoC);
stime = sim_handler.states_sol.T;
rvol = interp1(sim_handler.original_data.ts,sim_handler.original_data.volts,sim_handler.states_sol.T);

stemp = sim_handler.states_sol.Temp;
stime = sim_handler.states_sol.T;
rtemp = interp1(sim_handler.original_data.ts,sim_handler.original_data.tp,sim_handler.states_sol.T);