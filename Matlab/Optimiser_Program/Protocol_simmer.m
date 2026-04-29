%% ODE Simulations of the protocols

%Settings and charging protocol specified (currently using manual method
%but can easily give current struct entry directly from above optimiser
%outputs)

%For Protocol 3 Minimising temp intergral

%load MinTempInt-a.mat
load baseline27-800.mat
% load better_ocv.mat
load RS_Param_Retry.mat
avg_sim_handle_b1 = sim_average(sim_handler,20,'Start');
avg_sim_handle_b1 = ocv_fun_injection(avg_sim_handle_b1,ocv_curve_2);
avg_sim_handle_b1.current_sol.Q = 5.58e03;
avg_sim_handle_b1.current_sol.C = 800;
avg_sim_handle_b1.current_sol.R0 = 0.075;
avg_sim_handle_b1.current_sol.R1 = 0.045;
avg_sim_handle_b1.current_sol.Cp = 75;
avg_sim_handle_b1.current_sol.h = 0.12;
%load MinTempInt-a.mat
% avg_sim_handle_b2 = sim_average(sim_handler,5,'Start');
load MinTempInt-b.mat

%avg_sim_handle_b1 = ocv_fun_injection(avg_sim_handle_b1,ocv_curve_2);

charge_protocol.capacity_selection = 'Discharged'; % or 'Absolute'
charge_protocol.charge_segments = [0 20 40 60 80 100]; %Specify as many segments as needed
charge_protocol.charge_currents = [1.3 1.45 1.75 1.53 0.5] * 1.5; %Specify current per segment in c
charge_protocol.CV_cutoff = 0.019; %Segment CV stage (if met) will stop once current falls to this limit
charge_protocol.discharge_segments = [100 0]; %Specify as many segments as needed
charge_protocol.discharge_currents = [2.5]*1.5; %Specify current per segment in c here
charge_protocol.discharge_charge_rest = 61*30; %If set, there will be a rest period between charge and discharge ...
charge_protocol.discharge_CV = 'False'; %False will mean once a discharge segment reaches vlim, it will switch to the next.
%segment instantly without running CV, it makes more sense to use this in
%conjunction with capacity_selection as 'Discharged'
charge_protocol.charge_CV = 'True'; % Allows for CV stage at the end (will also apply to mid segments too)
charge_protocol.ambient_temp = 24;

sim_results = odeSOC(avg_sim_handle_b1,charge_protocol);

idx = find(sim_handler{5}.original_data.amps<0,1,'first');



figure
plot(sim_results.time,sim_results.V,'LineWidth',3);
hold on
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),sim_handler{1}.original_data.volts(idx:end),'LineWidth',3);
load MinTempInt-a.mat
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),sim_handler{1}.original_data.volts(idx:end),'LineWidth',3);
set(gcf, "Theme", "light");
xlim([3167 6443])
ylim([3.221 3.658])
grid on
legend(["Simulation", "Batt B", "Batt A"], "Interpreter", "latex", "FontSize", 13, "Position", [0.7383 0.8503 0.0936, 0.0566])
xlabel("Time $(S)$", "Interpreter", "latex", "FontSize", 13)
ylabel("Volts $(V)$", "Interpreter", "latex", "FontSize", 13)


figure
plot(sim_results.time, sim_results.states(:,3));
hold on

load MinTempInt-b.mat
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),  sim_handler{1}.original_data.tp(idx:end) + 24);

