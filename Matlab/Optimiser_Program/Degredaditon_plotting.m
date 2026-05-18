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


cycles_1 = 50:200;
p = polyfit(cycles_1, Paings_B_200_400_peaks(50:200), 1);
average_1_grad(1) = p(1);

p = polyfit(cycles_1, Paings_A_200_400_peaks(50:200), 1);
average_1_grad(2) = p(1);

p = polyfit(cycles_1, Min_Max_A_200_400_peaks(50:200), 1);
average_1_grad(3) = p(1);

p = polyfit(cycles_1, Min_Max_B_200_400_peaks(50:200), 1);
average_1_grad(4) = p(1);

p = polyfit(cycles_1, Min_Intg_A_200_400_peaks(50:200), 1);
average_1_grad(5) = p(1);

p = polyfit(cycles_1, Min_Intg_B_200_400_peaks(50:200), 1);
average_1_grad(6) = p(1);

cycles_2 = 1:(length(Paings_B_200_400_peaks)-249);
p = polyfit(cycles_2, Paings_B_200_400_peaks(250:end), 1);
average_2_grad(1) = p(1);

cycles_2 = 1:(length(Paings_A_200_400_peaks)-249);
p = polyfit(cycles_2, Paings_A_200_400_peaks(250:end), 1);
average_2_grad(2) = p(1);

cycles_2 = 1:(length(Min_Max_A_200_400_peaks)-249);
p = polyfit(cycles_2, Min_Max_A_200_400_peaks(250:end), 1);
average_2_grad(3) = p(1);

cycles_2 = 1:(length(Min_Max_B_200_400_peaks)-249);
p = polyfit(cycles_2, Min_Max_B_200_400_peaks(250:end), 1);
average_2_grad(4) = p(1);

cycles_2 = 1:(length(Min_Intg_A_200_400_peaks)-249);
p = polyfit(cycles_2, Min_Intg_A_200_400_peaks(250:end), 1);
average_2_grad(5) = p(1);

cycles_2 = 1:(length(Min_Intg_B_200_400_peaks)-249);
p = polyfit(cycles_2, Min_Intg_B_200_400_peaks(250:end), 1);
average_2_grad(6) = p(1);



figure
y = [avg_over_potential_baseline max(over_potential_baseline) ; 
    avg_over_potential_minimisetemp max(over_potential_minimisetemp) ; 
    avg_over_potential_minimisetempmax max(over_potential_minimisetempmax)
    avg_over_potential_minimisepang max(over_potential_minimisepang)];
bar(x,y)
ax = gca;
ax.XAxis.FontSize = 15;
ax.YAxis.FontSize = 15;
set(gca, 'xticklabel', x, 'TickLabelInterpreter', 'latex');
lb = legend('\textbf{Averaged}', '\textbf{Maximum}',"FontWeight","bold");
set(lb, 'Interpreter', 'latex','FontSize', 12);
title('\textbf{Overpotential Voltage}', ...
       'interpreter','latex','fontsize',f_size)



% 
% figure()
% hold on
% 
% plot(Paings_A_200_400_peaks - Paings_A_200_400_peaks(1),'LineStyle','-.','LineWidth',2,'Color','b')
% plot(Paings_B_200_400_peaks - Paings_B_200_400_peaks(1),'LineStyle','-','LineWidth',2,'Color','b')
% 
% plot(Min_Max_A_200_400_peaks - Min_Max_A_200_400_peaks(1),'LineStyle','-.','LineWidth',2,'Color','r')
% plot(Min_Max_B_200_400_peaks - Min_Max_B_200_400_peaks(1),'LineStyle','-','LineWidth',2,'Color','r')
% 
% plot(Min_Intg_A_200_400_peaks - Min_Intg_A_200_400_peaks(1),'LineStyle','-.','LineWidth',2,'Color','g')
% plot(Min_Intg_B_200_400_peaks - Min_Intg_B_200_400_peaks(1),'LineStyle','-','LineWidth',2,'Color','g')
% 
% plot(Baseline_A_peaks - Baseline_A_peaks(1),'LineStyle','-.','LineWidth',2,'Color','y')
% plot(Baseline_B_peaks - Baseline_B_peaks(1),'LineStyle','-','LineWidth',2,'Color','y')
% 
% legend(["PaingA","PaingB","MinMaxTA","MinMaxTA","MinTA","MinTB","BaselineA","BaselineB"],'Interpreter','latex')
% xline(200,'Label','Re-optimisation')
% xline(248,'Label','Lab Pause')
% grid on
% xlabel("Cycle Count","FontSize",13,'Interpreter','latex')
% ylabel("Capacity loss $(Ah)$","FontSize",13,'Interpreter','latex')

