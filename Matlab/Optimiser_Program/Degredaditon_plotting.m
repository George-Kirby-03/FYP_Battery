Paings_B_200_400 = readtable("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_03_proc4_0000 - 025 (2).csv");
Paings_A_200_400 = readtable("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_04_proc5_0000 - 026 (2).csv");
Min_Max_A_200_400 = readtable("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_05_proc6_0000 - 029 (2).csv");
Min_Max_B_200_400 = readtable("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_06_proc7_0000 - 030 (2).csv");
Min_Intg_A_200_400 = readtable("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_07_proc8_0000 - 031 (1).csv");
Min_Intg_B_200_400 = readtable("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_08_proc9_0000 - 032 (1).csv");

Paings_B_1_200 = readtable("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_03_proc1_0000 - 025 (3).csv");
Paings_A_1_200 = readtable("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_04_proc1_0000 - 026 (2).csv");
Min_Max_A_1_200 = readtable("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_05_proc2_0000 - 029 (3).csv");
Min_Max_B_1_200 = readtable("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_06_proc2_0000 - 030 (2).csv");
Min_Intg_A_1_200 = readtable("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_07_proc3_0000 - 031 (5).csv");
Min_Intg_B_1_200 = readtable("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_08_proc3_0000 - 032 (4).csv");

Baseline_A = readtable("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_01_baseline_0000 - 027 (4).csv");
Baseline_B = readtable("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Optimiser_Program\GK_RS15_02_baseline_0000 - 028 (2).csv");

Paings_B_200_400_peaks = findpeaks(Paings_B_200_400.Amp_hr);
Paings_A_200_400_peaks =  findpeaks(Paings_A_200_400.Amp_hr);
Min_Max_A_200_400_peaks = findpeaks(Min_Max_A_200_400.Amp_hr);
Min_Max_B_200_400_peaks =  findpeaks(Min_Max_B_200_400.Amp_hr);
Min_Intg_A_200_400_peaks = findpeaks(Min_Intg_A_200_400.Amp_hr);
Min_Intg_B_200_400_peaks =  findpeaks(Min_Intg_B_200_400.Amp_hr);

Paings_B_1_200_peaks = findpeaks(Paings_B_1_200.Amp_hr);
Paings_A_1_200_peaks =  findpeaks(Paings_A_1_200.Amp_hr);
Min_Max_A_1_200_peaks = findpeaks(Min_Max_A_1_200.Amp_hr);
Min_Max_B_1_200_peaks =  findpeaks(Min_Max_B_1_200.Amp_hr);
Min_Intg_A_1_200_peaks = findpeaks(Min_Intg_A_1_200.Amp_hr);
Min_Intg_B_1_200_peaks =  findpeaks(Min_Intg_B_1_200.Amp_hr);

Paings_B_200_400_peaks = [Paings_B_1_200_peaks(2:2:end); Paings_B_200_400_peaks(2:2:end)];
Paings_A_200_400_peaks =  [Paings_A_1_200_peaks(2:2:end); Paings_A_200_400_peaks(2:2:end)];
Min_Max_A_200_400_peaks = [Min_Max_A_1_200_peaks(2:2:end); Min_Max_A_200_400_peaks(2:2:end)];
Min_Max_B_200_400_peaks =  [Min_Max_B_1_200_peaks(2:2:end); Min_Max_B_200_400_peaks(2:2:end)];
Min_Intg_A_200_400_peaks = [Min_Intg_A_1_200_peaks(2:2:end); Min_Intg_A_200_400_peaks(2:2:end)];
Min_Intg_B_200_400_peaks =  [Min_Intg_B_1_200_peaks(2:2:end); Min_Intg_B_200_400_peaks(2:2:end)];

Baseline_A_peaks =  findpeaks(Baseline_A.Amp_hr);
Baseline_B_peaks =  findpeaks(Baseline_B.Amp_hr);
Baseline_A_peaks =  Baseline_A_peaks(2:2:end);
Baseline_B_peaks =  Baseline_B_peaks(2:2:end);

