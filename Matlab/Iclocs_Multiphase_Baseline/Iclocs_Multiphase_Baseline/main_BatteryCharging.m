%--------------------------------------------------------10
clear all;close all;format compact;
load RS_Param_Retry.mat
k_start = find(abs(RS_01_baseline.TestTime - 14290) < 1, 1);
k_end = find(abs(RS_01_baseline.TestTime - 16600) < 10, 1);
RS_01_baseline_cycle = RS_01_baseline(k_start:k_end,:);
RS_01_baseline_cycle.TestTime = RS_01_baseline_cycle.TestTime - RS_01_baseline_cycle.TestTime(1);
k_start = find(abs(RS_01_baseline_cycle.TestTime - 453.93) < 3, 1);
RS_01_baseline_cycle = RS_01_baseline_cycle(k_start:end,:);
RS_01_baseline_cycle.TestTime = RS_01_baseline_cycle.TestTime - RS_01_baseline_cycle.TestTime(1);
diff = RS_01_baseline_cycle.Temp1(1) - 24;
RS_01_baseline_cycle.Temp1 = RS_01_baseline_cycle.Temp1 - diff;
[problem,guess,options.phaseoptions]=BatteryCharging;          % Fetch the problem definition
options.mp= settings_BatteryCharging;                  % Get options and solver settings 
[solution,MRHistory]=solveMyProblem( problem,guess,options);
solution.phaseSol{end}.tf
%%
for i=1:length(solution.phaseSol)
    sol=solution.phaseSol{i};
    tt=sol.T;
    x1=speval(sol,'X',1,tt);
    x2=speval(sol,'X',2,tt);
    x3=speval(sol,'X',3,tt);
    u1=speval(sol,'U',1,tt);
    outputV=problem.mp.data.ocvpoly(x1)+x2+problem.mp.data.R0*sol.p(i);
    
    figure(100)
    hold on
    plot(tt,x1,'linewidth',2)
    xlabel('Time [s]')
    ylabel('SOC [-]')
    grid on
    
    figure(101)
    hold on
    plot(tt,x2,'linewidth',2)
    xlabel('Time [s]')
    ylabel('V_RC [V]')
    grid on
    
   figure(102)
    hold on
    plot(tt,x3,'linewidth',2)
    plot(RS_01_baseline_cycle.TestTime,RS_01_baseline_cycle.Temp1)
    xlabel('Time [s]')
    ylabel('Temperature [Deg]')
    grid on
    
    figure(103)
    hold on
    plot(tt,u1.*sol.p(i),'linewidth',2)
    xlabel('Time [s]')
    grid on
    ylabel('Input Current [I]')

    figure(105)
    hold on
    plot(tt,outputV,'linewidth',2)
     plot(RS_01_baseline_cycle.TestTime,RS_01_baseline_cycle.Volts)
    xlabel('Time [s]')
    grid on
    ylabel('Voltage [I]')
end
    

