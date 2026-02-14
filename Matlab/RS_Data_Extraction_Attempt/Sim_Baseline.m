clear
load RS_Param_Retry.mat

k_start = find(abs(RS_01_baseline.TestTime - 14290) < 1, 1);
k_end = find(abs(RS_01_baseline.TestTime - 18024) < 1, 1);
RS_01_baseline_cycle = RS_01_baseline(k_start:k_end,:);


p.r1 = 0.045;
p.r0 = 0.074;
p.c = 800;
p.q = 1.54*60*60;
p.vu = ocv_curve_2(1);
p.vl = ocv_curve_2(0);
p.ocv = @ocv_curve;
R0 = p.r0;
R1 = p.r1;

%%
%tt = linspace(0,hr*60*60,150); 
%current_cc_discharge = C*Curr*ones(150,1);
current_cc_discharge = RS_01_baseline_cycle.Amps;
tt = RS_01_baseline_cycle.TestTime - RS_01_baseline_cycle.TestTime(1);
y = RS_01_baseline_cycle.Volts;
current_lut = @(t) interp1(tt, current_cc_discharge, t, 'linear', 'extrap');
[t_sim, y_sim] = ode45(@(t, y) dynamics(t, y, p, current_lut), [0 tt(end)], [0.06; 0]);
x1=y_sim(:,1);x2=y_sim(:,2);

voltage_model = ocv_curve_2(x1) + x2 + R0.*current_lut(t_sim);
y_og = interp1(tt, y, t_sim, 'linear', 'extrap');
figure();
plot(t_sim,voltage_model,t_sim,y_og)