load MinTempInt-a.mat
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),  sim_handler{1}.original_data.tp(idx:end) + 24);
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),  sim_handler{1}.original_data.amps(idx:end));
set(gcf, "Theme", "light");
xlim([3167 6443])
ylim([24 30])
xs = xline(3301, '-', 'Charge start','Interpreter','latex','FontSize',13);
xs.LineWidth = 1.5;
xs.Color = [0 0 0];
x3 = xline(3787, '--', '20\% SoC','Interpreter','latex','FontSize',13);
x3.LineWidth = 1.5;
x3.Color = [0 0 0];
x2 = xline(4283, '--', '40\% SoC','Interpreter','latex','FontSize',13);
x2.LineWidth = 1.5;
x2.Color = [0 0 0];
x1 = xline(4697, '--', '60\% SoC','Interpreter','latex','FontSize',13);
x1.LineWidth = 1.5;
x1.Color = [0 0 0];
xe = xline(5156, '--', '80\% SoC','Interpreter','latex','FontSize',13);
xe.LineWidth = 1.5;
xe.Color = [0 0 0];
xf = xline(6510, '-', '100\% SoC','Interpreter','latex','FontSize',13);
xf.LineWidth = 1.5;
xf.Color = [0 0 0];
% Optional label positioning tweaks
xs.LabelHorizontalAlignment = 'right';
xe.LabelHorizontalAlignment = 'right';
x1.LabelHorizontalAlignment = 'right';
x2.LabelHorizontalAlignment = 'right';
x3.LabelHorizontalAlignment = 'right';
xf.LabelHorizontalAlignment = 'right';
grid on
legend(["Simulation", "Batt B", "Batt A"], "Interpreter", "latex", "FontSize", 13, "Position", [0.7383 0.8503 0.0936, 0.0566])

xlabel("Time $(S)$", "Interpreter", "latex", "FontSize", 13)
ylabel("Temperature $(C^\circ)$", "Interpreter", "latex", "FontSize", 13)


%% For min max temp

%load MinTempInt-a.mat
load baseline27-800.mat
% load better_ocv.mat
load RS_Param_Retry.mat
avg_sim_handle_b1 = sim_average(sim_handler,20,'Start');
avg_sim_handle_b1 = ocv_fun_injection(avg_sim_handle_b1,ocv_curve_2);
avg_sim_handle_b1.current_sol.Q = 5.58e03;
avg_sim_handle_b1.current_sol.C = 800;
avg_sim_handle_b1.current_sol.R0 = 0.075;
avg_sim_handle_b1.current_sol.R1 = 0.045;
avg_sim_handle_b1.current_sol.Cp = 75;
avg_sim_handle_b1.current_sol.h = 0.12;
%load MinTempInt-a.mat
% avg_sim_handle_b2 = sim_average(sim_handler,5,'Start');

load MAX_TEMP_B2.mat
%avg_sim_handle_b1 = ocv_fun_injection(avg_sim_handle_b1,ocv_curve_2);

charge_protocol.capacity_selection = 'Discharged'; % or 'Absolute'
charge_protocol.charge_segments = [0 20 40 60 80 100]; %Specify as many segments as needed
charge_protocol.charge_currents = [1.95 1.4 1.35 1.35 0.5] * 1.5; %Specify current per segment in c
charge_protocol.CV_cutoff = 0.019; %Segment CV stage (if met) will stop once current falls to this limit
charge_protocol.discharge_segments = [100 0]; %Specify as many segments as needed
charge_protocol.discharge_currents = [2.5]*1.5; %Specify current per segment in c here
charge_protocol.discharge_charge_rest = 61*30; %If set, there will be a rest period between charge and discharge ...
charge_protocol.discharge_CV = 'False'; %False will mean once a discharge segment reaches vlim, it will switch to the next.
%segment instantly without running CV, it makes more sense to use this in
%conjunction with capacity_selection as 'Discharged'
charge_protocol.charge_CV = 'True'; % Allows for CV stage at the end (will also apply to mid segments too)
charge_protocol.ambient_temp = 24;

sim_results = odeSOC(avg_sim_handle_b1,charge_protocol);

idx = find(sim_handler{5}.original_data.amps<0,1,'first');


