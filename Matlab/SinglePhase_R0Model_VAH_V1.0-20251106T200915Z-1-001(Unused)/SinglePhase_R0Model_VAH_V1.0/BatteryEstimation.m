function [problem,guess,phaseoptions] = BatteryEstimation
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

load("Learning\DS_DATA.mat")
tt = C01_Discharge(:,3)./1000;
u1 = 1.5*0.1*ones(78,1);
y = C01_Discharge(:,2);
tf_1=tt(end);

% Initial and final time for different phases. Let t_min(end)=t_max(end) if tf is fixed.
problem.mp.time.t_min=[0 tf_1 ];     
problem.mp.time.t_max=[0 tf_1 ]; 
guess.mp.time=[0 tf_1 ];

% No. of parameters and decision variables
problem.mp.data.DecVar_Np=4;   % no, of Decision variables #Note that this wont affect the codes if the bounds need to be specific
problem.mp.data.OCV_Np=7;      % no. of polynomials
problem.mp.data.R0_SOC_Np=3;   
problem.mp.data.R0_i_Np=1;

problem.mp.data.Np_poly=problem.mp.data.OCV_Np+problem.mp.data.R0_SOC_Np+problem.mp.data.R0_i_Np;

% Parameters bounds. pl=< p <=pu
% Define Bounds of the parameters and Decision Variables
[problem.mp.parameters.pl, problem.mp.parameters.pu, guess.mp.parameters]=ParametersBounds(-200, 200, 0, 12000,problem.mp.data);

syms SOC current
syms p [1 problem.mp.data.OCV_Np+problem.mp.data.R0_SOC_Np+problem.mp.data.R0_i_Np] 
OCVModel=p(:,1);
for i=2:problem.mp.data.OCV_Np
    OCVModel=OCVModel+p(:,i).*SOC.^(i-1);
end
matlabFunction(OCVModel,"File","OCVModel","Vars",{p,SOC});

OCVModel_dSOC=p(:,2);
for i=3:problem.mp.data.OCV_Np
    OCVModel_dSOC=OCVModel_dSOC+(i-1)*p(:,i).*SOC.^(i-2);
end
matlabFunction(OCVModel_dSOC,"File","OCVModel_dSOC","Vars",{p,SOC});

R0Model=p(:,problem.mp.data.OCV_Np+1);
for i=2:problem.mp.data.R0_SOC_Np
    R0Model=R0Model+p(:,problem.mp.data.OCV_Np+i).*SOC.^(i-1);
end
for i=1:problem.mp.data.R0_i_Np
    R0Model=R0Model+p(:,problem.mp.data.OCV_Np+problem.mp.data.R0_SOC_Np+i).*current.^(i);
end
matlabFunction(R0Model,"File","R0Model","Vars",{p,SOC,current});

% Bounds for linkage boundary constraints bll =< bclink(x0,xf,u0,uf,p,t0,tf,vdat) =< blu
problem.mp.constraints.bll.linear=[];
problem.mp.constraints.blu.linear=[];
problem.mp.constraints.blTol.linear=[];

problem.mp.constraints.bll.nonlinear=[];
problem.mp.constraints.blu.nonlinear=[];
problem.mp.constraints.blTol.nonlinear=[];

% Get function handles
problem.mp.linkfunctions=@bclink;

% Store the necessary problem parameters used in the functions



% problem.mp.data.Q=15*60*60;
% problem.mp.data.R0=0.003;
% problem.mp.data.R1=0.002;
% problem.mp.data.C1=8000;
% problem.mp.data.batt_m=39e-03;
% problem.mp.data.batt_Cp=2025.737;
% problem.mp.data.batt_h=43.061;
% problem.mp.data.batt_A=3.714e-03;
% problem.mp.data.TempAmb=15;

% problem.mp.data.Q=2.0*60*60; %15*60*60l %10800
% problem.mp.data.R0=0.0012;%0.0163;  %0.0225;
% problem.mp.data.R1=0.003; %0.0221; %0.03;
% problem.mp.data.C1=8000;  %8000; %1000;
problem.mp.data.batt_m=46.8e-03;         %39e-03;
% problem.mp.data.batt_Cp=2025.737; 
problem.mp.data.batt_h=43.061;
problem.mp.data.batt_A=1.206e-03;        %3.714e-03;
problem.mp.data.TempAmb=25;

% Define different phases of OCP
[problem.phases{1},guess.phases{1}] = BatteryEstimation_Phase1_Charging(problem.mp, guess.mp);


phaseoptions{1}=problem.phases{1}.settings(80);


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

blc_linear=[];
blc_nonlinear=[];
%------------- END OF CODE --------------
