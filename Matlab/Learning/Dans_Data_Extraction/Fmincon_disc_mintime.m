% Code to optimise a cells charge after a set number of steps
% Thermal model included

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
%% Load solution 

clear
clc
close all 
file = SolutionLoader("MOLI_28\",0);
cyc_no = regexp(file, '_(\d+)\.mat', 'tokens', 'once');
load(SolutionLoader("MOLI_28\",2))
solution = solution_unbound;
solution.p = [solution.p; 0.09; 120];
%% Define parameters
% Changeable parameters
tmax = 3000; %If you change this remember to change nonlcon
kmax = 10;
p.dt = tmax/kmax;    %time step (s) (t=k*dt)


%Inital conditions
v_init = 0;
z_init = 0;

% State constraints
imax = 10000;
imin = 0;
zmax = 1;
zmin = z_init;
dTmax = 20;
p.Tamb = 0;
p.R0 = solution.p(end-3);      %Ohms
Ts = p.dt;



%% Get A & B from discritisation function GK
%G.K
[A, B] = discrit(solution.p,Ts);
A = A(1:2,1:2);
B = B(1:2,1);
R0 = solution.p(end-3);
syms x1 
coef_length = length(solution.p) - 6;
ocv_func = 0;
for i = 1:coef_length
    ocv_func = ocv_func + solution.p(i) * x1.^(i-1);
end
matlabFunction(ocv_func, 'File', 'OCVModel_Fmin', 'Vars', {x1}); %Using this instead GK, can be
%used in non linear constraint file too


%% Constuct fmincon matrices
%% Peq*x=Qeq
% Equivalence, includes the discrete voltage model
% Initialise Peq as zeros, Qeq is just zeros
Peq = zeros(2*kmax,4*kmax);

%%Different now since inital conditions can not be assumed to be 0
%Qeq = zeros(2*kmax,1); 
Qeq = [A*[v_init; z_init]; zeros(2*kmax -2,1)];
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

%% Objective function, fun
C = zeros(4*kmax,1);
C(4*kmax-1,1) = -1;

fun = @(x)C'*x;

%% Optimise
options = optimoptions('fmincon','MaxFunctionEvaluations',1e10,'MaxIterations',1e10,'StepTolerance',1e-12);
[A, B] = discrit(solution.p,Ts);
tic
x = fmincon(fun,x0,P,Q,Peq,Qeq,[],[],@(x) nonlconT(x,A,B,R0),options);
toc

%% Extract i, v and z from x
i_optimal = [x(1:4:(4*kmax-3),1);0];
v1_optimal = [0;x(2:4:(4*kmax-2),1)];
z_optimal = [0;x(3:4:(4*kmax-1),1)];
dT_optimal = [0;x(4:4:(4*kmax),1)];
T_optimal = dT_optimal + p.Tamb;
% fix.poly.xe = zeros(params - 6,1);
Vout_optimal = v1_optimal + OCVModel_Fmin(z_optimal) + p.R0*i_optimal;

t = 0:p.dt:kmax*p.dt;

%% Save x just in case
% writematrix(x,'x_latest.csv')

%% Simulate the current profile at a finer time step
% [tsim, isim, Vsim, Tsim, Pgensim] = DiscreteModel_Function(t,i_optimal,0.001,tmax, solution.p);
%% GK: Using own discrete runner, more suitable for running batches and was more familiar + deals with non 0 SoC
time = linspace(0,tmax,400);
i_optimal_discrete = interp1(t,i_optimal,time,"previous");
[Tsim, Vsim] = discrit_solver(time,i_optimal_discrete,solution.p,z_init);
%% Plot graphs



%% Plot Temperature graphs

box on
f_size = 18;
color_two = [1,0,127/255]; 
color_one = [0.1,0.8,1]; 


yyaxis left
p1 = gca;
p1.YColor = color_one;  
plot(time,Vsim, 'color', color_one, 'linewidth', 3)
ylabel('Voltage','interpreter','latex','fontsize',f_size);
yyaxis right
p2 = gca;
p2.YColor = color_two; 
plot(time,Tsim, 'color', color_two, 'linewidth', 3)
ylabel('Temperature','interpreter','latex','fontsize',f_size);

xlabel('Time','interpreter','latex','fontsize',f_size);
title('\textbf{Minimising Charge Time}','interpreter','latex','fontsize',f_size+2);

figure
hold on
stairs(t,i_optimal)
stairs(t,dT_optimal)
plot(time,i_optimal_discrete)
Zstr = strcat({'Final SOC = '},num2str(max(z_optimal)));
disp(Zstr)
Tstr = strcat({'Peak temperature = '},num2str(max(Tsim)),{' degC'});
disp(Tstr)
Tstr = strcat('Peak temperature = ',num2str(max(Tsim)),{' degC'});
disp(Tstr)

[tsim, isim, Vsim, Tsim, Pgensim] = DiscreteModel_Function(t,i_optimal,0.1,tmax,solution.p);
VIplot(tsim,Vsim,isim)
yyaxis left
plot([0,tmax],[3.6,3.6],'--','Color','#0072BD','linewidth',1.5)
axis([0,tmax,2.2,4.3])
box on
yyaxis right
axis([0,tmax,0,20])

%% Plot Temperature graphs
TPplot(tsim,Tsim,Pgensim)
box on
yyaxis left
plot([0,tmax],[dTmax+p.Tamb,dTmax+p.Tamb],'--','Color','#EDB120','linewidth',1.5)
axis([0 600 p.Tamb dTmax+p.Tamb+3])
yyaxis right


Zstr = strcat({'Final SOC = '},num2str(max(z_optimal)));
disp(Zstr)

Tstr = strcat({'Peak temperature = '},num2str(max(Tsim)),{' degC'});
disp(Tstr)