function [V,I,T,Ts] = get_cycle(csvfile,cycle_no)
%GET_CYCLE undefined
%   undefined
arguments (Input)
    csvfile string
    cycle_no (1,1) double = 1
end

arguments (Output)
    V
    I
    T
    Ts
end

table1 = readtable(csvfile);

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
idx_cycle_end = idx_cycle_end + idx_next_12+idx_last+idx_cycle_start;

V  = table1.Volts(idx_cycle_start:idx_cycle_end);
I  = table1.Amps(idx_cycle_start:idx_cycle_end);
T  = table1.Temp1(idx_cycle_start:idx_cycle_end);
Ts = table1.TestTime(idx_cycle_start:idx_cycle_end);

end

