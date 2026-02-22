% Main script to solve the Battery state and parameter estimation problem
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




[problem,guess]=BatteryEstimation_temp('charac_01_start.mat');          % Fetch the problem definition
options= problem.settings(80);                  % Get options and solver settings 
[solution,MRHistory]=solveMyProblem( problem,guess,options);

%% figure%

%% figure
tt=solution.T;
x1=speval(solution,'X',1,tt);
x2=speval(solution,'X',2,tt);
x3=speval(solution,'X',3,tt);
u1=problem.data.InputCurrent(tt);
soc = linspace(0,1,50);
OCV_SOC = polymodel(problem.data,solution.p,soc,1);
y=polymodel(problem.data,solution.p,x1,1) + x2 + solution.p(problem.data.poly.R0).*u1;
temp = x3;
figure
subplot(2,3,1)
hold on
plot(tt,x1,'b-' ,'LineWidth',2)
plot([solution.T(1,1); solution.tf],[problem.states.xl(1), problem.states.xl(1)],'r-' )
plot([solution.T(1,1); solution.tf],[problem.states.xu(1), problem.states.xu(1)],'r-' )
xlabel('Time [s]')
ylabel('States: State-of-Charge')
grid on

subplot(2,3,2)
hold on
plot(soc,OCV_SOC,'b-' ,'LineWidth',2)
xlabel('SOC')
ylabel('OCV')
grid on

subplot(2,3,3)
hold on
plot(tt,u1,'k-' ,'LineWidth',2)
plot([solution.T(1,1); solution.tf],[problem.inputs.ul, problem.inputs.ul],'r-' )
plot([solution.T(1,1); solution.tf],[problem.inputs.uu, problem.inputs.uu],'r-' )
xlim([0 solution.tf])
xlabel('Time [s]')
grid on
ylabel('Control Input: Current [A]')
 
subplot(2,3,4)
hold on
plot(tt,temp,'b-' ,'LineWidth',2)
plot(tt,problem.data.OutputTemp(tt),'k-' ,'LineWidth',2)
xlabel('Time [s]')
ylabel('Output: temperature [DT]')
legend('Model Output', 'Measured')
grid on

subplot(2,3,5)
hold on
plot(tt,y,'b-' ,'LineWidth',2)
plot(tt,problem.data.OutputVoltage(tt),'k-' ,'LineWidth',2)
xlabel('Time [s]')
ylabel('Output: voltage [V]')
legend('Model Output', 'Measured')
grid on
