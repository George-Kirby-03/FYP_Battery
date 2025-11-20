function [c,ceq] = nonlconT_vart(x)
%Same as before but also constraint on the output voltage the instant
%before hand (V1[k] + OCV(z[k]) + R0*I[k-1] =< 3.6)

% Need to use a non-linear condition to put the constraints on Vout and the
% OCV(z). Kmax = 60
tmax = 600;

Voutmax = 3.6;
Voutmin = 0;
kmax = size(x,1)/4;
zfinal = 0.8;
prop = zfinal/kmax; %Proportion of SOC each step charges
%p.dt = tmax/kmax;

p.R0 = 0.0163;      %Ohms
p.R1 = 0.0221;      %Ohms
p.C1 = 15/p.R1;     %Farads
p.CellCap = 3960;   %As
p.m = 39e-3;        %kg
p.A = 3.714e-3;     %m^2
p.cp = 2025.73730007848;        %J/kgK
p.h = 43.0609859109025;         %W/Km^2

lambda1 = 1/(p.R1*p.C1);
lambda2 = (p.h*p.A)/(p.m*p.cp);
b1 = 1/p.C1;
b2 = 1/p.CellCap;
b3 = p.R0/(p.m*p.cp);
b4 = 1/(p.m*p.cp);

dt_vector = prop*p.CellCap./x(1:4:(4*kmax-3),1);

%% c(x) <= 0 for all entries of c.
c1 = zeros(kmax+1,1);
c1(1,1) = p.R0*x(1);
c1(kmax+1,1) = x(4*kmax-2) + OCV_Func2(x(4*kmax-1));

for i = 2:kmax
    c1(i,1) = x(4*i-6) + OCV_Func2(x(4*i-5)) + p.R0*x(4*i-3);
end

c2 = -c1;
c2 = c2 - Voutmin;
c1 = c1 - Voutmax;

% Instant before constraint
c3 = zeros(kmax,1);
for i = 1:kmax
    c3(i,1) = p.R0*x(4*i-3) + x(4*i-2) + OCV_Func2(x(4*i-1));
end

c4 = -c3;
c4 = c4 - Voutmin;
c3 = c3 - Voutmax;

c = [c1;c2;c3;c4];

%% ceq(x) = 0 for all entries of ceq.
% Thermal model included here
ceq_temp = zeros(kmax,1);

p.dt = dt_vector(1);
beta3 = (b3/lambda2 + (b1*b4)/(lambda1*lambda2))*(1-exp(-lambda2*p.dt)) - b1*b4/(lambda1*(lambda2-lambda1))*(exp(-lambda1*p.dt)-exp(-lambda2*p.dt));
ceq_temp(1,1) = x(4) - beta3*x(1)^2;
for j = 2:kmax
    p.dt = dt_vector(j);
    alpha = exp(-lambda2*p.dt);
    beta3 = (b3/lambda2 + (b1*b4)/(lambda1*lambda2))*(1-exp(-lambda2*p.dt)) - b1*b4/(lambda1*(lambda2-lambda1))*(exp(-lambda1*p.dt)-exp(-lambda2*p.dt));
    beta4 = b4/(lambda2-lambda1) * (exp(-lambda1*p.dt)-exp(-lambda2*p.dt));
    ceq_temp(j,1) = x(4*j) - alpha*x(4*j-4) - beta3*x(4*j-3)^2 - beta4*x(4*j-6)*x(4*j-3);
end

%% Include the Voltage Model
% Initialise Peq as zeros, Qeq is just zeros
Peq = zeros(2*kmax,4*kmax);
Qeq = zeros(2*kmax,1);

p.dt = dt_vector(1);
B = [b1/lambda1*(1-exp(-lambda1*p.dt)); b2*p.dt];
% Set up matrices to be inserted in Peq
eq_mat_1 = [-B, eye(2)];
% First two rows are different to the rest so do those before loop
Peq(1:2,1:3) = eq_mat_1;

% Loop
for i = 2:kmax
    p.dt = dt_vector(i);
    A = [exp(-lambda1*p.dt) 0; 0 1];
    B = [b1/lambda1*(1-exp(-lambda1*p.dt)); b2*p.dt];
    eq_mat = [-A, zeros(2,1), -B, eye(2)];
    rows = 2*i-1:2*i;
    columns = 4*i-6:4*i-1;
    Peq(rows,columns) = eq_mat;
end

ceq_voltage = Peq*x-Qeq;

% Constrain the sum of time steps
ceq_time = sum(dt_vector)-tmax;

ceq = [ceq_temp;ceq_voltage;ceq_time];