function [problem,guess] = BatteryEstimation
%DoubleIntergratorTracking - Double Integrator Tracking Problem
%
% Syntax:  [problem,guess] = DoubleIntergratorTracking
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

% Load the measurement from Data (George Kirby FYP)
cd(fileparts(which('BatteryEstimation.m')))
load("DS_DATA.mat")

p_res = 13;
coef = polyfit(Base_OCV.x, Base_OCV.y, p_res);
coef = fliplr(coef);

syms x1 
ocv_func = 0;
for i = 1:p_res+1
    ocv_func = ocv_func + coef(i) * x1.^(i-1);
end
matlabFunction(ocv_func, 'File', 'OCVModel', 'Vars', {x1});


%adding initial resting condition fudge to maybe help paramtereisation
padding = linspace(0,1000,45)'
[padding_size, ~] = size(padding)
tt = [padding; C01_Discharge.("time") + 1001];
u1 = [zeros(padding_size,1); -1.5 * 0.1 * ones(size(tt))];  
y  = [ones(padding_size,1).*C01_Discharge.volts(1); C01_Discharge.volts];
[tt, ia] = unique(tt, 'stable');
y  = y(ia);
u1 = u1(ia);
[tt, sortIdx] = sort(tt);
y  = y(sortIdx);
u1 = u1(sortIdx);
problem.data.OutputVoltage = griddedInterpolant(tt, y, 'pchip');
problem.data.InputCurrent  = griddedInterpolant(tt, u1, 'pchip');


%------------- BEGIN CODE --------------
% Plant model name, used for Adigator
InternalDynamics=@BatteryEstimation_Dynamics_Internal;
SimDynamics=@BatteryEstimation_Dynamics_Sim;

% Analytic derivative files (optional)
problem.analyticDeriv.gradCost=[];
problem.analyticDeriv.hessianLagrangian=[];
problem.analyticDeriv.jacConst=[];

% Settings file
problem.settings=@settings_BatteryEstimation;


%Initial Time. t0<tf
problem.time.t0_min=0;
problem.time.t0_max=0;
guess.t0=0;

% Final time. Let tf_min=tf_max if tf is fixed.
problem.time.tf_min=tt(end);     
problem.time.tf_max=tt(end); 
guess.tf=tt(end);

% Parameters bounds. pl=< p <=pu
% These are unknown parameters to be estimated in this Battery estimation problem
% p=[Q C1 R1]
problem.parameters.pl=[1.4*3600 100 0.01];
problem.parameters.pu=[2*3600 30000 0.04];
guess.parameters=[1.5*3600 700 0.03];


% Initial conditions for system.
problem.states.x0=[1 0];

% Initial conditions for system. Bounds if x0 is free s.t. x0l=< x0 <=x0u
problem.states.x0l=[0.9 0]; 
problem.states.x0u=[1 0]; 

% State bounds. xl=< x <=xu
problem.states.xl=[0 -0.02];
problem.states.xu=[1 0];

% State error bounds
problem.states.xErrorTol_local=[1e-6 1e-6];
problem.states.xErrorTol_integral=[1e-6 1e-6];


% State constraint error bounds
problem.states.xConstraintTol=[1e-5 1e-5];

% Terminal state bounds. xfl=< xf <=xfu
problem.states.xfl=[0 -0.1];
problem.states.xfu=[0.01 -0.005];

% Guess the state trajectories with [x0 xf]
guess.states(:,1)=[1 0];
guess.states(:,2)=[0 -0.01];


% Number of control actions N 
% Set problem.inputs.N=0 if N is equal to the number of integration steps.  
% Note that the number of integration steps defined in settings.m has to be divisible 
% by the  number of control actions N whenever it is not zero.
problem.inputs.N=0;       
      
% The input here is redundent (as it is directly measured)
% Input bounds
problem.inputs.ul=0;
problem.inputs.uu=0;

% Bounds on the first control action
problem.inputs.u0l=0;
problem.inputs.u0u=0;

% Input constraint error bounds
problem.inputs.uConstraintTol=[0.01];

% Guess the input sequences with [u0 uf]
guess.inputs(:,1)=[-0.15 -0.15];



% Choose the set-points if required
problem.setpoints.states=[];
problem.setpoints.inputs=[];

% Bounds for path constraint function gl =< g(x,u,p,t) =< gu
problem.constraints.ng_eq=0;
problem.constraints.gTol_eq=[];


problem.constraints.gl=[];
problem.constraints.gu=[];
problem.constraints.gTol_neq=[];

% Bounds for boundary constraints bl =< b(x0,xf,u0,uf,p,t0,tf) =< bu
problem.constraints.bl=[];
problem.constraints.bu=[];
problem.constraints.bTol=[];



