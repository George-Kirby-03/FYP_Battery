% main_BangbangTwoPhase - Main script to solve the Optimal Control Problem with a multi-phase formulation
%
% Two-phase BangBang Control (Double Integrator Minimum Time Repositioning) Problem
%
% The problem was adapted from Example 4.11 from
% J. Betts, "Practical Methods for Optimal Control and Estimation Using Nonlinear Programming: Second Edition," Advances in Design and Control, Society for Industrial and Applied Mathematics, 2010.
%
% Copyright (C) 2019 Yuanbo Nie, Omar Faqir, and Eric Kerrigan. All Rights Reserved.
% The contribution of Paola Falugi, Eric Kerrigan and Eugene van Wyk for the work on ICLOCS Version 1 (2010) is kindly acknowledged.
% This code is published under the MIT License.
% Department of Aeronautics and Department of Electrical and Electronic Engineering,
% Imperial College London London  England, UK 
% ICLOCS (Imperial College London Optimal Control) Version 2.5 
% 1 Aug 2019
% iclocs@imperial.ac.uk

% voltage=3.64+0.55.*x1-0.72.*x1.^2+0.75*x1.^3+x2+vdat.R0*u1;
%--------------------------------------------------------

clear all;close all;format compact;

[problem,guess,options.phaseoptions]=BatteryEstimation;          % Fetch the problem definition
options.mp= settings_BatteryEstimation;                  % Get options and solver settings 
[solution,MRHistory]=solveMyProblem( problem,guess,options);

%% figure
close all
% minSOC=1;
% maxSOC=0;

% colorlist=[0 0.4470 0.7410;
%             0.8500 0.3250 0.0980;
%             0.9290 0.6940 0.1250;
%             0.4940 0.1840 0.5560;
%             0.4660 0.6740 0.1880;
%             0.3010 0.7450 0.9330;
%             0.6350 0.0780 0.1840];

colorlist = [
    0.0000 0.4500 0.7000   % Blue
    0.8350 0.3690 0.0000   % Orange
    0.0000 0.6000 0.5000   % Teal/Green
    0.8000 0.4750 0.6550   % Pink/Purple
    0.9500 0.9000 0.2500   % Yellow
    0.3500 0.7000 0.9000   % Light Blue
    0.9000 0.6000 0.0000   % Amber
    0.4000 0.4000 0.4000   % Gray
];


load("Learning\DS_DATA.mat")
measurementData.tt = C01_Discharge(:,3)./1000;
measurementData.u1 = 1.5*0.1*ones(78,1);
measurementData.y = C01_Discharge(:,2);
for i=1:length(solution.phaseSol)
    sol=solution.phaseSol{i};
    tt=sol.T;
    x1=speval(sol,'X',1,tt);
    x2=speval(sol,'X',2,tt);
    x3=speval(sol,'X',3,tt);
    % minSOC=min(minSOC,min(x1));
    % maxSOC=max(maxSOC,max(x1));
    u1=problem.phases{i}.data.InputCurrent(tt);
    R0=R0Model(sol.p',x1,u1);
    y=OCVModel(sol.p',x1)+x2+R0.*u1;

    Q=sol.p(problem.phases{i}.data.Np_poly+1)/3600;
    Cp=sol.p(problem.phases{i}.data.Np_poly+2);
    C1=sol.p(problem.phases{i}.data.Np_poly+3);
    R1=sol.p(problem.phases{i}.data.Np_poly+4);

    % y=+sol.p(2).*x1+sol.p(3).*x1.^2+sol.p(4).*x1.^3+sol.p(5).*x1.^4+sol.p(6).*x1.^5+sol.p(7).*x1.^6;

    f_size = 14;

    fig1=figure(1)
    subplot(2,2,1)
    hold on
    plot(tt,x1,'LineWidth',2,'Color',colorlist(i,:))
    xlabel('Time [s]','FontSize',f_size,'Interpreter','latex')
    ylabel('Estimated State: State-of-Charge','FontSize',f_size,'Interpreter','latex')
    xlim([solution.phaseSol{1}.T(1) solution.phaseSol{end}.T(end)])
    grid on
    
    % figure
    subplot(2,2,2)
    hold on
    plot(tt,x2,'LineWidth',2,'Color',colorlist(i,:))
    xlabel('Time [s]','FontSize',f_size,'Interpreter','latex')
    ylabel('Estimated State: RC Voltage [V]','FontSize',f_size,'Interpreter','latex')
    xlim([solution.phaseSol{1}.T(1) solution.phaseSol{end}.T(end)])
    grid on
    
    % figure
    subplot(2,2,3)
    hold on
    plot(tt,x3,'LineWidth',2,'Color',colorlist(i,:))
    xlabel('Time [s]','FontSize',f_size,'Interpreter','latex')
    ylabel('Estimated State: Temperature [K]','FontSize',f_size,'Interpreter','latex')
    ylim([15 80])
    xlim([solution.phaseSol{1}.T(1) solution.phaseSol{end}.T(end)])
    grid on

    % figure
    subplot(2,2,4)
    hold on
    % plot(tt,u1,'k-' ,'LineWidth',2)
    p0=plot(measurementData.tt,measurementData.u1,'k-' ,'LineWidth',2)
    xlabel('Time [s]','FontSize',f_size,'Interpreter','latex')
    grid on
    xlim([solution.phaseSol{1}.T(1) solution.phaseSol{end}.T(end)])
    ylabel('Measured Input: Current [A]','FontSize',f_size,'Interpreter','latex')

    fig2=figure(2)
    subplot(2,1,1)
    hold on
    p{i}=plot(tt,y,'LineWidth',2,'Color',colorlist(i,:))
    % p0=plot(tt,problem.phases{i}.data.OutputVoltage(tt),'k-' ,'LineWidth',2)
    p0=plot(measurementData.tt,measurementData.y,'k-' ,'LineWidth',2)
    xlabel('Time [s]','FontSize',f_size,'Interpreter','latex')
    ylabel('Output: voltage [V]','FontSize',f_size,'Interpreter','latex')
    xlim([solution.phaseSol{1}.T(1) solution.phaseSol{end}.T(end)])
    grid on

    % figure(6)
    % hold on
    % plot(x1,R0,'-' ,'LineWidth',2)
    % xlabel('State-of-Charge')
    % ylabel('R0')
    % grid on
end
% legend([p0,p{1},p{2},p{3},p{4},p{5}],{'Measurement','Model Output (Charge)','Model Output (Take-off)','Model Output (Cruise)','Model Output (Landing)','Model Output (Resting)'})
leg=legend([p0,p{1}],{'Measurement','Model Output'},'Location','best','FontSize',f_size,'Interpreter','latex')
set(leg, 'Interpreter','latex','FontSize',10)
% 
% soc=minSOC:0.01:maxSOC;
soc=0:0.01:1;
OCV=sol.p(1)+sol.p(2).*soc+sol.p(3).*soc.^2+sol.p(4).*soc.^3+sol.p(5).*soc.^4+sol.p(6).*soc.^5+sol.p(7).*soc.^6;
figure(2)
subplot(2,1,2)
plot(soc,OCV,'b-' ,'LineWidth',2)
xlabel('State-of-Charge','FontSize',f_size,'Interpreter','latex')
ylabel('OCV [V]','FontSize',f_size,'Interpreter','latex')
% xlim([minSOC maxSOC])
grid on



ax = gca; % current axes
ax.FontSize = f_size;
ax.TickLabelInterpreter = 'latex';