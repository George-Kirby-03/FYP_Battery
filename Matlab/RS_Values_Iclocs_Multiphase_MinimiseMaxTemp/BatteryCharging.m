function [problem,guess,phaseoptions] = BangBangTwoPhase
%BangBang - BangBang Control (Double Integrator Minimum Time Repositioning) Problem with a multi-phase formulation
%
% The problem was adapted from Example 4.11 from
% J. Betts, "Practical Methods for Optimal Control and Estimation Using Nonlinear Programming: Second Edition," Advances in Design and Control, Society for Industrial and Applied Mathematics, 2010.
%
% Outputs:
%    problem - Structure with information on the optimal control problem
%    guess   - Guess for state, control and multipliers.
%
% Other m-files required: none
% MAT-files required: none
%
% Copyright (C) 2019 Yuanbo Nie, Omar Faqir, and Eric Kerrigan. All Rights Reserved.
% The contribution of Paola Falugi, Eric Kerrigan and Eugene van Wyk for the work on ICLOCS Version 1 (2010) is kindly acknowledged.
% This code is published under the MIT License.
% Department of Aeronautics and Department of Electrical and Electronic Engineering,
% Imperial College London London  England, UK 
% ICLOCS (Imperial College London Optimal Control) Version 2.5 
% 1 Aug 2019
% iclocs@imperial.ac.uk
load("RS_OC.mat")
% load("tucker_poly.mat")
% co = z;
Vmax=polyval(co,1);
Vmin=polyval(co,0);
Temp_Max=45;
problem.mp.data.N_phases=4;

% Initial and final time for different phases. Let t_min(end)=t_max(end) if tf is fixed.
problem.mp.time.t_min=[0 1 2 3 1980];     
problem.mp.time.t_max=[0 1500 1500 1500 1980]; 
guess.mp.time=[0 50 100 300 600];

% Parameters bounds. pl=< p <=pu
%G.K adding parmeters which is T_Max by definining as shown in All_phases
%file
problem.mp.parameters.pl=[zeros(1,problem.mp.data.N_phases) 0];
problem.mp.parameters.pu=[10*15*ones(1,problem.mp.data.N_phases) 50];
guess.mp.parameters=[zeros(1,problem.mp.data.N_phases) 30];

% Bounds for linkage boundary constraints bll =< bclink(x0,xf,u0,uf,p,t0,tf,vdat) =< blu
problem.mp.constraints.bll.linear=[zeros(1,(problem.mp.data.N_phases-1)*3)];
problem.mp.constraints.blu.linear=[zeros(1,(problem.mp.data.N_phases-1)*3)];
problem.mp.constraints.blTol.linear=[0.01*ones(1,(problem.mp.data.N_phases-1)*3)];

problem.mp.constraints.bll.nonlinear=[];
problem.mp.constraints.blu.nonlinear=[];
problem.mp.constraints.blTol.nonlinear=[];

% Get function handles
problem.mp.linkfunctions=@bclink;

% Store the necessary problem parameters used in the functions
problem.mp.data.Q=5400;
problem.mp.data.R0=0.01;
problem.mp.data.R1=0.06;
problem.mp.data.C1=1000;
problem.mp.data.Vmax=Vmax;
problem.mp.data.Vmin=Vmin;
problem.mp.data.batt_m=0.0042;
problem.mp.data.batt_Cp=1547.737;
problem.mp.data.batt_h=158.061;
problem.mp.data.TempAmb=24;
problem.mp.data.batt_A=0.003714;
problem.mp.data.ocvpoly=co;
% Define different phases of OCP

% Configure 1 fixed SOC boundary
x0ul{1}=[0 0 problem.mp.data.TempAmb;0 0 problem.mp.data.TempAmb];
x0ul{2}=[0.2 0 0;0.2 0.35 Temp_Max];
x0ul{3}=[0.4 0 0;0.4 0.35 Temp_Max];
x0ul{4}=[0.6 0 0;0.6 0.35 Temp_Max];

xful{1}=x0ul{2};
xful{2}=x0ul{3};
xful{3}=x0ul{4};
xful{4}=[0.8 0 20;0.8 0.35 Temp_Max];

% Configure 2 free SOC boundary
% x0ul{1}=[0 0 15;0 0 15];
% x0ul{2}=[0 0 0;1 0.25 Temp_Max];
% x0ul{3}=[0 0 0;1 0.25 Temp_Max];
% x0ul{4}=[0 0 0;1 0.25 Temp_Max];
% 
% xful{1}=x0ul{2};
% xful{2}=x0ul{3};
% xful{3}=x0ul{4};
% xful{4}=[0.8 0 0;0.8 0.25 Temp_Max];


for i=1:problem.mp.data.N_phases
    [problem.phases{i},guess.phases{i}] = BatteryCharging_Phases(problem.mp, guess.mp,i,x0ul,xful,Temp_Max);
    phaseoptions{i}=problem.phases{i}.settings(40);
end

%------------- END OF CODE --------------


function [blc_linear, blc_nonlinear]=bclink(x0,xf,u0,uf,p,t0,tf,vdat)

% bclink - Returns the evaluation of the linkage boundary constraints: bll =< bclink(x0,xf,u0,uf,p,t0,tf,vdat) =< blu
%
% Syntax:  [blc_linear, blc_nonlinear]=bclink(x0,xf,u0,uf,p,t0,tf,vdat)
%
% Inputs:
%    x0  - state at t=0
%    xf  - state at t=tf
%    u0  - input at t=0
%    uf  - input at t=tf
%    p   - parameter
%    tf  - final time
%    vdat- structured variable containing the values of additional data used inside
%          the function
%
%          
% Output:
%    blc_linear - column vector containing the evaluation of the linear linkage boundary constraint functions
%    blc_nonlinear - column vector containing the evaluation of the nonlinear linkage boundary constraint functions
%
%------------- BEGIN CODE --------------
N_phases=vdat.N_phases;
blc_linear=zeros(3*(N_phases-1),1);
for i=1:N_phases-1
    blc_linear(1+(i-1)*3:i*3)=[xf{i}(1)-x0{i+1}(1);xf{i}(2)-x0{i+1}(2);xf{i}(3)-x0{i+1}(3)];
end
blc_nonlinear=[];
%------------- END OF CODE --------------
