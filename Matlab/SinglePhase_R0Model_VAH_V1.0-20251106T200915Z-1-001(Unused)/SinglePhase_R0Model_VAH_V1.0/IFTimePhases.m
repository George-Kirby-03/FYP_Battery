function [t_min,t_max,guess_time] = IFTimePhases(Phases)

% Initial and Final Time for Different Phases

% Example usage:
% Phases = {"Name1", "Seg2", "File3"};
% [problem.mp.time.t_min,problem.mp.time.t_max,guess.mp.time]=IFTimePhases(Phases);
%------------- BEGIN CODE --------------

N_phases = numel(Phases); 
tf = zeros(1, N_phases);

for i = 1:N_phases
    data = load(Phases{i}, 'tt');  
    tf(i) = data.tt(end);
end

t_min   = [0, tf];
t_max   = [0, tf];
guess_time = [0, tf];

end
