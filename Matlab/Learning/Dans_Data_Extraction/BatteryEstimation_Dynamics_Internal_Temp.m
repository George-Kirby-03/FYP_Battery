function [dx] = BatteryEstimation_Dynamics_Internal(x,u,p,t,vdat)
% Double Integrator Dynamics - Internal
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

SOC = x(:,1);V_RC1 = x(:,2); T = x(:,3);

% Take input measurement directly from Lookup table
current_bat = vdat.InputCurrent(t);

% Note the battery parameters are no longer saved in vdat, but as static
% decision variables of the optimisation solution
Q=p(:,vdat.poly.Q); 
%Q=2*3600;
C1=p(:,vdat.poly.C); R0=p(:,vdat.poly.R0); R1=p(:,vdat.poly.R1); 
hA = p(:,vdat.poly.A); mCp = p(:,vdat.poly.CP);

dx(:,1) = current_bat./Q;

dx(:,2) = -V_RC1./(R1.*C1) + current_bat./C1;

dx(:,3) = -(hA./mCp).*(T) + (R0./mCp).*(current_bat).^2 + 1./(mCp).*V_RC1.*current_bat;


%------------- END OF CODE --------------%