function [A,B,C,D,K,X0] = TempFnc(par,Ts,varargin)

%% Parameters

mCp = par(1);
hA  = par(2);

%% State Space Model
%
%   mCp*dT/dt = Q - hA*T
%

A = -hA/mCp;

B = 1/mCp;

C = 1;

D = 0;

%% Noise Matrix
K = 0;

%% Initial State
X0 = 0;

end