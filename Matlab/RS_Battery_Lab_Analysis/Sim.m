pwd
clear
close all
load('charac_01_s4.mat')
load('RS_Params.mat')
p.r1 = 0.05;
p.r0 = 0.07- p.r1;
p.c = 1500;
p.q = 1.53*60*60;
p.vu = polyval(ocv_curve_2,1);
p.vl = polyval(ocv_curve_2,0);
p.ocv = ocv_curve_2;
R0 = p.r0;
R1 = p.r1;
Curr = p.q/(60^2);

Cl = linspace(-4,-0.5,15)';
hrl = linspace(0.1,1.5,7)';
socl = ones(10,7);

op = ocv_curve;
f = @(x) polyval(op, x) - y(1);
init = fzero(f, 0.8);
%%
%tt = linspace(0,hr*60*60,150); 
%current_cc_discharge = C*Curr*ones(150,1);
current_cc_discharge = u1*1.5;
current_lut = @(t) interp1(tt, current_cc_discharge, t, 'linear', 'extrap');
[t_sim, y_sim] = ode45(@(t, y) US_dynamics(t, y, p, current_lut), [0 tt(end)], [init; 0; 0]);
x1=y_sim(:,1);x2=y_sim(:,2);

voltage_model = polyval(ocv_curve,x1) + x2 + R0.*current_lut(t_sim);
y_og = interp1(tt, y, t_sim, 'linear', 'extrap');
figure();
plot(t_sim,voltage_model,t_sim,y_og,t_sim,current_lut(t_sim)./10+y(1))


%% Simulate the 3C discharge to comapre with datasheet
figure();
current_cc_discharge = -1.5.*[0.1, 0.2, 0.5, 1, 2, 3 ];

for i=1:length(current_cc_discharge)
u2 = current_cc_discharge(i)*ones(150,1);
tt = linspace(0,12*60^2,150);
current_lut = @(t) interp1(tt, u2, t, 'linear', 'extrap');
[t_sim, y_sim] = ode45(@(t, y) dynamics(t, y, p, current_lut), [0 tt(end)], [1; 0; 0]);
x1=y_sim(:,1);x2=y_sim(:,2);
voltage_model = polyval(p.ocv,x1) + x2 + R0.*current_cc_discharge(i);
sim_time{i}    = t_sim;
cap{i}         = -t_sim .*current_cc_discharge(i)*1000/(60^2);
sim_voltage{i} = voltage_model;
plot(cap{i}, sim_voltage{i})
hold on
grid on
end
