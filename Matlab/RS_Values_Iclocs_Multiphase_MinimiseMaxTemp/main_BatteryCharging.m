

%--------------------------------------------------------

clear all;close all;format compact;
load RS_Param_Retry.mat
[problem,guess,options.phaseoptions]=BatteryCharging;          % Fetch the problem definition
options.mp= settings_BatteryCharging;                  % Get options and solver settings 
[solution,MRHistory]=solveMyProblem( problem,guess,options);
solution.phaseSol{end}.tf
features.minimisetemp.time = [];
features.minimisetemp.x1 = [];
features.minimisetemp.x2 = [];
features.minimisetemp.x3 = [];
features.minimisetemp.u = [];
features.minimisetemp.v = [];


%%
for i=1:length(solution.phaseSol)
    sol=solution.phaseSol{i};
    xx=sol.T;
    x1=speval(sol,'X',1,xx);
    x2=speval(sol,'X',2,xx);
    x3=speval(sol,'X',3,xx);
    u1=speval(sol,'U',1,xx).*sol.p(i);

    if i==1
        [ tv, xv ] = simulateDynamics( problem, [], u1(1), [x1(1) x2(1) x3(1) 0.1 0], xx, 'ode45' );
    else
        [ tv, xv ] = simulateDynamics( problem, [], u1(1), [xv(end,1) xv(end,2) xv(end,3) xv(end,4) xv(end,5)], xx, 'ode45' );
    end

    outputV=problem.mp.data.ocvpoly(x1)+x2+problem.mp.data.R0*sol.p(i);
    
features.minimisetemp.time = [features.minimisetemp.time; xx];
features.minimisetemp.x1   = [features.minimisetemp.x1; x1];
features.minimisetemp.x2   = [features.minimisetemp.x2; x2];
features.minimisetemp.x3   = [features.minimisetemp.x3; x3];
features.minimisetemp.u    = [features.minimisetemp.u; ones(size(x1))*sol.p(i)];
features.minimisetemp.v    = [features.minimisetemp.v; outputV];

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

    figure(105)
    hold on
    plot(xx,xv(:,4),'linewidth',2)
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
    