%%
figure()
hold on

plot(Paings_A_200_400_peaks - Paings_A_200_400_peaks(50),'LineStyle','-.','LineWidth',2,'Color','b')
plot(Paings_B_200_400_peaks - Paings_B_200_400_peaks(50),'LineStyle','-','LineWidth',2,'Color','b')

plot(Min_Max_A_200_400_peaks - Min_Max_A_200_400_peaks(50),'LineStyle','-.','LineWidth',2,'Color','r')
plot(Min_Max_B_200_400_peaks - Min_Max_B_200_400_peaks(50),'LineStyle','-','LineWidth',2,'Color','r')

plot(Min_Intg_A_200_400_peaks - Min_Intg_A_200_400_peaks(50),'LineStyle','-.','LineWidth',2,'Color','g')
plot(Min_Intg_B_200_400_peaks - Min_Intg_B_200_400_peaks(50),'LineStyle','-','LineWidth',2,'Color','g')

plot(Baseline_A_peaks - Baseline_A_peaks(50),'LineStyle','-.','LineWidth',2,'Color','y')
plot(Baseline_B_peaks - Baseline_B_peaks(50),'LineStyle','-','LineWidth',2,'Color','y')

legend(["QLossA","QLossB","MinMaxTA","MinMaxTB","MinTA","MinTB","BaselineA","BaselineB"],'Interpreter','latex')
xline(200,'Label','Re-optimisation',"FontSize",13,'Interpreter','latex')
xline(248,'Label','Lab Pause',"FontSize",13,'Interpreter','latex')
grid on
xlabel("Cycle Count","FontSize",13,'Interpreter','latex')
ylabel("Capacity loss $(Ah)$","FontSize",13,'Interpreter','latex')



%%



files = ["Baseline_A_1_1000.mat","Baseline_B_1_1000.mat","Paings_A_1_200.mat","Paings_B_1_200.mat", ...
    "Min_Max_A_1_200.mat","Min_Max_B_1_200.mat","Min_Intg_A_1_200.mat","Min_Intg_B_1_200.mat", ...
    "Paings_A_200_400_complete.mat","Paings_B_200_400_complete.mat","Min_Max_B_200_400_complete", ...
    "Min_Intg_A_200_400_complete.mat","Min_Intg_B_200_400_complete.mat"];

num_files = length(files);
Ah_proc  = cell(num_files, 1);
Cap_proc = cell(num_files, 1);
mCp       = cell(num_files, 1);
hA        = cell(num_files, 1);
cycle_count   = cell(num_files, 1);
Sum_r    = cell(num_files, 1);


for j = 1:length(files)
    load(files(j))
    k=1;
while true
    if ~isfield(sim_handler{k},"current_sol") || sim_handler{k}.current_sol.R1 == 0
        break
    end
   Ah_proc{j}(k) = max(sim_handler{k}.original_data.Ah)*3600;
   Cap_proc{j}(k) = sim_handler{k}.current_sol.Q;
   mCp{j}(k) = sim_handler{k}.current_sol.Cp;
   hA{j}(k) = sim_handler{k}.current_sol.h;
   cycle_count{j}(k) = k*5;
   Sum_r{j}(k) = sim_handler{k}.current_sol.R0 + sim_handler{k}.current_sol.R1;
   k = k+1;
end
    
end
%%