figure
plot(sim_results.time,sim_results.V,'LineWidth',3);
hold on
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),sim_handler{1}.original_data.volts(idx:end),'LineWidth',3);
load Max_temp.mat
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),sim_handler{1}.original_data.volts(idx:end),'LineWidth',3);
set(gcf, "Theme", "light");
xs = xline(1431, '-', 'Dicharge End','Interpreter','latex','FontSize',13);
xs.LineWidth = 1.5;
xs.Color = [0 0 0];
x3 = xline(3231, '-', 'Rest End','Interpreter','latex','FontSize',13);
x3.LineWidth = 1.5;
x3.Color = [0 0 0];
xlim([3167 6443])
ylim([3.221 3.658])
grid on
legend(["Simulation", "Batt B", "Batt A"], "Interpreter", "latex", "FontSize", 13, "Position", [0.7383 0.8503 0.0936, 0.0566])
xlabel("Time $(S)$", "Interpreter", "latex", "FontSize", 13)
ylabel("Volts $(V)$", "Interpreter", "latex", "FontSize", 13)


figure
plot(sim_results.time, sim_results.states(:,3),'LineWidth',3);
hold on

load MAX_TEMP_B2.mat
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),  sim_handler{1}.original_data.tp(idx:end) + 24.3,'LineWidth',3);

load Max_temp.mat
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),  sim_handler{1}.original_data.tp(idx:end) + 24.3,'LineWidth',3);
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),  sim_handler{1}.original_data.amps(idx:end));
set(gcf, "Theme", "light");
xlim([3167 6443])
ylim([24 30])
xs = xline(3231, '-', 'Charge start','Interpreter','latex','FontSize',13);
xs.LineWidth = 1.5;
xs.Color = [0 0 0];
x3 = xline(3589, '--', '20\% SoC','Interpreter','latex','FontSize',13);
x3.LineWidth = 1.5;
x3.Color = [0 0 0];
x2 = xline(4100, '--', '40\% SoC','Interpreter','latex','FontSize',13);
x2.LineWidth = 1.5;
x2.Color = [0 0 0];
xe = xline(5160, '--', '80\% SoC','Interpreter','latex','FontSize',13);
xe.LineWidth = 1.5;
xe.Color = [0 0 0];
xf = xline(6471, '-', '100\% SoC','Interpreter','latex','FontSize',13);
xf.LineWidth = 1.5;
xf.Color = [0 0 0];
% Optional label positioning tweaks
xs.LabelHorizontalAlignment = 'right';
xe.LabelHorizontalAlignment = 'right';
x2.LabelHorizontalAlignment = 'right';
x3.LabelHorizontalAlignment = 'right';
xf.LabelHorizontalAlignment = 'right';
grid on
legend(["Simulation", "Batt B", "Batt A"], "Interpreter", "latex", "FontSize", 13, "Position", [0.7383 0.8503 0.0936, 0.0566])

xlabel("Time $(S)$", "Interpreter", "latex", "FontSize", 13)
ylabel("Temperature $(C^\circ)$", "Interpreter", "latex", "FontSize", 13)

%% For paings (wrong) model

%load MinTempInt-a.mat
load paings1-200.mat
% load better_ocv.mat
load RS_Param_Retry.mat
avg_sim_handle_b1 = sim_average(sim_handler,20,'Start');
avg_sim_handle_b1 = ocv_fun_injection(avg_sim_handle_b1,ocv_curve_2);
avg_sim_handle_b1.current_sol.Q = 5.58e03;
avg_sim_handle_b1.current_sol.C = 800;
avg_sim_handle_b1.current_sol.R0 = 0.075;
avg_sim_handle_b1.current_sol.R1 = 0.045;
avg_sim_handle_b1.current_sol.Cp = 75;
avg_sim_handle_b1.current_sol.h = 0.12;
%load MinTempInt-a.mat
% avg_sim_handle_b2 = sim_average(sim_handler,5,'Start');

load paings1-200b2.mat
%avg_sim_handle_b1 = ocv_fun_injection(avg_sim_handle_b1,ocv_curve_2);

