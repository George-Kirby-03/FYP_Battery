function [A,B,C,D] = TempModel(mCp,hA,Ts,aux)
% ODE function for computing state-space matrices as functions of parameters
A = [-hA/mCp];
B = [1/mCp];
C = eye(1);
D = [0];
end