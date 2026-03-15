function sim_handler = Cycle_Parmeterisation(cycle,dynamics,settings,enforce,ocv_curve)
%CYCLE_PARMETERISATION undefined
%   undefined
arguments (Input)
    cycle
    dynamics struct = struct()
    settings struct = struct()
    enforce struct = struct()
    ocv_curve = 0
end

arguments (Output)
    sim_handler
end


[problem,guess]=BatteryEstimation_temp(cycle,settings,dynamics,enforce,ocv_curve);          % Fetch the problem definition
options=problem.settings(250);                  % Get options and solver settings 
[solution,~]=solveMyProblem( problem,guess,options);

sim_handler.original_data = cycle;

dynamics_vars = fieldnames(dynamics);
for i=1:length(dynamics_vars)
    if isfield(problem.data.poly,(dynamics_vars{i})) %these struct members is the index to the actuall data
        sim_handler.current_sol.(dynamics_vars{i}) = solution.p(problem.data.poly.(dynamics_vars{i}));
    elseif strcmp(dynamics_vars{i},'Cp') || strcmp(dynamics_vars{i},'h')  %at this point, iclcos hasnt simed theses, so put them in greyests area as guesses
        sim_handler.greyest.est.(dynamics_vars{i}) = dynamics.(dynamics_vars{i});
    else %If params arent simed, use the guessed/known values, i.e capacity for example
        sim_handler.current_sol.(dynamics_vars{i}) = dynamics.(dynamics_vars{i});
    end     
end

if isfloat(ocv_curve)
    sim_handler.ocv_curve.polys = solution.p(1:(problem.data.poly.poly_length));
else
    sim_handler.ocv_curve.curvefun = ocv_curve;
end



end