charge_protocol.capacity_selection = 'Discharged'; % or 'Absolute'
charge_protocol.charge_segments = [0 20 40 60 80 100]; %Specify as many segments as needed
charge_protocol.charge_currents = [1.95 1.8 1.65 0.9 0.5] * 1.5; %Specify current per segment in c
charge_protocol.CV_cutoff = 0.019; %Segment CV stage (if met) will stop once current falls to this limit
charge_protocol.discharge_segments = [100 0]; %Specify as many segments as needed
charge_protocol.discharge_currents = [2.5]*1.5; %Specify current per segment in c here
charge_protocol.discharge_charge_rest = 62*30; %If set, there will be a rest period between charge and discharge ...
charge_protocol.discharge_CV = 'False'; %False will mean once a discharge segment reaches vlim, it will switch to the next.
%segment instantly without running CV, it makes more sense to use this in
%conjunction with capacity_selection as 'Discharged'
charge_protocol.charge_CV = 'True'; % Allows for CV stage at the end (will also apply to mid segments too)
charge_protocol.ambient_temp = 24;

sim_results = odeSOC(avg_sim_handle_b1,charge_protocol);

idx = find(sim_handler{5}.original_data.amps<0,1,'first');


figure
plot(sim_results.time,sim_results.V,'LineWidth',3);
hold on
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),sim_handler{1}.original_data.volts(idx:end),'LineWidth',3);
load paings1-200.mat
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),sim_handler{1}.original_data.volts(idx:end),'LineWidth',3);
set(gcf, "Theme", "light");
xlim([3167 6443])
ylim([3.221 3.658])
grid on
legend(["Simulation", "Batt B", "Batt A"], "Interpreter", "latex", "FontSize", 13, "Position", [0.7383 0.8503 0.0936, 0.0566])
xlabel("Time $(S)$", "Interpreter", "latex", "FontSize", 13)
ylabel("Volts $(V)$", "Interpreter", "latex", "FontSize", 13)


figure
plot(sim_results.time, sim_results.states(:,3),'LineWidth',3);
hold on

load paings1-200b2.mat
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),  sim_handler{1}.original_data.tp(idx:end) + 24.3,'LineWidth',3);

load paings1-200.mat
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),  sim_handler{1}.original_data.tp(idx:end) + 24.3,'LineWidth',3);
plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),  sim_handler{1}.original_data.amps(idx:end));
set(gcf, "Theme", "light");
xlim([3167 6443])
ylim([24 30])
xs = xline(3260, '-', 'Charge start','Interpreter','latex','FontSize',13);
xs.LineWidth = 1.5;
xs.Color = [0 0 0];
x3 = xline(3626, '--', '20\% SoC','Interpreter','latex','FontSize',13);
x3.LineWidth = 1.5;
x3.Color = [0 0 0];
x2 = xline(4032, '--', '40\% SoC','Interpreter','latex','FontSize',13);
x2.LineWidth = 1.5;
x2.Color = [0 0 0];
x1 = xline(4488, '--', '60\% SoC','Interpreter','latex','FontSize',13);
x1.LineWidth = 1.5;
x1.Color = [0 0 0];
xe = xline(5300, '--', '80\% SoC','Interpreter','latex','FontSize',13);
xe.LineWidth = 1.5;
xe.Color = [0 0 0];
xf = xline(6630, '-', '100\% SoC','Interpreter','latex','FontSize',13);
xf.LineWidth = 1.5;
xf.Color = [0 0 0];
% Optional label positioning tweaks
xs.LabelHorizontalAlignment = 'right';
xe.LabelHorizontalAlignment = 'right';
x1.LabelHorizontalAlignment = 'right';
x2.LabelHorizontalAlignment = 'right';
x3.LabelHorizontalAlignment = 'right';
xf.LabelHorizontalAlignment = 'right';
grid on
legend(["Simulation", "Batt B", "Batt A"], "Interpreter", "latex", "FontSize", 13, "Position", [0.7383 0.8503 0.0936, 0.0566])

xlabel("Time $(S)$", "Interpreter", "latex", "FontSize", 13)
ylabel("Temperature $(C^\circ)$", "Interpreter", "latex", "FontSize", 13)

%% For Baseline

