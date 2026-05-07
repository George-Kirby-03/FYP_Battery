%% Here lies the main file to 1) Parameterise the battery data from a cycle 
%% 2) Use those parameters to produce the optimised profiles and 3) To visualise said profiles
%% In fact this could be used as an all ecompasing file for GK project, showing both the heat simulations,
%% Discharge Ratings, and also run the AI to predict life cycle life...

%% Parameterisation from cycles (A LOT of time in Semester 1 was spent trialing & erroring this), unfortunatley it seems
%% for batteries with long and slow polorisations, the 1 stage RC model can struggle in parameterisation, especially with 
%% unbound OCV curves, so below has the slection to either run with a fixed ocv, or to also predict this

%% Function to extract a cycle from CSV, note that this expects the form from MACCOR, if not, extract yourself

%[V,I,T,Ts] = get_cycle("fhsjfs.csv");

%Wrapper for the ICLOC's code
%parameters = get_parameters(V,I,T,Ts,'own_ocv','start_conditions','end_conditions');


% 3 structs, one is settings to set voltage lims, polylength and end/start conditions, other is
% estimates on parameters and the last is a struct to specify what
% parameters to fix or find


addpath(genpath('../ICLOCS_Parameterisation_files'))
addpath(genpath('../Greyest_Parameterisation_files'))
addpath(genpath('../ICLOCS_Optimisation_files'))
addpath(genpath('../ODE_Simulations'))
addpath(genpath('../Misc_functions'))

%load RS_LiPo_extracted.mat %Contains the found OCV curve to optionally be injected inplace of ICLOCS parameterised OCV
% 
[V,I,T,Ah,Ts] = get_cycle("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\Data_Handle_Gen_Report\GK_RS15_08_proc3_0000 - 032 (3).csv",1);
sim_handler = cell(1, size(V,2)-1);
% 
settings.nodes = 230;
settings.iterations = 200; 
settings.polycount = 14;
settings.v_lim = 3.65;
settings.v_low = 2.5;

dynamics  = struct('Q',1.53*3600,'C',800,'R0',0.075,'R1',0.045,'Cp',160,'h',1);
enforce.temp_strength = 0.0001;

idx = find(mod(1:size(V,2)-1, 5) == 0);
V = V(idx);
I = I(idx);
Ts = Ts(idx);
T = T(idx);
Ah = Ah(idx);


parfor (i = 1:length(idx),32)
    cycle = [];
    cycle.volts = V{i};
    cycle.amps = I{i};
    cycle.ts = Ts{i} - Ts{i}(1);
    cycle.tp = T{i} - T{i}(1);
    cycle.Ah = Ah{i};

    tmp = Cycle_Parmeterisation(cycle,dynamics,settings,enforce,[]);
    tmp = Greyest_Parameterisation(tmp);

    sim_handler{i} = tmp;
end
save Min_Intg_B_200_400.mat sim_handler
%%
% %Alternativley loading presimulated cycles here
% %load baseline1-800.mat
% 
% %Optionally an averaging on the battery parameters (accept ocv curve) can
% %be made (will keep a single instace of the original data if needed for
% %comparison)
% 
% avg_sim_handle = sim_average(sim_handler,5,'End');
% 
% 
% %% Second stage is to optionally show the 3d thermal model, to ensure that the internals and externals arent too different
% %% If they are different, it may be wise to optimised against the hot internals rather than use the 0D lumped Cp & H produced
% %% From above
% 
% %optional
% %Full_thermal_simulation(sim_handler);
% 
% 
% %% Code to produce graphs to help make charge discharge descisions based from the framework used in Attias paper, 
% 
% 
% 
% %% For this projects setting, the duration of 0-100% SoC charge has been determined and documented in the thesis, raw values
% %% are used here but can be obtained from the graphs produced above too 
% 
% 
% 
% %% The optimised protocols can now be produced, below calcuates the optimal stages for minimising Max Temp, minimising Temp state,
% %% minimising Paings Cost Function, and hopefully, one from AI / use to predict life cycle 
% 112599
% sim_handler = ocv_fun_injection(sim_handler,ocv_curve_2);
% 
% %Optimiser settings to configure
% optim_settings.Tmax=80;
% optim_settings.Tamb=20;
% optim_settings.tf=1860;
% 
% %Paings_model = Optimum_Generator(sim_handler,'Paings'); (Not made yet)
% sim_handler = Optimum_Generator(sim_handler,optim_settings,'Min_Maxtemp');
% main_BatteryCharging(sim_handler)
% %Min_temp = Optimum_Generator(sim_handler,'Min_Temp'); (Not made yet)
% 
% 

%% ODE Simulations of the protocols

%Settings and charging protocol specified (currently using manual method
%but can easily give current struct entry directly from above optimiser
%outputs)

%For Protocol 3 Minimising temp intergral

load baseline28-800.mat
avg_sim_handle_b1 = sim_average(sim_handler,10,'Start');
avg_sim_handle_b1.current_sol.Q = max(avg_sim_handle_b1.original_data.Ah)*60^2;
load paings1-200b2.mat
avg_sim_handle_b2 = sim_average(sim_handler,5,'Start');

%avg_sim_handle_b1 = ocv_fun_injection(avg_sim_handle_b1,ocv_curve_2);

charge_protocol.capacity_selection = 'Discharged'; % or 'Absolute'
charge_protocol.charge_segments = [0 20 40 60 80 100]; %Specify as many segments as needed
charge_protocol.charge_currents = [1.73 1.73 1.6 1.39 0.5] * 1.5; %Specify current per segment in c
charge_protocol.CV_cutoff = 1.5/20; %Segment CV stage (if met) will stop once current falls to this limit
charge_protocol.discharge_segments = [100 0]; %Specify as many segments as needed
charge_protocol.discharge_currents = [2.5]*1.5; %Specify current per segment in c here
charge_protocol.discharge_charge_rest = 60*30; %If set, there will be a rest period between charge and discharge ...
charge_protocol.discharge_CV = 'True'; %False will mean once a discharge segment reaches vlim, it will switch to the next.
%segment instantly without running CV, it makes more sense to use this in
%conjunction with capacity_selection as 'Discharged'
charge_protocol.charge_CV = 'True'; % Allows for CV stage at the end (will also apply to mid segments too)
charge_protocol.ambient_temp = 24;

sim_results = odeSOC(avg_sim_handle_b1,charge_protocol);


charge_protocol.charge_currents = [2 1.8 1.65 0.9 0.75] * 1.5; %Specify current per segment in c here
sim_results_b2 = odeSOC(avg_sim_handle_b2,charge_protocol);
%Outputs are...
% sim_results.time = vertcat(seg_time{:});
% sim_results.states = vertcat(seg_states{:});
% sim_results.I = vertcat(I{:});
% sim_results.V = V_out;
%Compare simulated and actual labs
%Find where the discharge starts
idx = find(avg_sim_handle_b1.original_data.amps<0,1,'first');
figure()
plot(sim_results.time,sim_results.V);
hold on
%plot(sim_results_b2.time,sim_results_b2.V);
plot(sim_results.time,sim_results.I);
plot(avg_sim_handle_b1.original_data.ts(idx:end) - avg_sim_handle_b1.original_data.ts(idx),avg_sim_handle_b1.original_data.volts(idx:end));
plot(avg_sim_handle_b1.original_data.ts(idx:end) - avg_sim_handle_b1.original_data.ts(idx),avg_sim_handle_b1.original_data.amps(idx:end))

