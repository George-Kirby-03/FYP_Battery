function batch = Batch_Setup(battery_type, solver, size, cycle)
%% Returns array of cycle files to be run for solvers
% If size is given, will return an array of random speciied amount by size
% If cycle is given, will try return speciied cycle

arguments
    battery_type (1,:) char 
    solver (1,1) double
    size (1,1) double = 1
    cycle = 'NaN'
end

file_loc = "../../../cycle_exports/";
cycles = dir(fullfile(file_loc, battery_type, '*.mat'));
numCycles = length(cycles);

if numCycles == 0
    error("No cycle files found in folder: %s", fullfile(file_loc, battery_type));
end
if size > 1 && ~strcmp(cycle,'NaN')
batch = strings(1,1);
else
    batch = strings(size,1);
end
if ~strcmp(cycle,'NaN')
    cycle_nums = nan(numCycles,1);
    for i = 1:numCycles
        cyc = regexp(cycles(i).name, '_(\d+)\.mat', 'tokens', 'once');
        if ~isempty(cyc)
            cycle_nums(i) = str2double(cyc{1});
        end
    end

    idx = find(cycle_nums == cycle, 1);

    if isempty(idx)
        error("No file exists matching cycle _%d.mat", cycle);
    end
    batch(1) = fullfile(file_loc, battery_type, cycles(idx).name);
    filePath = fullfile(file_loc, battery_type, cycles(idx).name);
    tmp = load(filePath);
    ok = false;
    switch solver
            case 0
                ok = ~isfield(tmp,'solution_unbound');

            case 1
                ok = isfield(tmp,'solution_unbound') && ~isfield(tmp,'greyest');

            case 2
                ok = ~isfield(tmp,'solution_temp');

            otherwise
                error("Unknown solver type %d", solver);
    end
    if ok
        batch(1) = filePath; 
    else
        error("File has either not had previous solver or already solved");
    end
    return;
end

for i = 1:size

    random_idx = randperm(numCycles); %randomperm is like python itterable
    found = false;

    for k = random_idx
        filePath = fullfile(file_loc, battery_type, cycles(k).name);
        tmp = load(filePath);

        switch solver
            case 0
                ok = ~isfield(tmp,'solution_unbound');

            case 1
                ok = isfield(tmp,'solution_unbound') && ~isfield(tmp,'greyest');

            case 2
                ok = ~isfield(tmp,'solution_temp');

            otherwise
                error("Unknown solver type %d", solver);
        end

        if ok
            batch(i) = filePath;
            found = true;
            break;
        end
    end

    if ~found
        % no suitable files left
        if i == 1
            batch = 0;        % your original behaviour
        else
            batch = batch(1:i-1);
        end
        error("No files left to process for solver %d", solver);
    end
end

end
