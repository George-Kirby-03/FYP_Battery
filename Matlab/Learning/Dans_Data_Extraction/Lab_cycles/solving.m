pwd
load('RS_Params.mat')

hr = 0.5; %%how long
C = 2.2; %%C_rate discharge
p.r1 = CROR1(end);
p.r0 = CROR1(2);
p.c = CROR1(1);
p.q = 1.53*60*60;
p.vu = polyval(ocv_curve,1);
p.vl = polyval(ocv_curve,0);
p.ocv = ocv_curve;


tt = linspace(0,hr*60*60,150);
current_cc_discharge = -C*1.5*ones(150,1);
current_lut = @(t) interp1(tt, current_cc_discharge, t, 'linear', 'extrap');


[t, y] = ode45(@(t, y) dynamics(t, y, p, current_lut), [0 tt(end)], [1; 0]);
x1=y(:,1);x2=y(:,2);
R0 = p.r0;
u2=current_lut(t);
voltage_model= polyval(ocv_curve,x1) + x2 + R0.*u2;


figure
plot(t,voltage_model,t,x1,t,x2)
hold on
