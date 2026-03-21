load int_temp.mat

k = 1;
while true
    if ~isfield(sim_handler{k},"current_sol")
        break
    end
   Ah_proc3(k) = max(sim_handler{k}.original_data.Ah)*3600;
   Cap_proc3(k) = sim_handler{k}.current_sol.Q;
   cycle_3(k) = k*5;
   k = k+1;
end

load max_temp.mat
k = 1;
while true
    if ~isfield(sim_handler{k},"current_sol")
        break
    end
    Ah_proc2(k) = max(sim_handler{k}.original_data.Ah)*3600;
    Cap_proc2(k) = sim_handler{k}.current_sol.Q;
    cycle_2(k) = k*5;
    k = k+1;
end

load paings1-200.mat
k = 1;
while true
    if ~isfield(sim_handler{k},"current_sol")
        break
    end
    Ah_proc1(k) = max(sim_handler{k}.original_data.Ah)*3600;
    Cap_proc1(k) = sim_handler{k}.current_sol.Q;
    cycle_1(k) = k*5;
    k = k+1;
end

load baseline1-800.mat
k = 1;
while true
    if ~isfield(sim_handler{k},"current_sol")
        break
    end
    Ah_b(k) = max(sim_handler{k}.original_data.Ah)*3600;
    Cap_b(k) = sim_handler{k}.current_sol.Q;
    cycle_b(k) = k*10;
    k = k+1;
end
window = 10; 
Cap_proc1_f  = movmean(Cap_proc1,  window);
Cap_proc2_f  = movmean(Cap_proc2,  window);
Cap_proc3_f = movmean(Cap_proc3, window);
Cap_b_f = movmean(Cap_b, window);

figure()
hold on
plot(cycle_b,Ah_b)
plot(cycle_3,Ah_proc3)
plot(cycle_2,Ah_proc2)
plot(cycle_1,Ah_proc1)

figure()
hold on
plot(cycle_b,Ah_b - max(Ah_b))
plot(cycle_3,Ah_proc3 - max(Ah_proc3))
plot(cycle_2,Ah_proc2 - max(Ah_proc2))
plot(cycle_1,Ah_proc1 - max(Ah_proc1))

figure()
hold on
plot(cycle_b,Ah_b/Ah_b(1))
plot(cycle_3,Ah_proc3/Ah_proc3(1))
plot(cycle_2,Ah_proc2/Ah_proc2(1))
plot(cycle_1,Ah_proc1/Ah_proc1(1))

figure()
hold on
plot(cycle_b,Cap_b_f/max(Cap_b_f))
plot(cycle_3,Cap_proc3_f/max(Cap_proc3_f))
plot(cycle_2,Cap_proc2_f/max(Cap_proc2_f))
plot(cycle_1,Cap_proc1_f/max(Cap_proc1_f))