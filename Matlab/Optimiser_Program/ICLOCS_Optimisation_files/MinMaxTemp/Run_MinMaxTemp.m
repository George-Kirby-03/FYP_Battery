function results = Run_MinMaxTemp(sim_handler)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    sim_handler struct
end

[problem,guess,options.phaseoptions]=MinMaxTemp_Problem(sim_handler);          % Fetch the problem definition
options.mp= settings_BatteryCharging;                  % Get options and solver settings 
[solution,~]=solveMyProblem( problem,guess,options);

currents =[];
durations = [];
%%
for i=1:length(solution.phaseSol)
    sol=solution.phaseSol{i};
    xx=sol.T;
    x1=speval(sol,'X',1,xx);
    currents = [currents, sol.p(i)];
    durations = [durations, xx(end)];

end

results.durations = durations;
results.currents = currents;
results.solution_dat = solution;
results.problem_dat = problem;
end