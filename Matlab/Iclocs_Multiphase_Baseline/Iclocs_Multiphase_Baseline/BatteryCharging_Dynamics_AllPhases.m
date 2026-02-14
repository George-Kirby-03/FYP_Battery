
function [dx,g_neq] = BatteryCharging_Dynamics_AllPhases(x,u,p,t,vdat)
%Double Integrator Dynamics
%
% Syntax:  
%          [dx] = Dynamics(x,u,p,t,vdat)	(Dynamics Only)
%          [dx,g_eq] = Dynamics(x,u,p,t,vdat)   (Dynamics and Eqaulity Path Constraints)
%          [dx,g_neq] = Dynamics(x,u,p,t,vdat)   (Dynamics and Inqaulity Path Constraints)
%          [dx,g_eq,g_neq] = Dynamics(x,u,p,t,vdat)   (Dynamics, Equality and Ineqaulity Path Constraints)
% 
% Inputs:
%    x  - state vector
%    u  - input
%    p  - parameter
%    t  - time
%    vdat - structured variable containing the values of additional data used inside
%          the function%      
% Output:
%    dx - time derivative of x
%    g_eq - constraint function for equality constraints
%    g_neq - constraint function for inequality constraints
%
% Copyright (C) 2019 Yuanbo Nie, Omar Faqir, and Eric Kerrigan. All Rights Reserved.
% The contribution of Paola Falugi, Eric Kerrigan and Eugene van Wyk for the work on ICLOCS Version 1 (2010) is kindly acknowledged.
% This code is published under the MIT License.
% Department of Aeronautics and Department of Electrical and Electronic Engineering,
% Imperial College London London  England, UK 
% ICLOCS (Imperial College London Optimal Control) Version 2.5 
% 1 Aug 2019
% iclocs@imperial.ac.uk
%
%------------- BEGIN CODE --------------

x1 = x(:,1);x2 = x(:,2);x3=x(:,3);u1 = p(:,vdat.iPhase);

dx(:,1) = u1./vdat.mp.Q;

dx(:,2) = -x2./(vdat.mp.R1*vdat.mp.C1)+u1./vdat.mp.C1;

dx(:,3) = 1./(vdat.mp.batt_m*vdat.mp.batt_Cp).*(u1.^2*(vdat.mp.R0+vdat.mp.R1)-vdat.batt_h*vdat.mp.batt_A*(x3-vdat.mp.TempAmb));



%g_neq=3.64+0.55*x1-0.72*x1.^2+0.75*x1.^3+x2+vdat.mp.R0*u1;
g_neq= [polyval(vdat.ocvpoly,x1)+x2+vdat.mp.R0*u1 x3-p(:,end)]; %Simpler poly that used in other simulations, charging shouldnt be hitting the Vout Limit anyways to 80% SoC
%g_neq= [polyval(vdat.ocvpolytucke+x2+vdat.mp.R0*u1 x3-p(:,end)];
%------------- END OF CODE --------------