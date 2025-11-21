function [solution_complete, cycle_number] = SolutionLoader(battery_type,model,cycle)
%% Function which loads a simulated cycle, can be a random one or specified one, returns cycle number too (same as input if not random)
%Model 0 = Only non temp iclocs ran
%Model 1 = Non temp iclocs and sepeperate greeyst temp cycle ran
%Model 2 = Iclcocs temp combined is run
arguments
    battery_type 
    model 
    cycle = 'NaN'
end
file_loc = "..\..\..\cycle_exports\";
cycles = dir(fullfile(file_loc, battery_type, '*.mat'));
numCycles = length(cycles);
if ~strcmp(cycle,'NaN')

cycle_nums = zeros(numCycles,1);
for i = 1:numCycles
    token = regexp(cycles(i).name, '_(\d+)\.mat', 'tokens', 'once');
    if ~isempty(token)
        cycle_nums(i) = str2double(token{1});
    else
        cycle_nums(i) = NaN; 
    end
end

idx = find(cycle_nums == cycle, 1);
if isempty(idx)
    error("No file exists for cycle _%d.mat", cycle);
end

filePath = fullfile(file_loc, battery_type, cycles(idx).name);

    tmp = load(filePath);
    if model == 0 
        if isfield(tmp,'solution_unbound') && ~isfield(tmp,'greyest')
            solution_complete = filePath;
        else
            error("Field 'solution_unbound' not found in the loaded file. Run Simulation first");
        end
    end
    if model == 1
        if isfield(tmp,'solution_unbound') && isfield(tmp,'greyest')
             solution_complete = filePath;
        else
            error("Fields 'solution_unbound' or 'greyest' not found in the loaded file.Run both Simulations first");
        end
    end
     if model == 2
        if isfield(tmp,'solution_temp')
             solution_complete = filePath;
        else
            error("Fields 'solution_temp' not found in the loaded file.Run Simulation first");
        end
    end
else
for k = 1:numCycles
    filePath = fullfile(file_loc, battery_type, cycles(randi([1,numCycles])).name);
    tmp = load(filePath);
    %%Only gives file to use to iclocs if its not been ran before
     if model == 0 && isfield(tmp,'solution_unbound') && ~isfield(tmp,'greyest')
            solution_complete = filePath;
            break
     end
    if model == 1 && isfield(tmp,'solution_unbound') && isfield(tmp,'greyest')
             solution_complete = filePath;
             break
    end
     if model == 2 && isfield(tmp,'solution_temp')
             solution_complete = filePath;
              break
    end
    if k == numCycles
        clear solution_complete
        error("No files left to process, could not find any that meets solutions specified")
    end
end
end
cycle_number =  str2double(regexp(solution_complete, '_(\d+)\.mat', 'tokens', 'once'));
end