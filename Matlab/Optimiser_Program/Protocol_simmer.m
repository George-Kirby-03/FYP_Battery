%% ODE Simulations of the protocols

%Settings and charging protocol specified (currently using manual method
%but can easily give current struct entry directly from above optimiser
%outputs)

%For Protocol 3 Minimising temp intergral

load MinTempInt-a.mat
load RS_LiPo_extracted.mat
avg_sim_handle_b1 = sim_average(sim_handler,20,'Start');
avg_sim_handle_b1 = ocv_fun_injection(avg_sim_handle_b1,ocv_curve_2);
avg_sim_handle_b1.current_sol.Q = 5.52e03;
avg_sim_handle_b1.current_sol.C = 800;
avg_sim_handle_b1.current_sol.R0 = 0.075;
avg_sim_handle_b1.current_sol.R1 = 0.045;
avg_sim_handle_b1.current_sol.Cp = 100.8;
avg_sim_handle_b1.current_sol.h = 0.128;
% load paings1-200b2.mat
% avg_sim_handle_b2 = sim_average(sim_handler,5,'Start');

%avg_sim_handle_b1 = ocv_fun_injection(avg_sim_handle_b1,ocv_curve_2);

charge_protocol.capacity_selection = 'Discharge'; % or 'Absolute'
charge_protocol.charge_segments = [0 20 40 60 80 100]; %Specify as many segments as needed
charge_protocol.charge_currents = [1.3 1.45 1.75 1.53 0.5] * 1.5; %Specify current per segment in c
charge_protocol.CV_cutoff = 1.5/20; %Segment CV stage (if met) will stop once current falls to this limit
charge_protocol.discharge_segments = [100 0]; %Specify as many segments as needed
charge_protocol.discharge_currents = [2.55]*1.5; %Specify current per segment in c here
charge_protocol.discharge_charge_rest = 63*30; %If set, there will be a rest period between charge and discharge ...
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
idx = find(avg_sim_handle_b1.original_data.amps<0,1,'first');
figure()
% plot(sim_results.time,sim_results.V);
hold on
% %plot(sim_results_b2.time,sim_results_b2.V);
plot(sim_results.time,sim_results.I,sim_results.time,sim_results.V);
plot(avg_sim_handle_b1.original_data.ts(idx:end) - avg_sim_handle_b1.original_data.ts(idx),avg_sim_handle_b1.original_data.volts(idx:end));
% plot(avg_sim_handle_b1.original_data.ts(idx:end) - avg_sim_handle_b1.original_data.ts(idx),avg_sim_handle_b1.original_data.amps(idx:end))

