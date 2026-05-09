clc
clear
close all

%% ========================================================================
%  Battery Parameters
%  ========================================================================

avg_sim_handle_b1 = [];

avg_sim_handle_b1.current_sol.Q  = 5.58e03;
avg_sim_handle_b1.current_sol.C  = 800;
avg_sim_handle_b1.current_sol.R0 = 0.075;
avg_sim_handle_b1.current_sol.R1 = 0.045;
avg_sim_handle_b1.current_sol.Cp = 75;
avg_sim_handle_b1.current_sol.h  = 0.12;

%% ========================================================================
%  Load Experimental Data
%  ========================================================================

data = readtable( ...
"C:\Users\jekir\GitHub\FYP_Battery\Matlab\Report_Fig_makes\RPT_Analsys\GK_RS15_01_char - 027 (1).csv");

%% ========================================================================
%  Select Time Window
%  ========================================================================

start_time = 0;
end_time   = 33000;

start_time_idx = find(data.TestTime > start_time,1,"first");
end_time_idx   = find(data.TestTime > end_time,1,"first");

data = data(start_time_idx:end_time_idx,:);
data.TestTime = data.TestTime - data.TestTime(1);

% Temperature rise only
data.Temp1 = data.Temp1 - data.Temp1(1);

t_sim = data.TestTime;

%% ========================================================================
%  Lookup Tables
%  ========================================================================

current_lut = @(t) interp1( ...
    data.TestTime,...
    data.Amps,...
    t,...
    'pchip',...
    'extrap');

voltage_lut = @(t) interp1( ...
    data.TestTime,...
    data.Volts,...
    t,...
    'pchip',...
    'extrap');

temp_lut = @(t) interp1( ...
    data.TestTime,...
    data.Temp1,...
    t,...
    'pchip',...
    'extrap');

%% ========================================================================
%  Heat Generation Model
%  ========================================================================

R_total = avg_sim_handle_b1.current_sol.R0 + ...
          avg_sim_handle_b1.current_sol.R1;

Q_lut = @(t) (current_lut(t).^2) .* R_total;

%% ========================================================================
%  Identification Sampling
%  ========================================================================

greyest_time_sampling = linspace( ...
    t_sim(1),...
    t_sim(end),...
    1500);

U_sampled = Q_lut(greyest_time_sampling);

Temp_sampled = temp_lut(greyest_time_sampling);

Data = array2table( ...
    [U_sampled', Temp_sampled'], ...
    "VariableNames",["u1","y"]);

Data_ts = table2timetable( ...
    Data,...
    "RowTimes",seconds(greyest_time_sampling));

smodle = iddata(Data_ts,'Name','Temperature Generation');


mCp_init = 100;
hA_init  = 0.2;

parameters = [mCp_init hA_init];

init_sys = idgrey('TempFnc',parameters,'c');

opt = greyestOptions( ...
    'Focus','simulation');

sys = greyest( ...
    smodle,...
    init_sys,...
    opt);

res = getpvec(sys);

mCp_est = res(1)
hA_est  = res(2)

simulated_temp = lsim( ...
    sys,...
    U_sampled,...
    greyest_time_sampling);

%% ========================================================================
%  Plot Thermal Model Fit
%  ========================================================================

figure

plot( ...
    greyest_time_sampling,...
    Temp_sampled,...
    'LineWidth',2);

hold on

plot( ...
    greyest_time_sampling,...
    simulated_temp,...
    'LineWidth',2);

grid on

xlabel('Time (s)')
ylabel('Temperature Rise (^oC)')

legend( ...
    'Measured',...
    'Grey-Box Model')

title('Thermal Grey-Box Model Identification')

set(gcf,"Theme","light");

%% ========================================================================
%  Plot Heat Generation
%  ========================================================================

figure

plot( ...
    greyest_time_sampling,...
    U_sampled,...
    'LineWidth',2);

grid on

xlabel('Time (s)')
ylabel('Heat Generation (W)')

title('Estimated Heat Input')

set(gcf,"Theme","light");