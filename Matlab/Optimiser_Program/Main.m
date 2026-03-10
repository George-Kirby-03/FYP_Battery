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


[V,I,T,Ts] = get_cycle("GK_RS15_07_proc3_0000 - 031 (1).csv",1);
plot(Ts,V,Ts,I,Ts,T)

% 3 structs, one is settings to set voltage lims, polylength and end/start conditions, other is
% estimates on parameters and the last is a struct to specify what
% parameters to fix or find

%% Second stage is to optionally show the 3d thermal model, to ensure that the internals and externals arent too different
%% If they are different, it may be wise to optimised against the hot internals rather than use the 0D lumped Cp & H produced
%% From above




%% Code to produce graphs to help make charge discharge descisions based from the framework used in Attias paper, 



%% For this projects setting, the duration of 0-100% SoC charge has been determined and documented in the thesis, raw values
%% are used here but can be obtained from the graphs produced above too 


%% The optimised protocols can now be produced, below calcuates the optimal stages for minimising Max Temp, minimising Temp state,
%% minimising Paings Cost Function, and hopefully, one from AI / use to predict life cycle 





