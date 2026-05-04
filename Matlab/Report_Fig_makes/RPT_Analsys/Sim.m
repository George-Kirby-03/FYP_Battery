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

%%
figure();
hold on

start_idx = pulseStart(2)-1980;
start_volt = T1.Volts(start_idx);
end_offset = 3000;

p.r1 = 0.075;
p.r0 = 0.075;
p.c = 700;
p.q = 1.53*60*60;
p.vu = ocv_curve_2(1);
p.vl = ocv_curve_2(0);
p.ocv = ocv_curve_2;
R0 = p.r0;
R1 = p.r1;

op = ocv_curve_2;
fun = @(x) ocv_curve_2(x) - start_volt;
init_soc = fzero(fun, 0.4);

tt=T1.TestTime(start_idx:start_idx+end_offset) - T1.TestTime(start_idx);
u1=T1.Amps(start_idx:start_idx+end_offset);
V = T1.Volts(start_idx:start_idx+end_offset);

current_lut = @(t) interp1(tt, u1, t, 'linear', 'extrap');
[t_sim, y_sim] = ode45(@(t, y) US_dynamics(t, y, p, current_lut), [0 350], [init_soc; 0; 0]);
x1=y_sim(:,1);x2=y_sim(:,2);

voltage_model = ocv_curve_2(x1) + x2 + R0.*current_lut(t_sim);


figure();
hold on
plot(t_sim,voltage_model - voltage_model(1))


c1 = [0.87 0.33 0.0];   % low SOC (orange)
c2 = [0.07 0.44 0.75];  % high SOC (blue)

Nmap = 256;
cmap = [linspace(c1(1), c2(1), Nmap)', ...
        linspace(c1(2), c2(2), Nmap)', ...
        linspace(c1(3), c2(3), Nmap)'];

colormap(cmap);

n = 8;
soc_vals = linspace(0.1, 0.9, n);   % map each curve to SOC

for k = 1:n
    i = k + 1;

    start_idx = pulseStart(i) - 1980;
    end_offset = 3000;

    tt = T1.TestTime(start_idx:start_idx+end_offset) ...
         - T1.TestTime(start_idx);

    V = T1.Volts(start_idx:start_idx+end_offset);
    V_norm = V - V(1);

    soc = soc_vals(k);

    % map SOC → colormap index
    t = (soc - 0.1)/(0.9 - 0.1);
    idx = round(1 + t*(Nmap-1));
    color = cmap(idx,:);

    plot(tt, V_norm, 'Color', color, 'LineWidth', 1.5);
    xlabel("Time $(S)$","Interpreter","latex",'FontSize',13);
    ylabel("OCV offset $(V)$","Interpreter","latex",'FontSize',13);
    grid on
end

% --- FIXED ---
cb = colorbar;
cb.Label.String = 'State of Charge (SOC)';
cb.FontSize = 13;
caxis([0.1 0.9]);
%%
figure();
hold on

    start_idx = pulseStart(3) + 2500 ;
    end_offset = 5000;

    tt = T1.TestTime(start_idx:start_idx+end_offset) ...
         - T1.TestTime(start_idx);

    V = T1.Volts(start_idx:start_idx+end_offset);

p.r1 = 0.075;
p.r0 = 0.075;
p.c = 800;
p.q = 1.53*60*60;
p.vu = ocv_curve_2(1);
p.vl = ocv_curve_2(0);
p.ocv = ocv_curve_2;
R0 = p.r0;
R1 = p.r1;

op = ocv_curve_2;
fun = @(x) ocv_curve_2(x) - start_volt;
init_soc = fzero(fun, 0.4);

tt=T1.TestTime(start_idx:start_idx+end_offset) - T1.TestTime(start_idx);
u1=T1.Amps(start_idx:start_idx+end_offset);
V = T1.Volts(start_idx:start_idx+end_offset);

current_lut = @(t) interp1(tt, u1, t, 'linear', 'extrap');
[t_sim, y_sim] = ode45(@(t, y) US_dynamics(t, y, p, current_lut), [0 5000], [init_soc; R1*current_lut(1); 0]);
x1=y_sim(:,1);x2=y_sim(:,2);

voltage_model = ocv_curve_2(x1) + x2 + R0.*current_lut(t_sim);
plot(t_sim,voltage_model  - voltage_model(1), 'LineWidth',3,'Color','black','LineStyle','-.')

c1 = [0.87 0.33 0.0];   % low SOC (orange)
c2 = [0.07 0.44 0.75];  % high SOC (blue)

Nmap = 256;
cmap = [linspace(c1(1), c2(1), Nmap)', ...
        linspace(c1(2), c2(2), Nmap)', ...
        linspace(c1(3), c2(3), Nmap)'];

colormap(cmap);


n = 7;
soc_vals = linspace(0.1, 0.9, n);   % map each curve to SOC

for k = 1:n
    i = k + 1;

    start_idx = pulseStart(i) + 2500 ;
    end_offset = 5000;

    tt = T1.TestTime(start_idx:start_idx+end_offset) ...
         - T1.TestTime(start_idx);

    V = T1.Volts(start_idx:start_idx+end_offset);
    V_norm = V - V(1);

    soc = soc_vals(k);

    % map SOC → colormap index
    t = (soc - 0.1)/(0.9 - 0.1);
    idx = round(1 + t*(Nmap-1));
    color = cmap(idx,:);

    plot(tt, V_norm, 'Color', color, 'LineWidth', 1.5);
    xlabel("Time $(S)$","Interpreter","latex",'FontSize',13);
    ylabel("Relaxation $(V)$","Interpreter","latex",'FontSize',13);
    grid on
end


% --- FIXED ---
cb = colorbar;
cb.Label.String = 'State of Charge (SOC)';
cb.FontSize = 13;
caxis([0.1 0.9]);




%%
soc = linspace(0,1,150);
figure; 
plot(soc,ocv_curve_2(soc),'LineWidth',3)
yline(3.65,'Label','True Upper Limit','FontSize',13,'Interpreter','latex','LineWidth',2)
yline(2.5,'Label','True Lower Limit','FontSize',13,'Interpreter','latex','LineWidth',2)
xlabel("SoC","Interpreter","latex",'FontSize',13);
ylabel("Equlibrium Voltage $(V)$","Interpreter","latex",'FontSize',13);