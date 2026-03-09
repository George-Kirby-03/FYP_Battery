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

table = readtable("GK_RS15_03_proc1_0000 - 025 (1).csv");

table1 = readtable("GK_RS15_07_proc3_0000 - 031 (1).csv");

%Find a good start to the cycle
idx_start = find(table1.Step == 5, 1);
if table1.Step(idx_start(1)-1) == 12
    idx_cycle_start = idx_start(1) - 10;
else
    idx_next_try = find(table1.Step(idx_start:end) ~= 5,1);
    idx_start = find(table1.Step(idx_next_try+1:end) == 5, 1);
    idx_cycle_start = idx_start(1) - 5;
end
%Find where the next step 12 occurs, the get the idx of the first for
%current to go 0 (once cv is done)
idx_last = find(table1.Step(idx_start:end) == 12, 1);
idx_cycle_end = find(table1.Amps(idx_last:end) < 0.01,1);
idx_last
table1.TestTime(idx_last)
idx_cycle_end
idx_cycle_end = idx_cycle_end + 3000;

plot(table1.TestTime(idx_cycle_start:idx_cycle_end),table1.Volts(idx_cycle_start:idx_cycle_end),table1.TestTime(idx_cycle_start:idx_cycle_end),table1.Step(idx_cycle_start:idx_cycle_end))



%% Second stage is to optionally show the 3d thermal model, to ensure that the internals and externals arent too different
%% If they are different, it may be wise to optimised against the hot internals rather than use the 0D lumped Cp & H produced
%% From above




%% Code to produce graphs to help make charge discharge descisions based from the framework used in Attias paper, 



%% For this projects setting, the duration of 0-100% SoC charge has been determined and documented in the thesis, raw values
%% are used here but can be obtained from the graphs produced above too 


%% The optimised protocols can now be produced, below calcuates the optimal stages for minimising Max Temp, minimising Temp state,
%% minimising Paings Cost Function, and hopefully, one from AI / use to predict life cycle 





