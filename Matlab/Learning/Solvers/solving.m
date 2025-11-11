cd(fileparts(which('Solving.m')))
pwd
load('..\Fixed_Poly\DS_DATA.mat')
load('..\LiPO_Parameter_Estimation\Data\cycle_1.mat')

current_lut = @(t) interp1(tt, u1, t, 'linear', 'extrap');
% p(12)= 2*p(12); % the problem from before was the soc went negative, and then the ocv went went. it's not used to fitting for negative soc. 
[t, y] = ode45(@(t, y) dynamics(t, y, p, current_lut), [0 tt(end)], [1; -0.10]);

x1=y(:,1);x2=y(:,2); R0 = p(end-1);
u2=current_lut(t);
polyss = flip(p(1:end-4));
voltage_model=polyval(polyss,x1) + x2 + R0.*u2;



figure

plot(t,voltage_model)
hold on
