function [c,ceq] = nonlconT(x, A, B, R0)
%Same as before but also constraint on the output voltage the instant
%before hand (V1[k] + OCV(z[k]) + R0*I[k-1] =< 3.6)

% Need to use a non-linear condition to put the constraints on Vout and the
% OCV(z). Kmax = 60
tmax = 3000;

%Voutmax = 4.2;   Now taking the Max voltatage to be the ocv(1), since this
%was causing SoC to be limited (i hope so atleast)
Voutmax = OCVModel_Fmin(1);
Voutmin = OCVModel_Fmin(0);
kmax = size(x,1)/4;
p.dt = tmax/kmax;

p.R0 = R0;

alpha = A(end,end);
beta3 = B(3,2);
beta4 = B(3,3);

%% c(x) <= 0 for all entries of c.
c1 = zeros(kmax+1,1);
c1(1,1) = p.R0*x(1);
c1(kmax+1,1) = x(4*kmax-2) + OCVModel_Fmin(x(4*kmax-1));

for i = 2:kmax
    c1(i,1) = x(4*i-6) + OCVModel_Fmin(x(4*i-5)) + p.R0*x(4*i-3);
end

c2 = -c1;
c2 = c2 - Voutmin;
c1 = c1 - Voutmax;

% Instant before constraint
c3 = zeros(kmax,1);
for i = 1:kmax
    c3(i,1) = p.R0*x(4*i-3) + x(4*i-2) + OCVModel_Fmin(x(4*i-1));
end

c4 = -c3;
c4 = c4 - Voutmin;
c3 = c3 - Voutmax;

c = [c1;c2;c3;c4];

%% ceq(x) = 0 for all entries of ceq.
% Thermal model included here
ceq = zeros(kmax,1);

ceq(1,1) = x(4) - beta3*x(1)^2;
for j = 2:kmax
    ceq(j,1) = x(4*j) - alpha*x(4*j-4) - beta3*x(4*j-3)^2 - beta4*x(4*j-6)*x(4*j-3);
end







