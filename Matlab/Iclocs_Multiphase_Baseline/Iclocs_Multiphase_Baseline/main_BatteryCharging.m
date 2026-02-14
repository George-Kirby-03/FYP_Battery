

%--------------------------------------------------------

clear all;close all;format compact;
load RS_Baseline_og_attia_normalised.mat
Cycle10 = GK_RS_baseline_028(GK_RS_baseline_028.Cyc_ == 10 | GK_RS_baseline_028.Cyc_ == 11 ,:);
k = find(abs(Cycle10.TestTime - 104079) < 10, 1);
Cycle10 = Cycle10(k:end,:);
Cycle10.TestTime = Cycle10.TestTime - Cycle10.TestTime(1);
k = find(abs(Cycle10.TestTime - 1800) < 5, 1);
Cycle10 = Cycle10(1:k,:);
diff = Cycle10.Temp1(1) - 24;
Cycle10.Temp1 = Cycle10.Temp1 - diff;
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
    outputV=polyval(problem.mp.data.ocvpoly,x1)+x2+problem.mp.data.R0*u1;
    
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
    plot(Cycle10.TestTime,Cycle10.Temp1)
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
     plot(Cycle10.TestTime,Cycle10.Volts)
    xlabel('Time [s]')
    grid on
    ylabel('Voltage [I]')
end
    

