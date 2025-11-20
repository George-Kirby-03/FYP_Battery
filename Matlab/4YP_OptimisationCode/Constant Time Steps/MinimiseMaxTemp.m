% Code to minimise the maximum temperature of the cell whilst charging it
% to 80% SOC

% Using fmincon:
% x = fmincon(fun,x0,P,Q,Peq,Qeq):
% x = [(i[0],v1[1],z[1],dT[1]),(i[1],v1[2],z[2],dT[2]),...,(i[K-1],v1[K],z[K],dT[K])]' (4Kx1)
% fun = z[K] = c'*x
% x0 = initial x = zeros()
% P*x < Q
% Peq*x=Qeq

% Constraints to include
% Imin<I<Imax
% zmin<z<zmax (zmin = 0, zmax = 1)
% dt < dtmax
% Vmin<Vout<Vmax
% x[k+1] = Ax[k] + Bi[k] (x = [v1,z]')
% dT[k+1] = alpha*dT[K] + beta3*i[k]^2 + beta4*i[k]*v[k]

clear all
%% Define parameters
% Changeable parameters
tmax = 600; %If you change this remember to change nonlcon
kmax = 60;
p.dt = tmax/kmax;    %time step (s) (t=k*dt)

% State constraints
imax = 10000;
imin = 0;
zmax = 1;
zmin = 0;
dTmax = 10;

zfinal = 0.8;

% Model parameters
p.R0 = 0.0163;      %Ohms
p.R1 = 0.0221;      %Ohms
p.C1 = 15/p.R1;     %Farads
p.CellCap = 3960;   %As
p.Tamb = 30;        %degC

%Discrete state space parameters
p.lambda1 = 1/(p.R1*p.C1);
p.b1 = 1/p.C1;
p.b2 = 1/p.CellCap;

A = [exp(-p.lambda1*p.dt) 0; 0 1];
B = [p.b1/p.lambda1*(1-exp(-p.lambda1*p.dt)); p.b2*p.dt];

%% Constuct fmincon matrices
%% Peq*x=Qeq
% Equivalence, includes the discrete voltage model and final SOC constraint
% Initialise Peq as zeros, Qeq is just zeros
Peq = zeros(2*kmax,4*kmax);
Qeq = zeros(2*kmax,1);

% Set up matrices to be inserted in Peq
eq_mat_0 = [-B, eye(2)];
eq_mat = [-A, zeros(2,1), -B, eye(2)];

% First two rows are different to the rest so do those before loop
Peq(1:2,1:3) = eq_mat_0;

% Loop
for i = 2:kmax
    rows = 2*i-1:2*i;
    columns = 4*i-6:4*i-1;
    Peq(rows,columns) = eq_mat;
end

PZcon = zeros(1,4*kmax);
PZcon(1,4*kmax-1) = 1;

Peq = [Peq;PZcon];
Qeq = [Qeq;zfinal];

%% P*x < Q
%%% Positive I limits P1*x < Q1
Q1 = ones(kmax,1)*imax;

P1 = zeros(kmax,4*kmax);
% Loop
for i = 1:kmax
    rows = i;
    columns = 4*i-3;
    P1(rows,columns) = 1;
end

% Negative I limits P2*x < Q2
Q2 = ones(kmax,1)*imin;
P2 = -P1;

%%% Positive z limits P3*x < Q3
Q3 = ones(kmax,1)*zmax;

P3 = zeros(kmax,4*kmax);
% Loop
for i = 1:kmax
    rows = i;
    columns = 4*i-1;
    P3(rows,columns) = 1;
end

% Negative z limits P4*x < Q4
Q4 = ones(kmax,1)*zmin;
P4 = -P3;

%%% Positive dt limit
Q5 = ones(kmax,1)*dTmax;
P5 = zeros(kmax,4*kmax);
% Loop
for i = 1:kmax
    rows = i;
    columns = 4*i;
    P5(rows,columns) = 1;
end

%%% Construct P and Q
P = [P1;P2;P3;P4;P5];
Q = [Q1;Q2;Q3;Q4;Q5];

%% initial x, x0
x0 = zeros(4*kmax,1);
%x0=x;
%% Objective function, fun
C = zeros(4*kmax,1);
C(4:4:4*kmax,1) = 1;

fun = @(x)max(C.*x);

%% Optimise
options = optimoptions('fmincon','MaxFunctionEvaluations',1e10,'MaxIterations',1e10,'StepTolerance',1e-12);

tic
x = fmincon(fun,x0,P,Q,Peq,Qeq,[],[],@nonlconT,options);
toc

%% Extract i, v and z from x
i_optimal = [x(1:4:(4*kmax-3),1);0];
v1_optimal = [0;x(2:4:(4*kmax-2),1)];
z_optimal = [0;x(3:4:(4*kmax-1),1)];
dT_optimal = [0;x(4:4:(4*kmax),1)];
T_optimal = dT_optimal + p.Tamb;

Vout_optimal = v1_optimal + arrayfun(@OCV_Func2,z_optimal) + p.R0*i_optimal;

t = 0:p.dt:kmax*p.dt;

%% Save x just in case
writematrix(x,'x_latest.csv')

%% Simulate the current profile at a finer time step
[tsim, isim, Vsim, Tsim, Pgensim] = DiscreteModel_Function(t,i_optimal,0.001,tmax);

%% Plot graphs
% Plot Voltage graphs
VIplot(tsim,Vsim,isim)

%% Plot Temperature graphs
TPplot(tsim,Tsim,Pgensim)

Zstr = strcat({'Final SOC = '},num2str(max(z_optimal)));
disp(Zstr)

Tstr = strcat({'Peak temperature = '},num2str(max(Tsim)),{' degC'});
disp(Tstr)