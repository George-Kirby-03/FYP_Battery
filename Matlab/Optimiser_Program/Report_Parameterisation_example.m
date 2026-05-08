load RS_LiPo_extracted.mat %Contains the found OCV curve to optionally be injected inplace of ICLOCS parameterised OCV
% 


[V,I,T,Ah,Ts] = get_cycle("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_07_proc3_0000 - 031 (2).csv",1);


% Construct the cycle data, since get_cycle has detected multpile, each
% cycle is cell in an array

cycle = [];
cycle.volts = V;
cycle.amps = I;
cycle.ts = Ts;
cycle.tp = T;
cycle.Ah = Ah;


settings.nodes = 230;
settings.iterations = 200; 
settings.polycount = 14;
settings.v_lim = 3.65;
settings.v_low = 2.5;

dynamics  = struct('Q',1.53*3600,'C',800,'R0',0.075,'R1',0.045,'Cp',160,'h',1);
enforce.temp_strength = 0.0001;

spacing=5;

sim_handlers = Cycle_Parmeterisation(cycle,dynamics,settings,enforce,[],spacing);
sim_handlers = Greyest_Parameterisation(sim_handlers);


load RS_LiPo_extracted.mat %Contains the found OCV curve to optionally be injected inplace of ICLOCS parameterised OCV
% 
 [V,I,T,Ah,Ts] = get_cycle("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_07_proc3_0000 - 031 (2).csv",1);
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