
function [dx] = BatteryCharging_Dynamics_Sim(x,u,p,t,vdat)
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

x1 = x(:,1);x2 = x(:,2);x3=x(:,3);x4=x(:,4);x5=x(:,5);u1 = u; 

dx(:,1) = u1./vdat.Q;

dx(:,2) = -x2./(vdat.R1*vdat.C1)+u1./vdat.C1;

dx(:,3) = 1./(vdat.batt_m*vdat.batt_Cp).*(u1.^2*(vdat.R0+vdat.R1)-vdat.batt_h*vdat.batt_A*(x3-vdat.TempAmb));

dx(:,4) = u1/3600;



T=x3+273;
% I_Crate= I/3600.*vdat.Q/3600;
% Bcyc = 3.16e3;  
% Ecyc = 3.17e4; alpha = 370.3; R = 8.3144; zcyc = 0.55;
Ea=25000;
z=0.54;
R=8.341;
B=0.1614;

dx(:,5) = B*exp(-Ea./R./T).*x4.^z.*(Ea/R*dx(:,3)./(T.^2)+z*dx(:,4)./x4);
% dx(:,5) = x4.*(Ea/R*dx(:,3)./(T.^2)+z*dx(:,4)./x4);

%------------- END OF CODE --------------