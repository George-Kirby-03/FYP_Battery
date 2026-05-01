pwd
clear
close all

load('RS_Param_Retry.mat')
T1 = readtable("GK_RS15_01_char - 027 (1).csv");
pulseStart = []; % initialise as empty
i = 1;

while i <= length(T1.TestTime)
    
    if T1.Amps(i) > 1  % threshold for pulse detection
        pulseStart(end+1) = i; % store index
        cur_time = T1.TestTime(i);
        next_search = cur_time + 10; % 10 second gap
        
        % find next index AFTER this time
        next_search_idx = find(T1.TestTime >= next_search, 1, 'first');
        
        if isempty(next_search_idx)
            break % no more data
        else
            i = next_search_idx; % jump forward
        end
        
    else
        i = i + 1; % normal increment
    end
    
end


start_idx = pulseStart(1)-30;
start_volt = T1.Volts(start_idx);


p.r1 = 2;
p.r0 = 0.09;
p.c = 750;
p.q = 1.53*60*60;
p.vu = ocv_curve_2(1);
p.vl = ocv_curve_2(0);
p.ocv = ocv_curve_2;
R0 = p.r0;
R1 = p.r1;

op = ocv_curve_2;
fun = @(x) ocv_curve_2(x) - start_volt;
init_soc = fzero(fun, 0.1);

tt=T1.TestTime(start_idx:start_idx+600) - T1.TestTime(start_idx);
u1=T1.Amps(start_idx:start_idx+600);
V = T1.Volts(start_idx:start_idx+600);

current_lut = @(t) interp1(tt, u1, t, 'linear', 'extrap');
[t_sim, y_sim] = ode45(@(t, y) US_dynamics(t, y, p, current_lut), [30 40], [init_soc; 0; 0]);
x1=y_sim(:,1);x2=y_sim(:,2);

voltage_model = ocv_curve_2(x1) + x2 + R0.*current_lut(t_sim);
figure();
hold on
plot(tt, V);
plot(t_sim,voltage_model)

