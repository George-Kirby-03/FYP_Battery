

%--------------------------------------------------------

clear all;close all;format compact;
load RS_Param_Retry.mat
load proc1.mat
[problem,guess,options.phaseoptions]=BatteryCharging;          % Fetch the problem definition
options.mp= settings_BatteryCharging;                  % Get options and solver settings 
[solution,MRHistory]=solveMyProblem( problem,guess,options);

solution.phaseSol{end}.tf;
features.minimisepaing.time = [];
features.minimisepaing.x1 = [];
features.minimisepaing.x2 = [];
features.minimisepaing.x3 = [];
features.minimisepaing.u = [];
features.minimisepaing.v = [];

xx_total = [];
%%
for i=1:length(solution.phaseSol)
    sol=solution.phaseSol{i};
    xx=sol.T;
    xx_total = [xx_total; xx];
    x1=speval(sol,'X',1,xx);
    x2=speval(sol,'X',2,xx);
    x3=speval(sol,'X',3,xx);
    x4=speval(sol,'X',4,xx);
    u1=speval(sol,'U',1,xx).*sol.p(i);

    if i==1
        [ tv, xv ] = simulateDynamics( problem, [], u1(1), [x1(1) x2(1) x3(1) x4(1) 0], xx, 'ode45' );
    else
        [ tv, xv ] = simulateDynamics( problem, [], u1(1), [xv(end,1) xv(end,2) xv(end,3) xv(end,4) xv(end,5)], xx, 'ode45' );
    end
    outputV=problem.mp.data.ocvpoly(x1)+x2+problem.mp.data.R0*sol.p(i);
    
features.minimisepaing.time = [features.minimisepaing.time; xx];
features.minimisepaing.x1   = [features.minimisepaing.x1; x1];
features.minimisepaing.x2   = [features.minimisepaing.x2; x2];
features.minimisepaing.x3   = [features.minimisepaing.x3; x3];
features.minimisepaing.u    = [features.minimisepaing.u; ones(size(x1))*sol.p(i)];
features.minimisepaing.v    = [features.minimisepaing.v; outputV];

    figure(100)
    hold on
    plot(xx,speval(sol,'X',1,xx),'linewidth',2)
    xlabel('Time [s]')
    ylabel('SOC [-]')
    grid on
    
    figure(101)
    hold on
    plot(xx,speval(sol,'X',2,xx),'linewidth',2)
    xlabel('Time [s]')
    ylabel('V_RC [V]')
    grid on
    
   figure(102)
    hold on
    plot(xx,speval(sol,'X',3,xx),'linewidth',2)
    xlabel('Time [s]')
    ylabel('Temperature [Deg]')
    grid on

    
    
    
    figure(103)
    hold on
    plot(xx,u1,'linewidth',2)
    xlabel('Time [s]')
    grid on
    ylabel('Input Current [I]')

    figure(104)
    hold on
    plot(xx,outputV,'linewidth',2)
    xlabel('Time [s]')
    grid on
    ylabel('Vout [V]')

    figure(105)
    hold on
    plot(xx,speval(sol,'X',4,xx),'linewidth',2)
    xlabel('Time [s]')
    ylabel('Current Throughput')
    grid on

    figure(106)
    hold on
    plot(tv,xv(:,5),'linewidth',2)
    xlabel('Time [s]')
    ylabel('Q_loss')
    grid on

end
    
%%

idx_start = find(abs(proc1.TestTime - 59240.2) < 1, 1);
idx_end = find(abs(proc1.TestTime - 61299.7) < 1, 1);
scaled_time = proc1.TestTime(idx_start:idx_end) - proc1.TestTime(idx_start);
volts_labs = interp1(scaled_time,proc1.Volts(idx_start:idx_end),xx_total);
current_labs = interp1(scaled_time,proc1.Amps(idx_start:idx_end),xx_total);    
temp_labs = interp1(scaled_time,proc1.Temp1(idx_start:idx_end),xx_total);

figure(102)
hold on
plot(xx_total,temp_labs,'linewidth',2)
xlabel('Time [s]')
ylabel('Temperature [Deg]')
grid on


figure(104)
hold on
plot(xx_total,volts_labs,'linewidth',2)
xlabel('Time [s]')
grid on
ylabel('Vout [V]')
legend(["0-20% Sim", "20-40% Sim", "40-60% Sim", "60-80% Sim", "Lab Results"], "FontSize", 11, "FontWeight", "bold", "Position", [0.7997 0.6698 0.0972 0.1029])
title('\textbf{V_{out} for minimising paings loss }', 'Interpreter', 'latex', 'FontSize', 19)