figure()
hold on
plot(Paings_B_200_400_peaks)
plot(Paings_A_200_400_peaks)
plot(Min_Max_A_200_400_peaks)
plot(Min_Max_B_200_400_peaks)
plot(Min_Intg_A_200_400_peaks)
plot(Min_Intg_B_200_400_peaks)


figure()
hold on

plot(Paings_B_200_400_peaks - Paings_B_200_400_peaks(1),'LineStyle','-.','LineWidth',2,'Color','b')
plot(Paings_A_200_400_peaks - Paings_A_200_400_peaks(1),'LineStyle','-','LineWidth',2,'Color','b')

plot(Min_Max_A_200_400_peaks - Min_Max_A_200_400_peaks(1),'LineStyle','-.','LineWidth',2,'Color','r')
plot(Min_Max_B_200_400_peaks - Min_Max_B_200_400_peaks(1),'LineStyle','-','LineWidth',2,'Color','r')

plot(Min_Intg_A_200_400_peaks - Min_Intg_A_200_400_peaks(1),'LineStyle','-.','LineWidth',2,'Color','g')
plot(Min_Intg_B_200_400_peaks - Min_Intg_B_200_400_peaks(1),'LineStyle','-','LineWidth',2,'Color','g')

plot(Baseline_A_peaks - Baseline_A_peaks(1),'LineStyle','-.','LineWidth',2,'Color','y')
plot(Baseline_B_peaks - Baseline_B_peaks(1),'LineStyle','-','LineWidth',2,'Color','y')

legend(["PaingA","PaingB","MinMaxA","MinMaxA","MinTA","MinTB","BaselineA","BaselineB"],'Interpreter','latex')
xline(200,'Label','Re-optimisation')
xline(248,'Label','Lab Pause')
grid on
xlabel("Cycle Count","FontSize",13,'Interpreter','latex')
ylabel("Capacity loss $(Ah)$","FontSize",13,'Interpreter','latex')

%%
figure()
hold on

plot(Paings_B_200_400_peaks - Paings_B_200_400_peaks(50),'LineStyle','-.','LineWidth',2,'Color','b')
plot(Paings_A_200_400_peaks - Paings_A_200_400_peaks(50),'LineStyle','-','LineWidth',2,'Color','b')

plot(Min_Max_A_200_400_peaks - Min_Max_A_200_400_peaks(50),'LineStyle','-.','LineWidth',2,'Color','r')
plot(Min_Max_B_200_400_peaks - Min_Max_B_200_400_peaks(50),'LineStyle','-','LineWidth',2,'Color','r')

plot(Min_Intg_A_200_400_peaks - Min_Intg_A_200_400_peaks(50),'LineStyle','-.','LineWidth',2,'Color','g')
plot(Min_Intg_B_200_400_peaks - Min_Intg_B_200_400_peaks(50),'LineStyle','-','LineWidth',2,'Color','g')

plot(Baseline_A_peaks - Baseline_A_peaks(50),'LineStyle','-.','LineWidth',2,'Color','y')
plot(Baseline_B_peaks - Baseline_B_peaks(50),'LineStyle','-','LineWidth',2,'Color','y')

legend(["PaingA","PaingB","MinMaxA","MinMaxA","MinTA","MinTB","BaselineA","BaselineB"],'Interpreter','latex')
xline(200,'Label','Re-optimisation')
xline(248,'Label','Lab Pause')
grid on
xlabel("Cycle Count","FontSize",13,'Interpreter','latex')
ylabel("Capacity loss $(Ah)$","FontSize",13,'Interpreter','latex')




%%
k = 1;
while true
    if ~isfield(sim_handler{k},"current_sol")
        break
    end
   Ah_proc3(k) = max(sim_handler{k}.original_data.Ah)*3600;
   Cap_proc3(k) = sim_handler{k}.current_sol.Q;
   cycle_3(k) = k*5;
   Sum_r3(k) = sim_handler{k}.current_sol.R0 + sim_handler{k}.current_sol.R1;
   k = k+1;
