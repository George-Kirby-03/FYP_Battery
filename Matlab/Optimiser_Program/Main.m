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
addpath(genpath('ICLOCS_Optimisation_files'))
load RS_LiPo_extracted.mat

[V,I,T,Ah,Ts] = get_cycle("GK_RS15_07_proc3_0000 - 031 (1).csv",1);
sim_handler = cell(1, size(V,2)-1);


settings.nodes = 230;
settings.iterations = 200; 
settings.polycount = 14;
settings.v_lim = 3.6;
settings.v_low = 2.5;

dynamics  = struct('Q',1.53*3600,'C',800,'R0',0.075,'R1',0.05,'Cp',160,'h',1);
enforce.temp_strength = 0;

idx = find(mod(1:size(V,2)-1, 5) == 0);
V = V(idx);
I = I(idx);
Ts = Ts(idx);
T = T(idx);
Ah = Ah(idx);


parfor (i = 1:length(idx),10)
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




%% Second stage is to optionally show the 3d thermal model, to ensure that the internals and externals arent too different
%% If they are different, it may be wise to optimised against the hot internals rather than use the 0D lumped Cp & H produced
%% From above

%optional
%Full_thermal_simulation(sim_handler);


%% Code to produce graphs to help make charge discharge descisions based from the framework used in Attias paper, 



%% For this projects setting, the duration of 0-100% SoC charge has been determined and documented in the thesis, raw values
%% are used here but can be obtained from the graphs produced above too 

%sim_handler.discharge_rate = 2;
%sim_handler.rest_period_discharge = 0.2;
%sim_handler.rest_period_charge = 0.1;


%% The optimised protocols can now be produced, below calcuates the optimal stages for minimising Max Temp, minimising Temp state,
%% minimising Paings Cost Function, and hopefully, one from AI / use to predict life cycle 

%OPTIONAL function to use a predifned ocv_curve for otpimsations if one
%wanst given during the parametrisation stage

sim_handler = ocv_fun_injection(sim_handler,ocv_curve_2);

%Optimiser settings to configure
optim_settings.Tmax=80;
optim_settings.Tamb=20;
optim_settings.tf=1860;

%Paings_model = Optimum_Generator(sim_handler,'Paings'); (Not made yet)
sim_handler = Optimum_Generator(sim_handler,optim_settings,'Min_Maxtemp');
main_BatteryCharging(sim_handler)
%Min_temp = Optimum_Generator(sim_handler,'Min_Temp'); (Not made yet)



