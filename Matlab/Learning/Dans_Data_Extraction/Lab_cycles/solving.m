pwd
clear
load('RS_Params.mat')

p.r1 = CROR1(end);
p.r0 = CROR1(2);
p.c = CROR1(1);
p.q = 1.53*60*60;
p.vu = polyval(ocv_curve,1);
p.vl = polyval(ocv_curve,0);
p.ocv = ocv_curve;
R0 = p.r0;
R1 = p.r1;
Curr = p.q/(60^2);

Cl = linspace(-4,-0.5,15)';
hrl = linspace(0.1,1.5,7)';
socl = ones(10,7);

%%
tt = linspace(0,hr*60*60,150);
for i=1:length(Cl)
    for j=1:length(hrl)
C = Cl(i); hr = hrl(j);
current_cc_discharge = C*Curr*ones(150,1);
current_lut = @(t) interp1(tt, current_cc_discharge, t, 'linear', 'extrap');
[t_sim, y] = ode45(@(t, y) dynamics(t, y, p, current_lut), [0 tt(end)], [1; 0; 0]);
x1=y(:,1);x2=y(:,2);
vlim_sim_idx = find(y(:,3) == 0, 1, 'last');   % Hack to find when voltage limit occurs exactly
... this was needed, since the limit for stopping current in the dynamics was based off the terminal
... voltage, caused effectivley a cv discharge, so once triggered, this state would begin integrating
... so when state did not equal 0, deemed the cuttof point
discharge_soc = y(vlim_sim_idx,1);
socl(i,j) = discharge_soc;
settle_time = 5*p.c.*p.r1;
voltage_model = polyval(ocv_curve,x1) + x2 + R0.*Curr*C;
voltage_model_ccd = voltage_model(vlim_sim_idx);
settle_voltage = -Curr*(p.r1 + p.r0) + voltage_model_ccd;
fprintf(['For Discharge at %.1fC for %.2f hours: \n' ...
    'Drainage SOC is %.2f%% \n' ...
    'Settling time is %.2fs \n' ...
    'Settling voltage is %.3fV \n'],C,hr,discharge_soc*100, settle_time, settle_voltage);
    end
end
%% Map
colormap default
heatmap(hrl,Cl,socl)
%% Charging simulation

hr = 8; %%how long charge max


Cl = linspace(0.2,2,1)'; %%CC_rate charge
Cl = 0.2;
cc_times = ones(length(Cl),1);
cv_times = ones(length(Cl),1);
tt = linspace(0,hr*60*60,150);

for i=1:length(Cl)
C = Cl(i);
current_cc_charge = C*Curr*ones(150,1);
current_lut = @(t) interp1(tt, current_cc_charge, t, 'linear', 'extrap');
[t_sim, y] = ode45(@(t, y) dynamics(t, y, p, current_lut), [0 tt(end)], [0; 0; 0]);
x1=y(:,1);x2=y(:,2);
socu_sim_idx = find(y(:,1) <= 0.985, 1, 'last');
vlim_sim_idx = find(y(:,3) <= 0, 1, 'last');
if isempty(vlim_sim_idx)
fprintf(['For Discharge at %.1fC: \n' ...
    'Time to full-charge: %.1fh \n' ...
    'INSTANT CV limit \n'],C,t_sim(socu_sim_idx)/60^2);
cc_times(i) = 0;
cv_times(i) = t_sim(socu_sim_idx);
else
fprintf(['For Discharge at %.1fC: \n' ...
    'Time to full-charge: %.1fh \n' ...
    'CV time reached at: %.1fh \n'],C,t_sim(socu_sim_idx)/60^2,t_sim(vlim_sim_idx)/60^2);
cc_times(i) = t_sim(vlim_sim_idx);
cv_times(i) = t_sim(socu_sim_idx) - cc_times(i);
end
end
                               
voltage_model = polyval(ocv_curve,x1) + x2 + R0.*Curr*C;


plot(t_sim,voltage_model)


%% 
hr = 1; %%how long charge max


Cl = linspace(0.2,2,1)'; %%CC_rate charge
Cl = 2;
cc_times = ones(length(Cl),1);
cv_times = ones(length(Cl),1);
tt = linspace(0,hr*60*60,150);

for i=1:length(Cl)
[t_sim, y] = ode45(@(t, y) CV_dynamics(t, y, p), [0 tt(end)], [0.3; 0.2; 0]);
x1=y(:,1);x2=y(:,2);
socu_sim_idx = find(y(:,1) <= 0.985, 1, 'last');
vlim_sim_idx = find(y(:,3) <= 0, 1, 'last');
if isempty(vlim_sim_idx)
fprintf(['For Discharge at %.1fC: \n' ...
    'Time to full-charge: %.1fh \n' ...
    'INSTANT CV limit \n'],C,t_sim(socu_sim_idx)/60^2);
cc_times(i) = 0;
cv_times(i) = t_sim(socu_sim_idx);
else
fprintf(['For Discharge at %.1fC: \n' ...
    'Time to full-charge: %.1fh \n' ...
    'CV time reached at: %.1fh \n'],C,t_sim(socu_sim_idx)/60^2,t_sim(vlim_sim_idx)/60^2);
cc_times(i) = t_sim(vlim_sim_idx);
cv_times(i) = t_sim(socu_sim_idx) - cc_times(i);
end
end
current = diff(y(:,1).*p.q) ./ diff(t_sim);    
current = [current;0];
voltage_model = polyval(ocv_curve,x1) + x2 + R0.*current;