pwd
clear
load('RS_Params.mat')

% p.r1 = CROR1(end);
% p.r0 = CROR1(2);
% p.c = CROR1(1);
% p.r1 = 0.03;
% p.r0 = 0.035;
% p.c = 120;
% p.r1 = 0.07;
% p.r0 = 0.163 - p.r1;
p.r1 = 0.07;
p.r0 = 0.163 - p.r1;
p.c = 289;
p.q = 1.53*60*60;

p.ocv = ocv_curve;
p.vu = polyval(p.ocv,1);
p.vl = polyval(p.ocv,0);
R0 = p.r0;
R1 = p.r1;
Curr = p.q/(60^2);

Cl = linspace(-4,-0.5,15)';
hrl = linspace(0.1,1.5,7)';
socl = ones(10,7);

%%
count = 0;
for i=1:length(Cl)
    for j=1:length(hrl)
C = Cl(i); hr = hrl(j);
tt = linspace(0,hr*60*60,150);
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
voltage_model = polyval(p.ocv,x1) + x2 + R0.*Curr*C;
voltage_model_ccd = voltage_model(vlim_sim_idx);
settle_voltage = -Curr*(p.r1 + p.r0) + voltage_model_ccd;
hold on

count = count + 1;
fprintf(['For Discharge at %.1fC for %.2f hours: \n' ...
    'Drainage SOC is %.2f%% \n' ...
    'Settling time is %.2fs \n' ...
    'Settling voltage is %.3fV \n'],C,hr,discharge_soc*100, settle_time, settle_voltage);
    end
    plot(t_sim,voltage_model,t_sim,x1)
    count = count + 1;
end
fprintf('%d sims ran\n', count)
hold off
%%

%% Map
colormap default
heatmap(hrl,Cl,socl)

%% Now, charge CC, upto the point V_ulim is reached, this is when CV takes over
hr = 4; %%how long charge max

Cl = linspace(0.4,4,15)'; %%CC_rate charge
cc_times = ones(length(Cl),1);
cv_times = ones(length(Cl),1);
tt = linspace(0,hr*60*60,150);

for i=1:length(Cl)
C = Cl(i);
current_cc_charge = C*Curr*ones(150,1);
current_lut = @(t) interp1(tt, current_cc_charge, t, 'linear', 'extrap');
[t_sim, y] = ode15s(@(t, y) dynamics(t, y, p, current_lut), [0 tt(end)], [0; 0; 0]);
x1=y(:,1);x2=y(:,2); %If Vlim is reached, this soc is not reliable
vlim_sim_idx = find(y(:,3) > 0, 1, 'first');
socu_sim_idx = find(y(:,1) >= 0.995, 1, 'first');
fprintf('##### Current loop (cc rate of %.1f): \n',C)
if isempty(vlim_sim_idx)
     fprintf('Charge time not reached, max SoC: %.2f\n',x1(end,1))
     cc_times(i) = tt(end);
     cv_times(i) = 0;
elseif (~isempty(vlim_sim_idx) && (x1(vlim_sim_idx) < 0.96))  % && (~isempty(socu_sim_idx) && (vlim_sim_idx < socu_sim_idx))) %If vlim is reached before SoC, its clipped and needs CV
cc_times(i) = t_sim(vlim_sim_idx);
%voltage_model = polyval(ocv_curve,x1) + x2 + R0.*C*Curr;
fprintf('Time for CC: %.2f\n',cc_times(i)/60^2)
fprintf('Running CV stage since full SoC not reached before cutoff voltage, (reached %.3f SoC)\n',x1(vlim_sim_idx))
[t_sim, y] = ode15s(@(t, y) CV_dynamics(t, y, p), [0 tt(end)], [x1(vlim_sim_idx); x2(vlim_sim_idx); 0]);
x1=y(:,1);x2=y(:,2);
% current = diff(y(:,1).*p.q) ./ diff(t_sim);    
% current = [current;0];
% plot(t_sim,current)
%fprintf('Last SoC: %.5f, sim time: %.2f \n',x1(end),t_sim(end));
socu_sim_idx = find(y(:,1) > 0.995, 1, 'first');
fprintf('Time for CV: %.2fh \n',t_sim(socu_sim_idx)/60^2);
cv_times(i) = t_sim(socu_sim_idx);
fprintf('Time to full-charge (~0.99): %.3fh \n', (cv_times(i)+cc_times(i))./60^2)
elseif ~isempty(vlim_sim_idx)
    cc_times(i) = t_sim(vlim_sim_idx);
    cv_times(i) = 0;
    fprintf('Charged fully with CV alone (~0.96SoC) \n')
end
fprintf('##### \n')
end



%%

    
grid on
plot(Cl,cc_times,Cl,cv_times,Cl,cc_times+cv_times)
legend(["CC Time", "CV Time", "Total Time"], "Position", [0.8148 0.8298 0.0684, 0.0614]);
title("Charging Times with CC & CV (Lab Properties Used)");
xlabel("C Current for CC");
ylabel("Charge Duration (S)");
hAxes = findobj(gcf,"Type","axes");
hAxes.LineWidth = 0.5000;
hAxes.GridLineWidthMode = "auto";
TotalTime = findobj(gcf,"DisplayName","Total Time");
TotalTime.LineWidth = 4.5000;
CCTime = findobj(gcf,"DisplayName","CC Time");
CCTime.LineWidth = 2;
CCTime.LineStyle = ":";
CVTime = findobj(gcf,"DisplayName","CV Time");
CVTime.LineWidth = 2;
CVTime.LineStyle = "--";

%%

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
voltage_model = polyval(p.ocv,x1) + x2 + R0.*current;