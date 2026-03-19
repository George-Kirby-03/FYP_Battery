function [V,I,T,Ts] = get_cycle(csvfile,mode)
%GET_CYCLE undefined
%   undefined
arguments (Input)
    csvfile string
    mode = 0
end

arguments (Output)
    V
    I
    T
    Ts
end

table1 = readtable(csvfile);
if mode == 0
i = 1;
while true  
    %Find a good start to the cycle
    idx_start = find(table1.Step == 5, 1);
    if table1.Step(idx_start-1) == 12
        idx_cycle_start = idx_start - 30;
    else
        idx_next_try = find(table1.Step(idx_start:end) ~= 5,1);
        idx_start = find(table1.Step(idx_next_try+idx_start:end) == 5, 1);
        idx_cycle_start = idx_start+idx_next_try+idx_start - 40;
    end
    %Find where the next step 12 occurs, the get the idx of the first for
    %current to go 0 (once cv is done)
    % unfortnatley still back in old 12 step so again need to move till the
    % next new step 12...
    idx_next_12 = find(table1.Step(idx_cycle_start:end) ~= 12, 1);
    idx_last = find(table1.Step(idx_next_12+idx_cycle_start:end) == 12, 1);
    idx_cycle_end = find(table1.Amps(idx_next_12+idx_last+idx_cycle_start:end) < 0.01,1);
        if isempty(idx_last)
            break
        end
    idx_cycle_end = idx_cycle_end + idx_next_12+idx_last+idx_cycle_start;
    V{i}  = table1.Volts(idx_cycle_start:idx_cycle_end);
    I{i}  = table1.Amps(idx_cycle_start:idx_cycle_end);
    T{i}  = table1.Temp1(idx_cycle_start:idx_cycle_end);
    Ts{i} = table1.TestTime(idx_cycle_start:idx_cycle_end);    
    %Truncate and repeat
    table1 = table1(idx_cycle_end:end,:);
    i = i+1;
end
else
    i = 1;
    while true  
        idx_discharge_start = find(table1.Amps < -0.01, 1);
        idx_discharge_start = idx_discharge_start - 10;
       % time0 = table1.TestTime(idx_discharge_start);
        if idx_discharge_start < 1
            break
        end
        idx_charge_start = find(table1.Amps(idx_discharge_start:end) > 0.01, 1);
        idx_charge_end_search = idx_charge_start + idx_discharge_start + 1;
        idx_charge_end = find(table1.Amps(idx_charge_end_search:end) < 0.01, 1);
        idx_end = idx_charge_end + idx_charge_end_search;
       % time1 = table1.TestTime(idx_end);
        V{i} = table1.Volts(idx_discharge_start:idx_end);
        I{i}  = table1.Amps(idx_discharge_start:idx_end);
        T{i}  = table1.Temp1(idx_discharge_start:idx_end);
        Ts{i} = table1.TestTime(idx_discharge_start:idx_end); 
        table1 = table1(idx_end+1:end,:);
        i = i+1
    end
end
end

