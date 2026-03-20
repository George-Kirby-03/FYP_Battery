load sims.mat


for k = 1:76
   Qs(k) =  sim_handler{k}.current_sol.Q;
   R0s(k) =  sim_handler{k}.current_sol.R0;
   R1s(k) =  sim_handler{k}.current_sol.R1;
   Cs(k) =  sim_handler{k}.current_sol.C;
   Cps(k) =  sim_handler{k}.current_sol.Cp;
   Hs(k) =  sim_handler{k}.current_sol.h;
   cycle(k) = k*10;
end
% Qs =Qs/mean(Qs);
% R0s =R0s/mean(R0s);
% R1s =R1s/mean(R1s);
% Cs =Cs/mean(Cs);
window = 5; % try 3–10 depending on smoothing

Qs_f  = movmean(Qs,  window);
R0s_f = movmean(R0s, window);
R1s_f = movmean(R1s, window);
Cs_f  = movmean(Cs,  window);
Cps_f  = movmean(Cs,  window);
Hs_f  = movmean(Cs,  window);

plot(cycle,Qs,'--',cycle,Qs_f,'LineWidth',1.5)
hold on
plot(cycle,R0s,'--',cycle,R0s_f,'LineWidth',1.5)
plot(cycle,R1s,'--',cycle,R1s_f,'LineWidth',1.5)
plot(cycle,Cs,'--',cycle,Cs_f,'LineWidth',1.5)
plot(cycle,Cps,'--',cycle,Cps_f,'LineWidth',1.5)
plot(cycle,Hs,'--',cycle,Hs_f,'LineWidth',1.5)
hold off

legend('Q raw','Q filt','R0 raw','R0 filt','R1 raw','R1 filt','C raw','C filt')