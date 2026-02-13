load RS_Baseline_og_attia_normalised.mat
close all
load('RS_Params.mat')
Cycle10 = GK_RS_baseline_028(GK_RS_baseline_028.Cyc_ == 10 | GK_RS_baseline_028.Cyc_ == 11 ,:);
% Select the rows from (end - 599) up to the end
Cycle10 = Cycle10(end-800:end, :);
plot(Cycle10.TestTime,Cycle10.Volts,Cycle10.TestTime,Cycle10.Amps./2 + 3)

p.r1 = 0.05;
p.r0 = 0.07- p.r1;
p.c = 1500;
p.q = 1.53*60*60;
p.vu = polyval(ocv_curve_2,1);
%p.vl = polyval(ocv_curve_2,0);#
p.vl = 2.5;
p.ocv = ocv_curve_2;
R0 = p.r0;
R1 = p.r1;
Curr = p.q/(60^2); 
tt = Cycle10.TestTime - Cycle10.TestTime(1);
t = linspace(0,Cycle10.TestTime(end)-Cycle10.TestTime(1),1000);
init = 0.4;
current_cc_discharge = Cycle10.Amps;
current_lut = @(t) interp1(tt, current_cc_discharge, t, 'linear', 'extrap');
figure()
hold on
for i=0.98:0.005:1
[t_sim, y_sim] = ode45(@(t, y) US_dynamics(t, y, p, current_lut), [0 tt(end)], [i; 0; 0]);
x1=y_sim(:,1);x2=y_sim(:,2);

voltage_model = polyval(ocv_curve,x1) + x2 + R0.*current_lut(t_sim);
plot(t_sim,voltage_model)
%plot(t_sim,x1)
plot(Cycle10.TestTime - Cycle10.TestTime(1),Cycle10.Volts,'LineWidth',2)
end