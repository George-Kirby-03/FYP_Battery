function sim_handler = Optimum_Generator(sim_handler,optimisation_parameters,optimisation_goal)
%OPTIMUM_GENERATOR undefined
%   undefined
arguments (Input)
    sim_handler struct
    optimisation_parameters struct
    optimisation_goal string
end
if isempty(optimisation_parameters)
    error('No optimisation parameters given')
else
    sim_handler.optim_params = optimisation_parameters;
end
if strcmpi(optimisation_goal,'Paings')
elseif strcmpi(optimisation_goal,'Min_Maxtemp')
   results = Run_MinMaxTemp(sim_handler);
   sim_handler.MinMaxTemp = results;
elseif strcmpi(optimisation_goal,'Min_Temp')
else
    error("No valid optimisation strategy selected, choose either: Paings, Min_Maxtemp or Min_temp")
end
end



