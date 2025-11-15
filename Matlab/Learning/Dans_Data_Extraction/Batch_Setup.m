function batch = Batch_Setup(battery_type,solver)
file_loc = "..\..\..\cycle_exports\";
cycles = dir(fullfile(file_loc, battery_type, '*.mat'));
numCycles = length(cycles);

for k = 1:numCycles
    filePath = fullfile(file_loc, battery_type, cycles(randi([1,numCycles])).name);
    tmp = load(filePath);
    %%Only gives file to use to iclocs if its not been ran before
    if ~isfield(tmp, 'solution_unbound') && solver == 0
            batch = filePath;
            break
    %%Only gives file to use to temp_param if its been iclocs ran &
    %%not_temp ran before
    elseif solver == 1 && isfield(tmp, 'solution_unbound') && ~isfield(tmp, 'solution_temp')
              batch = filePath; 
              break
    end
    if k == numCycles
        error("No files left to process")
    end
end

end