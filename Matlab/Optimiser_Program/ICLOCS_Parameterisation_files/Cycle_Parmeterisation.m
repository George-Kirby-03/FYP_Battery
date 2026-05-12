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


[problem,guess]=BatteryEstimation_temp(cycle,settings,dynamics,enforce,ocv_curve);   
if isfield(settings,'nodes')
    nodes = settings.nodes;
else
    nodes = 200;
end
options=problem.settings(nodes);                  % Get options and solver settings 
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
    sim_handler.ocv_curve_dat.polys = solution.p(1:(problem.data.poly.poly_length));
    temp.poly.xe = ones(1,length(problem.data.poly.xe));
    sim_handler.ocv_curve = @(x1) polymodel(temp,sim_handler.ocv_curve_dat.polys,x1,1);
else
    sim_handler.ocv_curve_dat.curvefun = ocv_curve;
    temp.ocv_curve = sim_handler.ocv_curve_dat.curvefun;
    sim_handler.ocv_curve = @(x1) polymodel(temp,0,x1,1);
end


sim_handler.states_sol.T=solution.T;
sim_handler.states_sol.SoC=speval(solution,'X',1,sim_handler.states_sol.T);
sim_handler.states_sol.Pol=speval(solution,'X',2,sim_handler.states_sol.T);
sim_handler.states_sol.Temp=speval(solution,'X',3,sim_handler.states_sol.T);
sim_handler.states_sol.Current=problem.data.InputCurrent(sim_handler.states_sol.T);


end