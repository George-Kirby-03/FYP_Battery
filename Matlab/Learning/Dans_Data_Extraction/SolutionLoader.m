function [solution_complete, cycle_number] = SolutionLoader(battery_type,model,cycle)
%% Function which loads a simulated cycle with params, can be a random one or specified one
arguments
    battery_type 
    model 
    cycle = 'NaN'
end

file_loc = "..\..\..\cycle_exports\";
cycles = dir(fullfile(file_loc, battery_type, '*.mat'));
numCycles = length(cycles);

cycle_nums = nan(numCycles,1);
for i = 1:numCycles
    tok = regexp(cycles(i).name, '_(\d+)\.mat', 'tokens', 'once');
    if ~isempty(tok)
        cycle_nums(i) = str2double(tok{1});
    end
end

if ~strcmp(cycle,'NaN')

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
            error("Cycle exists, but missing required fields.");
        end
    end

    if model == 1
        if isfield(tmp,'solution_unbound') && isfield(tmp,'greyest')
            solution_complete = filePath;
        else
            error("Cycle exists, but missing required fields from greyest.");
        end
    end

    if model == 2
        if isfield(tmp,'solution_temp')
            solution_complete = filePath;
        else
            error("Cycle exists, but missing required fields from iclocs temp");
        end
    end

else

    order = randperm(numCycles);  % python type iterable
    solution_found = false;

    for k = 1:numCycles
        idx = order(k);
        filePath = fullfile(file_loc, battery_type, cycles(idx).name);
        tmp = load(filePath);
        if model == 0
            if isfield(tmp,'solution_unbound') && ~isfield(tmp,'greyest')
                solution_complete = filePath;
                solution_found = true;
                break
            end
        end
        if model == 1
            if isfield(tmp,'solution_unbound') && isfield(tmp,'greyest')
                solution_complete = filePath;
                solution_found = true;
                break
            end
        end
        if model == 2
            if isfield(tmp,'solution_temp')
                solution_complete = filePath;
                solution_found = true;
                break
            end
        end
    end

    if ~solution_found
        error("No files left to process that meet required fields for model %d.", model);
    end
end

name = regexp(solution_complete, '_(\d+)\.mat', 'tokens', 'once');
cycle_number = str2double(name{1});

end
