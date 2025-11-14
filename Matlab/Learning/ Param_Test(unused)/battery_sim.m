time = [0 600];
soc=linspace(0,1,20);
cur = @(t) 0 * (t < 100) + -1 * (t >= 100 & t <450) +  0 * (t >= 450);
[t, x] = ode15s(@(t,y) battery_dynamics(t,y,5600,700,0.1,cur), time, [1 0]);
y = OCVModel(x(:,1)) + x(:,2) + 0.1*cur(t);
plot(t,y, t, cur(t))