end

load paings1-200.mat
k = 1;
while true
    if ~isfield(sim_handler{k},"current_sol")
        break
    end
    Ah_proc2(k) = max(sim_handler{k}.original_data.Ah)*3600;
    Cap_proc2(k) = sim_handler{k}.current_sol.Q;
    cycle_2(k) = k*5;
    Sum_r2(k) = sim_handler{k}.current_sol.R0 + sim_handler{k}.current_sol.R1;
    k = k+1;
end
% 
% load paings1-200.mat
% k = 1;
% while true
%     if ~isfield(sim_handler{k},"current_sol")
%         break
%     end
%     Ah_proc1(k) = max(sim_handler{k}.original_data.Ah)*3600;
%     Cap_proc1(k) = sim_handler{k}.current_sol.Q;
%     cycle_1(k) = k*5;
%     Sum_r1(k) = sim_handler{k}.current_sol.R0 + sim_handler{k}.current_sol.R1;
%     k = k+1;
% end
% 
% load baseline1-800.mat
% k = 1;
% while true
%     if ~isfield(sim_handler{k},"current_sol")
%         break
%     end
%     Ah_b(k) = max(sim_handler{k}.original_data.Ah)*3600;
%     Cap_b(k) = sim_handler{k}.current_sol.Q;
%     Sum_rb(k) = sim_handler{k}.current_sol.R0 + sim_handler{k}.current_sol.R1;
%     cycle_b(k) = k*10;
%     k = k+1;
% end
window = 10; 
%Cap_proc1_f  = movmean(Cap_proc1,  window);
Cap_proc2_f  = movmean(Cap_proc2,  window);
 Cap_proc3_f = movmean(Cap_proc3, window);
% Cap_b_f = movmean(Cap_b, window);


figure()
hold on
% plot(cycle_b,Ah_b)
% plot(cycle_3,Ah_proc3)
plot(cycle_2,Ah_proc2)
plot(cycle_3,Ah_proc3)
plot(cycle_2,Cap_proc2_f)
plot(cycle_3,Cap_proc3_f)
legend("B1","B2","B1_Q","B2_Q")
% figure()
% hold on
% plot(cycle_b,Ah_b - max(Ah_b))
% plot(cycle_3,Ah_proc3 - max(Ah_proc3))
% plot(cycle_2,Ah_proc2 - max(Ah_proc2))
% plot(cycle_1,Ah_proc1 - max(Ah_proc1))
% 
% figure()
% hold on
% plot(cycle_b,Ah_b/Ah_b(1))
% plot(cycle_3,Ah_proc3/Ah_proc3(1))
% plot(cycle_2,Ah_proc2/Ah_proc2(1))
% plot(cycle_1,Ah_proc1/Ah_proc1(1))
% 
% 
% figure()
% hold on
% plot(cycle_b,Cap_b_f/max(Cap_b_f))
% plot(cycle_3,Cap_proc3_f/max(Cap_proc3_f))
% plot(cycle_2,Cap_proc2_f/max(Cap_proc2_f))
% plot(cycle_1,Cap_proc1_f/max(Cap_proc1_f))
% 
% figure()
% hold on
% plot(cycle_b,Ah_b/max(Ah_b))
% plot(cycle_3,Ah_proc3/max(Ah_proc3))
% plot(cycle_2,Ah_proc2/max(Ah_proc2))
% plot(cycle_1,Ah_proc1/max(Ah_proc1))
% 
% figure()
% hold on
% plot(cycle_b,Sum_rb/max(Sum_rb))
% plot(cycle_3,Sum_r3/max(Sum_r3))
% plot(cycle_2,Sum_r2/max(Sum_r2))
% plot(cycle_1,Sum_r1/max(Sum_r1))
% 
% figure()
% hold on
% plot(cycle_b,Sum_rb)
% plot(cycle_3,Sum_r3)
% plot(cycle_2,Sum_r2)
% plot(cycle_1,Sum_r1)