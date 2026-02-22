%Function to evaluate a current input, assumed to be ZOH until the next
%sample. dt and maxt of the simulation to be stated
function [tsim, isim, Vsim, Tsim, Pgensim] = DiscreteModel_Function(tsample,isample,dt,tmax,solution)

%% Initialise the input and range
%time range = maxk * dt
maxk = floor(tmax/dt);
p.T0 = 0;
p.Tamb = 30;
p.R0 = solution(end-3);
tsim = 0:dt:maxk*dt;
isim = interp1(tsample,isample,tsim,'previous');

[A, B] = discrit(solution,dt);
%% Initialise the model
%x_0 = [v1_0; z_0; dT_0];
x_disc = [0; 0; p.T0];

v1 = zeros(1,maxk+1);
z = zeros(1,maxk+1);
dT = zeros(1,maxk+1);
OCV = zeros(1,maxk+1);

v1(1) = x_disc(1);
z(1) = x_disc(2);
dT(1) = x_disc(3);
OCV(1) = OCVModel_Fmin(z(1));

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

    OCV(k+1) = OCVModel_Fmin(x_disc(2));

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