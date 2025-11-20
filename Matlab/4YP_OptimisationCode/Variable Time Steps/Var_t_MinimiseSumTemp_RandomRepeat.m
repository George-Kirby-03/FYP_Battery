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
kmax = 8;
% p.dt = tmax/kmax;    %time step (s) (t=k*dt)
noCycles = 2500;

% State constraints
imax = 10000;
imin = 0;
zmax = 1;
zmin = 0;
dTmax = 4.5;
zfinal = 0.8;   %Be sure to change in nonlcon

% % Model parameters
% p.R0 = 0.0163;      %Ohms
% p.R1 = 0.0221;      %Ohms
% p.C1 = 15/p.R1;     %Farads
p.CellCap = 3960;   %As
% p.Tamb = 30;        %degC
% 
% %Discrete state space parameters
% p.lambda1 = 1/(p.R1*p.C1);
% p.b1 = 1/p.C1;
% p.b2 = 1/p.CellCap;
% 
% A = [exp(-p.lambda1*p.dt) 0; 0 1];
% B = [p.b1/p.lambda1*(1-exp(-p.lambda1*p.dt)); p.b2*p.dt];

%% Constuct fmincon matrices
%% Peq*x=Qeq
% Equivalence, the  final SOC constraint
PZcon = zeros(1,4*kmax);
PZcon(1,4*kmax-1) = 1;

Peq = PZcon;
Qeq = zfinal;

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

%%% Positive dT limit
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

%% Optimise over a number of cycles with random starting points

%xold = load('x_latest.csv');

% Objective function, fun
C = zeros(4*kmax,1);
C(4:4:4*kmax,1) = 1;
fun = @(x)sum(C.*x);
options = optimoptions('fmincon','MaxFunctionEvaluations',1e10,'MaxIterations',1e10,'StepTolerance',1e-12,'EnableFeasibilityMode',true);

m=0;
warning('off','MATLAB:nearlySingularMatrix')
tic
for n = 1:noCycles
    n
    % initial x, x0
    x0 = zeros(4*kmax,1);
    %Set currents to random values
    x0(1:4:(4*kmax-3),1) = rand(kmax,1).*10;%zfinal*p.CellCap/tmax;
    
    %tic
    [x,fval,exitflag] = fmincon(fun,x0,P,Q,Peq,Qeq,[],[],@nonlconT_vart,options);
    %toc
    [c,ceq] = nonlconT_vart(x);
    
    if n==1
        xbest=x;
        ObjectiveFuncVector=fval;
    end

    if exitflag>0
        m=m+1;
        ObjectiveFuncVector(m,1) = fval;
        if fval<fun(xbest)
            xbest=x;
        end
    end
end
toc
%%
%disp(fun(xold))
disp(fun(xbest))
x=xbest;

%% Extract i, v and z from x
i_optimal = [x(1:4:(4*kmax-3),1);0];
v1_optimal = [0;x(2:4:(4*kmax-2),1)];
z_optimal = [0;x(3:4:(4*kmax-1),1)];
dT_optimal = [0;x(4:4:(4*kmax),1)];

p.Tamb = 30;        %degC
p.R0 = 0.0163;      %Ohms

T_optimal = dT_optimal + p.Tamb;
Vout_optimal = v1_optimal + arrayfun(@OCV_Func2,z_optimal) + p.R0*i_optimal;

dt_optimal = zfinal/kmax*p.CellCap./x(1:4:(4*kmax-3),1);
t = [0;cumsum(dt_optimal)];

%% Save x just in case
writematrix(x,'x_latest.csv')
writematrix(ObjectiveFuncVector,'ObjectiveFuncVector_latest.csv')

%% Simulate the current profile at a finer time step
[tsim, isim, Vsim, Tsim, Pgensim] = DiscreteModel_Function(t,i_optimal,0.001,tmax);

%% Plot graphs
% Plot Voltage graphs
VIplot(tsim,Vsim,isim)
yyaxis left
plot([0,600],[3.6,3.6],'--','Color','#0072BD','linewidth',1.5)
axis([0,600,min(Vsim),3.65])
yyaxis right
axis([0,600,0,ceil(max(isim))])
grid on

%% Plot Temperature graphs
TPplot(tsim,Tsim,Pgensim)
yyaxis left
plot([0,600],[max(Tsim),max(Tsim)],'--','Color','#EDB120','linewidth',1.5)
grid on
yyaxis right
axis([0,600,0,ceil(max(Pgensim)*10)/10])

Zstr = strcat({'Final SOC = '},num2str(max(z_optimal)));
disp(Zstr)
Tstr = strcat({'Peak temperature = '},num2str(max(Tsim)),{' degC'});
disp(Tstr)

%% Plot Boxchart of the optimal values
figure('Renderer', 'painters', 'Position', [0 42 500 740])
boxchart(ObjectiveFuncVector)
ylabel('Sum Of $\Delta T$','fontSize',16,'interpreter','latex')