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
%parameters = get_parameters(V,I,T,Ts,'own_ocv','start_conditions','end_conditions')


% 3 structs, one is settings to set voltage lims, polylength and end/start conditions, other is
% estimates on parameters and the last is a struct to specify what
% parameters to fix or find


addpath(genpath('ICLOCS_Parameterisation_files'))
addpath(genpath('Greyest_Parameterisation_files'))
load RS_LiPo_extracted.mat

[V,I,T,Ts] = get_cycle("GK_RS15_07_proc3_0000 - 031 (1).csv");
cycle.volts = V;
cycle.amps = I;
cycle.ts = Ts - Ts(1); % start from t=0
cycle.tp = T - T(1);

% settings_default = struct('polycount',13,'v_low',0,'v_lim',0,'start_soc',0,'end_soc',1,'range',0.05);
% dynamics_default = struct('Q',1.5*3600,'C',300,'R0',0.05,'R1',0.05,'Cp',160,'h',1);
% enforce_default = struct('Q',0,'C',0,'R0',0,'R1',0,'Cp',0,'h',0,'v_lim_strength',0.03,'temp_strength',0.05);

settings.polycount = 0;
settings.v_lim = 3.65;
settings.v_low = 2.5;
dynamics  = struct('Q',1.5*3600,'C',300,'R0',0.05,'R1',0.05,'Cp',160,'h',1);

sim_handler = Cycle_Parmeterisation(cycle,dynamics,settings,[],ocv_curve_2);
%Parameterisation_Analysis(sim_handler);
sim_handler = Greyest_Parameterisation(sim_handler);
%Greyest_Analysis(sim_handler);





%% Second stage is to optionally show the 3d thermal model, to ensure that the internals and externals arent too different
%% If they are different, it may be wise to optimised against the hot internals rather than use the 0D lumped Cp & H produced
%% From above

%optional
Full_thermal_simulation(sim_handler);


%% Code to produce graphs to help make charge discharge descisions based from the framework used in Attias paper, 



%% For this projects setting, the duration of 0-100% SoC charge has been determined and documented in the thesis, raw values
%% are used here but can be obtained from the graphs produced above too 

sim_handler.discharge_rate = 2;
sim_handler.rest_period_discharge = 0.2;
sim_handler.rest_period_charge = 0.1;


%% The optimised protocols can now be produced, below calcuates the optimal stages for minimising Max Temp, minimising Temp state,
%% minimising Paings Cost Function, and hopefully, one from AI / use to predict life cycle 


Paings_model = Optimum_Generator(sim_handler,'Paings');
Min_maxtemp = Optimum_Generator(sim_handler,'Min_Maxtemp');
Min_temp = Optimum_Generator(sim_handler,'Min_Temp');