%load MinTempInt-a.mat
load baseline27-800.mat
load better_ocv.mat
avg_sim_handle_b1 = sim_average(sim_handler,20,'Start');
avg_sim_handle_b1 = ocv_fun_injection(avg_sim_handle_b1,ocv_curve_2);
avg_sim_handle_b1.current_sol.Q = 5.57e03;
avg_sim_handle_b1.current_sol.C = 800;
avg_sim_handle_b1.current_sol.R0 = 0.075;
avg_sim_handle_b1.current_sol.R1 = 0.045;
avg_sim_handle_b1.current_sol.Cp = 75;
avg_sim_handle_b1.current_sol.h = 0.12;
%load MinTempInt-a.mat
% avg_sim_handle_b2 = sim_average(sim_handler,5,'Start');
load baseline27-800.mat

%avg_sim_handle_b1 = ocv_fun_injection(avg_sim_handle_b1,ocv_curve_2);

charge_protocol.capacity_selection = 'Discharged'; % or 'Absolute'
charge_protocol.charge_segments = [0 20 40 60 80 100]; %Specify as many segments as needed
charge_protocol.charge_currents = [1.73 1.73 1.6 1.39 0.5] * 1.5; %Specify current per segment in c
charge_protocol.CV_cutoff = 0.019; %Segment CV stage (if met) will stop once current falls to this limit
charge_protocol.discharge_segments = [100 0]; %Specify as many segments as needed
charge_protocol.discharge_currents = [2.5]*1.5; %Specify current per segment in c here
charge_protocol.discharge_charge_rest = 60*30; %If set, there will be a rest period between charge and discharge ...
charge_protocol.discharge_CV = 'False'; %False will mean once a discharge segment reaches vlim, it will switch to the next.
%segment instantly without running CV, it makes more sense to use this in
%conjunction with capacity_selection as 'Discharged'
charge_protocol.charge_CV = 'True'; % Allows for CV stage at the end (will also apply to mid segments too)
charge_protocol.ambient_temp = 24;

sim_results = odeSOC(avg_sim_handle_b1,charge_protocol);


% charge_protocol.charge_currents = [2 1.8 1.65 0.9 0.75] * 1.5; %Specify current per segment in c here
% sim_results_b2 = odeSOC(avg_sim_handle_b2,charge_protocol);
% %Outputs are...
% % sim_results.time = vertcat(seg_time{:});
% sim_results.states = vertcat(seg_states{:});
% sim_results.I = vertcat(I{:});
% sim_results.V = V_out;
%Compare simulated and actual labs
%Find where the discharge starts
% idx = find(sim_handler{5}.original_data.amps<0,1,'first');
% figure()
% % plot(sim_results.time,sim_results.V);
% hold on
% % %plot(sim_results_b2.time,sim_results_b2.V);
% plot(sim_results.time,sim_results.V);
% plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),sim_handler{1}.original_data.volts(idx:end));
% %plot(sim_handler{1}.original_data.ts(idx:end) - sim_handler{1}.original_data.ts(idx),sim_handler{1}.original_data.amps(idx:end));
% % plot(avg_sim_handle_b1.original_data.ts(idx:end) - avg_sim_handle_b1.original_data.ts(idx),avg_sim_handle_b1.original_data.amps(idx:end))


idx_lab11 = find(GK_RS15_02_baseline_0000_028_1_.Amps<0,2,'first');
idx_lab22 = find(GK_RS15_01_baseline_0000_027_3_.Amps<0,2,'first');

idx_lab2 = 4522;
idx_lab1 = 4617;


