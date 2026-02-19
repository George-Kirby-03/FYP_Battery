t = linspace(0,500,50);
tp = 20*sin(t);

load features.mat
R0=0.075;
figure()
hold on

histogram(features.minimisetemp.x3,12,'Normalization','probability')
histogram(features.minimisetempmax.x3,12,'Normalization','probability')
histogram(features.baseline.x3,18,'Normalization','probability')
histogram(features.minimisepang.x3,18,'Normalization','probability')

title("Density functions of temperature rises")
grid on
xlabel("\textbf{Temperature bins (From ambient 24$^{\circ}$)}",  "Interpreter", "latex", "FontSize", 15)
legend(["Minimised Temperature", "Minimised Max Temperature", "Baseline", "Minimise Qloss Paing"],"FontWeight","bold")
title("\textbf{Histogram / Temperature binned density plots}", "Interpreter", "latex", "FontSize", 20)

%%
tt = linspace(0, features.baseline.time(end), 2000);
[t_unique, idx] = unique(features.baseline.time, 'stable');
tempRise = interp1(t_unique, features.baseline.x3(idx), tt, 'linear');
temp_integral = trapz(tt, tempRise);
avg_temp_baseline = temp_integral / tt(end);
pol_baseline = interp1(t_unique, features.baseline.x2(idx), tt, 'linear');
u = interp1(t_unique, features.baseline.u(idx), tt, 'linear');
over_potential_baseline = pol_baseline + u*R0; 
over_potential_integral = trapz(tt, over_potential_baseline);
avg_over_potential_baseline = over_potential_integral / tt(end);

tt = linspace(0, features.minimisetemp.time(end), 2000);
[t_unique, idx] = unique(features.minimisetemp.time, 'stable');
tempRise = interp1(t_unique, features.minimisetemp.x3(idx), tt, 'linear');
temp_integral = trapz(tt, tempRise);
avg_temp_minimisetemp = temp_integral / tt(end);
pol_minimisetemp = interp1(t_unique, features.minimisetemp.x2(idx), tt, 'linear');
u = interp1(t_unique, features.minimisetemp.u(idx), tt, 'linear');
over_potential_minimisetemp = pol_minimisetemp + u*R0; 
over_potential_integral = trapz(tt, over_potential_minimisetemp);
avg_over_potential_minimisetemp = over_potential_integral / tt(end);

tt = linspace(0, features.minimisetempmax.time(end), 2000);
[t_unique, idx] = unique(features.minimisetempmax.time, 'stable');
tempRise = interp1(t_unique, features.minimisetempmax.x3(idx), tt, 'linear');
temp_integral = trapz(tt, tempRise);
avg_temp_minimisetempmax = temp_integral / tt(end);
pol_minimisetempmax = interp1(t_unique, features.minimisetempmax.x2(idx), tt, 'linear');
u = interp1(t_unique, features.minimisetempmax.u(idx), tt, 'linear');
over_potential_minimisetempmax = pol_minimisetempmax + u*R0; 
over_potential_integral = trapz(tt, over_potential_minimisetempmax);
avg_over_potential_minimisetempmax = over_potential_integral / tt(end);

tt = linspace(0, features.minimisepang.time(end), 2000);
[t_unique, idx] = unique(features.minimisepang.time, 'stable');
tempRise = interp1(t_unique, features.minimisepang.x3(idx), tt, 'linear');
temp_integral = trapz(tt, tempRise);
avg_temp_minimisepang = temp_integral / tt(end);
pol_minimisepang = interp1(t_unique, features.minimisepang.x2(idx), tt, 'linear');
u = interp1(t_unique, features.minimisepang.u(idx), tt, 'linear');
over_potential_minimisepang = pol_minimisepang + u*R0; 
over_potential_integral = trapz(tt, over_potential_minimisepang);
avg_over_potential_minimisepang = over_potential_integral / tt(end);

x = ["Baseline"; "Minimise Temp"; "Minimise MaxTemp"; "Minimise Qloss Paing"];
figure()
y = [avg_temp_baseline-24 max(features.baseline.x3)-24 ; 
    avg_temp_minimisetemp-24 max(features.minimisetemp.x3)-24 ; 
    avg_temp_minimisetempmax-24 max(features.minimisetempmax.x3)-24;
    avg_temp_minimisepang-24 max(features.minimisepang.x3)-24];
bar(x,y)
legend('Averaged Temperature', 'Maximum Temperature',"FontWeight","bold")
ylabel('Temperature Rise (°C)');
title("\textbf{Temperature Rise During Charging}", "Interpreter", "latex", "FontSize", 20);
grid on;
hold off

figure()
y = [avg_over_potential_baseline max(over_potential_baseline) ; 
    avg_over_potential_minimisetemp max(over_potential_minimisetemp) ; 
    avg_over_potential_minimisetempmax max(over_potential_minimisetempmax)
    avg_over_potential_minimisepang max(over_potential_minimisepang)];
bar(x,y)
legend('Averaged Overpotential', 'Maximum Overpotential',"FontWeight","bold")
ylabel('Voltage (V)');
title("\textbf{Overpotentials During Charging}", "Interpreter", "latex", "FontSize", 20);
grid on;
