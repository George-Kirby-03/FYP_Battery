load MAX_TEMP_B2.mat

k = numel(sim_handler);

ends = 0;
idx = 0;

Ah_proc2 = [];
Cap_proc2 = [];
cycle_2 = [];
Sum_r2 = [];

for i = k:-1:1 
    if isfield(sim_handler{i}, "current_sol")
        idx = idx + 1;
        
        Ah_proc2(idx) = max(sim_handler{i}.original_data.Ah) * 3600;
        Cap_proc2(idx) = sim_handler{i}.current_sol.Q;
        cycle_2(idx) = i * 5;
        Sum_r2(idx) = sim_handler{i}.current_sol.R0 + sim_handler{i}.current_sol.R1;
        R0(idx) = sim_handler{i}.current_sol.R0;
        R1(idx) = sim_handler{i}.current_sol.R1;
        C(idx) = sim_handler{i}.current_sol.C;
        Cp(idx) = sim_handler{i}.current_sol.Cp;
        h(idx) = sim_handler{i}.current_sol.h;
        ends = ends + 1;
        if ends == 4
            break   
        end
    end
end

Cap_avg = mean(Ah_proc2)
R0_avg = mean(R0)
R1_avg = mean(R1) 
C_avg = mean(C)
Cp_avg = mean(Cp)
h_avg = mean(h)