figure
plot(sim_results.time,sim_results.V,'LineWidth',3);
hold on
plot(sim_results.time,sim_results.states(:,1),'LineWidth',3);
plot(GK_RS15_02_baseline_0000_028_1_.TestTime(idx_lab1:end) - GK_RS15_02_baseline_0000_028_1_.TestTime(idx_lab1),GK_RS15_02_baseline_0000_028_1_.Volts(idx_lab1:end),'LineWidth',3);
load baseline28-800.mat
plot(GK_RS15_01_baseline_0000_027_3_.TestTime(idx_lab2:end) - GK_RS15_01_baseline_0000_027_3_.TestTime(idx_lab2),GK_RS15_01_baseline_0000_027_3_.Volts(idx_lab2:end),'LineWidth',3);
legend(["Simulation", "Batt B", "Batt A"], "Interpreter", "latex", "FontSize", 13, "Position", [0.7383 0.8503 0.0936, 0.0566])
set(gcf, "Theme", "light");
xlim([3167 6443])
ylim([3.221 3.658])
xi = xline(1, '-', 'Next Cycle Start - Discharge Start','Interpreter','latex','FontSize',13);
xi.LineWidth = 1.5;
xi.Color = [0 0 0];
xs = xline(1452, '-', 'Discharge End - Rest Start','Interpreter','latex','FontSize',13);
xs.LineWidth = 1.5;
xs.Color = [0 0 0];
x3 = xline(3215, '--', 'Rest End - Charge Start','Interpreter','latex','FontSize',13);
x3.LineWidth = 1.5;
x3.Color = [0 0 0];
xf = xline(6549, '-', 'Charge End','Interpreter','latex','FontSize',13);
xf.LineWidth = 1.5;
xf.Color = [0 0 0];
xf = xline(8596, '-', 'Cycle End - Next Cycle Start','Interpreter','latex','FontSize',13);
xf.LineWidth = 1.5;
xf.Color = [0 0 0];
% Optional label positioning tweaks
xs.LabelHorizontalAlignment = 'right';
x3.LabelHorizontalAlignment = 'right';
xf.LabelHorizontalAlignment = 'right';
grid on

xlabel("Time $(S)$", "Interpreter", "latex", "FontSize", 13)
ylabel("Volts $(V)$", "Interpreter", "latex", "FontSize", 13)


figure
plot(sim_results.time, sim_results.states(:,3));
hold on

load baseline27-800.mat
figure
plot(sim_results.time,sim_results.states(:,3),'LineWidth',3);
hold on
plot(GK_RS15_02_baseline_0000_028_1_.TestTime(idx_lab1:end) - GK_RS15_02_baseline_0000_028_1_.TestTime(idx_lab1),GK_RS15_02_baseline_0000_028_1_.Temp1(idx_lab1:end),'LineWidth',3);
load baseline28-800.mat
plot(GK_RS15_01_baseline_0000_027_3_.TestTime(idx_lab2:end) - GK_RS15_01_baseline_0000_027_3_.TestTime(idx_lab2),GK_RS15_01_baseline_0000_027_3_.Temp1(idx_lab2:end),'LineWidth',3);

set(gcf, "Theme", "light");
xlim([3167 6443])
ylim([24 30])
xi = xline(1, '-', 'Next Cycle Start - Discharge Start','Interpreter','latex','FontSize',13);
xi.LineWidth = 1.5;
xi.Color = [0 0 0];
xs = xline(1452, '-', 'Discharge End - Rest Start','Interpreter','latex','FontSize',13);
xs.LineWidth = 1.5;
xs.Color = [0 0 0];
x3 = xline(3215, '--', 'Rest End - Charge Start','Interpreter','latex','FontSize',13);
x3.LineWidth = 1.5;
x3.Color = [0 0 0];
xf = xline(6549, '-', 'Charge End','Interpreter','latex','FontSize',13);
xf.LineWidth = 1.5;
xf.Color = [0 0 0];
xf = xline(8596, '-', 'Cycle End - Next Cycle Start','Interpreter','latex','FontSize',13);
xf.LineWidth = 1.5;
xf.Color = [0 0 0];
% Optional label positioning tweaks
xs.LabelHorizontalAlignment = 'right';
x3.LabelHorizontalAlignment = 'right';
xf.LabelHorizontalAlignment = 'right';
grid on
legend(["Simulation", "Batt B", "Batt A"], "Interpreter", "latex", "FontSize", 13, "Position", [0.7383 0.8503 0.0936, 0.0566])

xlabel("Time $(S)$", "Interpreter", "latex", "FontSize", 13)
ylabel("Temperature $(C^\circ)$", "Interpreter", "latex", "FontSize", 13)