% store the necessary problem parameters used in the functions

%Some known parameters
problem.data.batt_m=15e-03;

% Get function handles and return to Main.m
problem.data.InternalDynamics=InternalDynamics;
problem.data.functionfg=@fg;
problem.data.plantmodel = func2str(InternalDynamics);
problem.functions={@L,@E,@f,@g,@avrc,@b};
problem.sim.functions=SimDynamics;
problem.sim.inputX=[];
problem.sim.inputU=1:length(problem.inputs.ul);
problem.functions_unscaled={@L_unscaled,@E_unscaled,@f_unscaled,@g_unscaled,@avrc,@b_unscaled};
problem.data.functions_unscaled=problem.functions_unscaled;
problem.data.ng_eq=problem.constraints.ng_eq;
problem.constraintErrorTol=[problem.constraints.gTol_eq,problem.constraints.gTol_neq,problem.constraints.gTol_eq,problem.constraints.gTol_neq,problem.states.xConstraintTol,problem.states.xConstraintTol,problem.inputs.uConstraintTol,problem.inputs.uConstraintTol];

%------------- END OF CODE --------------

function stageCost=L_unscaled(x,xr,u,ur,p,t,vdat)

% L_unscaled - Returns the stage cost.
% The function must be vectorized and
% xi, ui are column vectors taken as x(:,i) and u(:,i) (i denotes the i-th
% variable)
% 
% Syntax:  stageCost = L(x,xr,u,ur,p,t,data)
%
% Inputs:
%    x  - state vector
%    xr - state reference
%    u  - input
%    ur - input reference
%    p  - parameter
%    t  - time
%    data- structured variable containing the values of additional data used inside
%          the function
%
% Output:
%    stageCost - Scalar or vectorized stage cost
%
%  Remark: If the stagecost does not depend on variables it is necessary to multiply
%          the assigned value by t in order to have right vector dimesion when called for the optimization. 
%          Example: stageCost = 0*t;

%------------- BEGIN CODE --------------

x1=x(:,1);x2=x(:,2);R1=p(:,3);
R0 = 0.065-R1;
% Obtain the measured input from the Lookup Table
u1=vdat.InputCurrent(t);

% Obtain the measured output voltage from the Lookup Table
voltage_measured=vdat.OutputVoltage(t);

% Compute the output voltage of the Model
voltage_model= OCVModel(x1) + x2 + R0.*u1;
% voltage_model=poly
% Compute the stage cost as the difference squared (try to make the output
% voltage of the model match the measurement, for the same input)
stageCost = (voltage_model-voltage_measured).^2;

%------------- END OF CODE --------------


function boundaryCost=E_unscaled(x0,xf,u0,uf,p,t0,tf,data) 

% E_unscaled - Returns the boundary value cost
%
% Syntax:  boundaryCost=E_unscaled(x0,xf,u0,uf,p,t0,tf,data) 
%
% Inputs:
%    x0  - state at t=0
%    xf  - state at t=tf
%    u0  - input at t=0
%    uf  - input at t=tf
%    p   - parameter
%    tf  - final time
%    data- structured variable containing the values of additional data used inside
%          the function
%
% Output:
%    boundaryCost - Scalar boundary cost
%
%------------- BEGIN CODE --------------

boundaryCost=0;

%------------- END OF CODE --------------


function bc=b_unscaled(x0,xf,u0,uf,p,t0,tf,vdat,varargin)

% b_unscaled - Returns a column vector containing the evaluation of the boundary constraints: bl =< bf(x0,xf,u0,uf,p,t0,tf) =< bu
%
% Syntax:  bc=b_unscaled(x0,xf,u0,uf,p,t0,tf,vdat,varargin)
%
% Inputs:
%    x0  - state at t=0
%    xf  - state at t=tf
%    u0  - input at t=0
%    uf  - input at t=tf
%    p   - parameter
%    tf  - final time
%    data- structured variable containing the values of additional data used inside
%          the function
%
%          
% Output:
%    bc - column vector containing the evaluation of the boundary function 
%
%------------- BEGIN CODE --------------
varargin=varargin{1};
bc=[];
%------------- END OF CODE --------------
% When adpative time interval add constraint on time
%------------- BEGIN CODE --------------
if length(varargin)==2
    options=varargin{1};
    t_segment=varargin{2};
    if ((strcmp(options.discretization,'hpLGR')) || (strcmp(options.discretization,'globalLGR')))  && options.adaptseg==1 
        if size(t_segment,1)>size(t_segment,2)
            bc=[bc;diff(t_segment)];
        else
            bc=[bc,diff(t_segment)];
        end
    end
end

%------------- END OF CODE --------------
%