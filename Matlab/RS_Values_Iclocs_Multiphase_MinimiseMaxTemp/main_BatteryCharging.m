

%--------------------------------------------------------

clear all;close all;format compact;
load RS_Param_Retry.mat
[problem,guess,options.phaseoptions]=BatteryCharging;          % Fetch the problem definition
options.mp= settings_BatteryCharging;                  % Get options and solver settings 
[solution,MRHistory]=solveMyProblem( problem,guess,options);
solution.phaseSol{end}.tf
features.minimisetempmax.time = [];
features.minimisetempmax.x1 = [];
features.minimisetempmax.x2 = [];
features.minimisetempmax.x3 = [];
features.minimisetempmax.u = [];
features.minimisetempmax.v = [];


%%
for i=1:length(solution.phaseSol)
    sol=solution.phaseSol{i};
    xx=sol.T;
    x1=speval(sol,'X',1,xx);
    x2=speval(sol,'X',2,xx);
    x3=speval(sol,'X',3,xx);
    outputV=problem.mp.data.ocvpoly(x1)+x2+problem.mp.data.R0*sol.p(i);
    
features.minimisetempmax.time = [features.minimisetempmax.time; xx];
features.minimisetempmax.x1   = [features.minimisetempmax.x1; x1];
features.minimisetempmax.x2   = [features.minimisetempmax.x2; x2];
features.minimisetempmax.x3   = [features.minimisetempmax.x3; x3];
features.minimisetempmax.u    = [features.minimisetempmax.u; ones(size(x1))*sol.p(i)];
features.minimisetempmax.v    = [features.minimisetempmax.v; outputV];
    
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
    

