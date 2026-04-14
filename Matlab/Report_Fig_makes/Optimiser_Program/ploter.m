%load int_temp.mat
load baseline1-800.mat
%load paings1-200.mat

for k = 1:88
   Qs(k) =  sim_handler{k}.current_sol.Q;
   R0s(k) =  sim_handler{k}.current_sol.R0;
   R1s(k) =  sim_handler{k}.current_sol.R1;
   Cs(k) =  sim_handler{k}.current_sol.C;
   Cps(k) =  sim_handler{k}.current_sol.Cp;
   Hs(k) =  sim_handler{k}.current_sol.h;
   Ah(k) = max(sim_handler{k}.original_data.Ah)*3600;
   Sum_res(k) = R0s(k) + R1s(k);
   cycle(k) = k*5;

end
% Qs =Qs/mean(Qs);
% R0s =R0s/mean(R0s);
% R1s =R1s/mean(R1s);
% Cs =Cs/mean(Cs);
window = 6; 
Qs_f  = movmean(Qs,  window);
R0s_f = movmean(R0s, window);
R1s_f = movmean(R1s, window);
Cs_f  = movmean(Cs,  window);
Cps_f  = movmean(Cps,  window);
Hs_f  = movmean(Hs,  window);


tiledlayout


ax1 = nexttile(1);
plot(ax1, cycle, Qs, '--', cycle, Qs_f, 'LineWidth', 1.5)
hold(ax1, 'on')
plot(ax1, cycle, Ah)
grid(ax1, 'on')
xlabel(ax1, "\textbf{Cycle}", "Interpreter", "latex", "FontSize", 15)
ylabel(ax1, "\textbf{Q}", "Interpreter", "latex", "FontSize", 15)
title(ax1, "\textbf{Protocol 1 (Paings degredation model)}", "Interpreter", "latex", "FontSize", 19)
legend(["Q raw", "Q filt", "Q_{actual}"], "FontSize", 11, "FontWeight", "normal", "Interpreter", "latex", "Position", [0.8070 0.3919 0.0898, 0.2355])


ax2 = nexttile(2);
title("\textbf{Protocol 1 (Paings degredation model)}", "Interpreter", "latex", "FontSize", 19)
xlabel("\textbf{Cycle}", "Interpreter", "latex", "FontSize", 15, "FontWeight", "bold")
ylabel("\textbf{Ohm}", "Interpreter", "latex", "FontSize", 15, "LineWidth", 0.5)
hold on
grid(ax2, 'on')
plot(cycle,R0s,'--',cycle,R0s_f,'LineWidth',1.5)
plot(cycle,R1s,'--',cycle,R1s_f,'LineWidth',1.5)
xlim([0 873])
ylim([0.000 0.168])
legend(["R0 raw", "R0 filt", "R1 raw", "R1 filt"], "FontSize", 11, "FontWeight", "normal", "Interpreter", "latex", "Position", [0.8070 0.3919 0.0898, 0.2355])
hLegend = findobj(gcf,"Type","legend");
hLegend(1).String = {"R0 raw","R0 filt","R1 raw","R1 filt"};
Qactual = findobj(gcf,"DisplayName","Q_{actual}");
Qactual.LineWidth = 3;
Qfilt = findobj(gcf,"DisplayName","Q filt");
Qfilt.LineWidth = 3;
R0filt = findobj(gcf,"DisplayName","R0 filt");
R0filt.LineWidth = 3;
R1filt = findobj(gcf,"DisplayName","R1 filt");
R1filt.LineWidth = 3;

figure 
plot(cycle,Sum_res)