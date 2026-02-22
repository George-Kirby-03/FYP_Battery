%Function to evaluate a current input, assumed to be ZOH until the next
%sample. dt and maxt of the simulation to be stated
function [tsim, isim, Vsim, Tsim, Pgensim] = DiscreteModel_Function(tsample,isample,dt,tmax)

%% Initialise the input and range
%time range = maxk * dt
maxk = floor(tmax/dt);

tsim = 0:dt:maxk*dt;
isim = interp1(tsample,isample,tsim,'previous');

%% Initialise the model and parameters
% Import parameters in a structure p
p.R0 = 0.0163;      %Ohms
p.R1 = 0.0221;      %Ohms
p.C1 = 15/p.R1;     %Farads
p.CellCap = 3960;   %As
p.m = 39e-3;        %kg
p.A = 3.714e-3;     %m^2
p.cp = 2025.73730007848; %J/kgK
p.h = 43.0609859109025;  %W/Km^2
p.T0 = 30;          %degC
p.Tamb = 30;        %degC

%Further organise into elements of the continuous state space model
lambda1 = 1/(p.R1*p.C1);
lambda2 = (p.h*p.A)/(p.m*p.cp);
b1 = 1/p.C1;
b2 = 1/p.CellCap;
b3 = p.R0/(p.m*p.cp);
b4 = 1/(p.m*p.cp);

% Organise parameters into discrete state space matrices
% x[k+1] = Ax[k] + Bu[k]
% x[k] = (v1[k]; z[k]; dT[k])
% u[k] = (i[k]; i[k]^2; i[k]v[k])

alpha1 = (b3/lambda2 + (b1*b4)/(lambda1*lambda2))*(1-exp(-lambda2*dt)) - b1*b4/(lambda1*(lambda2-lambda1))*(exp(-lambda1*dt)-exp(-lambda2*dt));
alpha2 = b4/(lambda2-lambda1) * (exp(-lambda1*dt)-exp(-lambda2*dt));

A = [exp(-lambda1*dt) 0 0;
    0 1 0;
    0 0 exp(-lambda2*dt)];

B = [b1/lambda1*(1-exp(-lambda1*dt)) 0 0;
    b2*dt 0 0;
    0 alpha1 alpha2];

%% Initialise the model
%x_0 = [v1_0; z_0; dT_0];
x_disc = [0; 0; p.T0-p.Tamb];

v1 = zeros(1,maxk+1);
z = zeros(1,maxk+1);
dT = zeros(1,maxk+1);
OCV = zeros(1,maxk+1);

v1(1) = x_disc(1);
z(1) = x_disc(2);
dT(1) = x_disc(3);
OCV(1) = OCV_Func2(z(1));

%Intialise the input
u = [isim(1); isim(1)^2; 0];

% Begin simulation
%disp('Simulation Started')
for k=1:maxk

    %Update state
    x_disc = A*x_disc + B*u;

    %Update recordings
    v1(k+1) = x_disc(1);
    z(k+1) = x_disc(2);
    dT(k+1) = x_disc(3);

    OCV(k+1) = OCV_Func2(x_disc(2));

    %Update input
    u = [isim(k+1); isim(k+1)^2; isim(k+1)*x_disc(1)];
end

%Create vector of v0
v0 = p.R0*isim;
%Vector of Vout
Vsim = OCV + v0 + v1;

%Create vector of T
Tsim = p.Tamb + dT;

VR = v0 + v1;
Pgensim = abs(isim.*VR);

%disp('Simulation Finished')