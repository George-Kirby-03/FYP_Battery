func_lut = @(y) sin(y);  % example
C=20
R1=0.05
R2=0.03
[t, y] = ode45(@(t, y) dynamics(t, y, C, R1, R2, func_lut), [0 50], 0);

figure
plot(t,y)