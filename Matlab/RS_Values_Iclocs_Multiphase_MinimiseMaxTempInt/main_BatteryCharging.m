

%--------------------------------------------------------

clear all;close all;format compact;
load RS_Param_Retry.mat
[problem,guess,options.phaseoptions]=BatteryCharging;          % Fetch the problem definition
options.mp= settings_BatteryCharging;                  % Get options and solver settings 
[solution,MRHistory]=solveMyProblem( problem,guess,options);
solution.phaseSol{end}.tf
%%
for i=1:length(solution.phaseSol)
    sol=solution.phaseSol{i};
    xx=sol.T;
    x1=speval(sol,'X',1,xx);
    x2=speval(sol,'X',2,xx);
    outputV=problem.mp.data.ocvpoly(x1)+x2+problem.mp.data.R0*sol.p(i);
    
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
    plot(xx,speval(sol,'U',1,xx).*sol.p(i),'linewidth',2)
    xlabel('Time [s]')
    grid on
    ylabel('Input Current [I]')

    figure(104)
    hold on
    plot(xx,outputV,'linewidth',2)
    xlabel('Time [s]')
    grid on
    ylabel('Vout [V]')


end
    