% figure()
% hold on
% 
% plot(cycle_count{1},Sum_r{1},'LineStyle','-.','LineWidth',2,'Color','b')
% plot(cycle_count{2},Sum_r{2},'LineStyle','-','LineWidth',2,'Color','b')
% 
% plot([cycle_count{3},cycle_count{3}(end) + cycle_count{9}],[Sum_r{3},Sum_r{9}],'LineStyle','-.','LineWidth',2,'Color','r')
% plot([cycle_count{4},cycle_count{4}(end) + cycle_count{10}],[Sum_r{4},Sum_r{10}],'LineStyle','-','LineWidth',2,'Color','r')
% 
% plot(cycle_count{5},Sum_r{5},'LineStyle','-.','LineWidth',2,'Color','g')
% plot([cycle_count{6},cycle_count{6}(end)+ cycle_count{11}],[Sum_r{6},Sum_r{11}],'LineStyle','-','LineWidth',2,'Color','g')
% 
% plot([cycle_count{7},cycle_count{7}(end) + cycle_count{12}],[Sum_r{7},Sum_r{12}],'LineStyle','-.','LineWidth',2,'Color','y')
% plot([cycle_count{8},cycle_count{8}(end) + cycle_count{13}],[Sum_r{8},Sum_r{13}],'-','LineWidth',2,'Color','y')
% 
% legend(["PaingA","PaingB","MinMaxA","MinMaxA","MinTA","MinTB","BaselineA","BaselineB"],'Interpreter','latex')
% xline(200,'Label','Re-optimisation',"FontSize",13,'Interpreter','latex')
% xline(248,'Label','Lab Pause',"FontSize",13,'Interpreter','latex')
% grid on
% xlabel("Cycle Count","FontSize",13,'Interpreter','latex')
% ylabel("Resistance $(\Omega)$","FontSize",13,'Interpreter','latex')
% 
% 



%%


figure()
hold on

plot(cycle_count{1},movmean(Sum_r{1},3),'LineStyle','-.','LineWidth',2,'Color','b')
plot(cycle_count{2},movmean(Sum_r{2},3),'LineStyle','-','LineWidth',2,'Color','b')

plot([cycle_count{3},cycle_count{3}(end) + cycle_count{9}],movmean([Sum_r{3},Sum_r{9}],3),'LineStyle','-.','LineWidth',2,'Color','r')
plot([cycle_count{4},cycle_count{4}(end) + cycle_count{10}],movmean([Sum_r{4},Sum_r{10}],3),'LineStyle','-','LineWidth',2,'Color','r')

plot(cycle_count{5},Sum_r{5},'LineStyle','-.','LineWidth',2,'Color','g')
plot([cycle_count{6},cycle_count{6}(end)+ cycle_count{11}],movmean([Sum_r{6},Sum_r{11}],3),'LineStyle','-','LineWidth',2,'Color','g')

plot([cycle_count{7},cycle_count{7}(end) + cycle_count{12}],movmean([Sum_r{7},Sum_r{12}],3),'LineStyle','-.','LineWidth',2,'Color','y')
plot([cycle_count{8},cycle_count{8}(end) + cycle_count{13}],movmean([Sum_r{8},Sum_r{13}],3),'-','LineWidth',2,'Color','y')

xline(200,'Label','Re-optimisation',"FontSize",13,'Interpreter','latex')
xline(248,'Label','Lab Pause',"FontSize",13,'Interpreter','latex')
grid on
xlabel("Cycle Count","FontSize",13,'Interpreter','latex')
ylabel("Capacity loss $(Ah)$","FontSize",13,'Interpreter','latex')
xlim([6 451])
ylim([0.0857 0.1057])
legend(["BaselineA", "BaselineB", "QLossA", "QLossB", "MinMaxTA", "MinMaxTB","MinTA", "MinTB"], "FontSize", 11, "Interpreter", "latex", "Position", [0.8078 0.6363 0.0869, 0.2816])






% %%
% load paings1-200.mat
% k = 1;
% while true
%     if ~isfield(sim_handler{k},"current_sol")
%         break
%     end
%     Ah_proc2(k) = max(sim_handler{k}.original_data.Ah)*3600;
%     Cap_proc2(k) = sim_handler{k}.current_sol.Q;
%     cycle_2(k) = k*5;
%     Sum_r2(k) = sim_handler{k}.current_sol.R0 + sim_handler{k}.current_sol.R1;
%     k = k+1;
% end
% 
% load paings1-200.mat
% % k = 1;
% % while true
% %     if ~isfield(sim_handler{k},"current_sol")
% %         break
% %     end
% %     Ah_proc1(k) = max(sim_handler{k}.original_data.Ah)*3600;
% %     Cap_proc1(k) = sim_handler{k}.current_sol.Q;
% %     cycle_1(k) = k*5;
% %     Sum_r1(k) = sim_handler{k}.current_sol.R0 + sim_handler{k}.current_sol.R1;
% %     k = k+1;
% % end
% % 
% % load baseline1-800.mat
% % k = 1;
% % while true
% %     if ~isfield(sim_handler{k},"current_sol")
% %         break
% %     end
% %     Ah_b(k) = max(sim_handler{k}.original_data.Ah)*3600;
% %     Cap_b(k) = sim_handler{k}.current_sol.Q;
% %     Sum_rb(k) = sim_handler{k}.current_sol.R0 + sim_handler{k}.current_sol.R1;
% %     cycle_b(k) = k*10;
% %     k = k+1;
% % end
% window = 10; 
% %Cap_proc1_f  = movmean(Cap_proc1,  window);
% Cap_proc2_f  = movmean(Cap_proc2,  window);
%  Cap_proc3_f = movmean(Cap_proc3, window);
% % Cap_b_f = movmean(Cap_b, window);
% 
% 
% figure()
% hold on
% % plot(cycle_b,Ah_b)
% % plot(cycle_3,Ah_proc3)
% plot(cycle_2,Ah_proc2)
% plot(cycle_3,Ah_proc3)
% plot(cycle_2,Cap_proc2_f)
% plot(cycle_3,Cap_proc3_f)
% legend("B1","B2","B1_Q","B2_Q")
% % figure()
% % hold on
% % plot(cycle_b,Ah_b - max(Ah_b))
% % plot(cycle_3,Ah_proc3 - max(Ah_proc3))
% % plot(cycle_2,Ah_proc2 - max(Ah_proc2))
% % plot(cycle_1,Ah_proc1 - max(Ah_proc1))
% % 
% % figure()
% % hold on
% % plot(cycle_b,Ah_b/Ah_b(1))
% % plot(cycle_3,Ah_proc3/Ah_proc3(1))
% % plot(cycle_2,Ah_proc2/Ah_proc2(1))
% % plot(cycle_1,Ah_proc1/Ah_proc1(1))
% % 
% % 
% % figure()
% % hold on
% % plot(cycle_b,Cap_b_f/max(Cap_b_f))
% % plot(cycle_3,Cap_proc3_f/max(Cap_proc3_f))
% % plot(cycle_2,Cap_proc2_f/max(Cap_proc2_f))
% % plot(cycle_1,Cap_proc1_f/max(Cap_proc1_f))
% % 
% % figure()
% % hold on
% % plot(cycle_b,Ah_b/max(Ah_b))
% % plot(cycle_3,Ah_proc3/max(Ah_proc3))
% % plot(cycle_2,Ah_proc2/max(Ah_proc2))
% % plot(cycle_1,Ah_proc1/max(Ah_proc1))
% % 
% % figure()
% % hold on
% % plot(cycle_b,Sum_rb/max(Sum_rb))
% % plot(cycle_3,Sum_r3/max(Sum_r3))
% % plot(cycle_2,Sum_r2/max(Sum_r2))
% % plot(cycle_1,Sum_r1/max(Sum_r1))
% % 
% % figure()
% % hold on
% % plot(cycle_b,Sum_rb)
% % plot(cycle_3,Sum_r3)
% % plot(cycle_2,Sum_r2)
% % plot(cycle_1,Sum_r1)