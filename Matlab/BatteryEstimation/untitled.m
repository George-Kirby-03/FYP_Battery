t = linspace(0,1,50);
soc_t = 3.64 + 0.55.*t -0.72.*t.^2 + 0.75.*t.^3;
plot(t, soc_t)
xlabel('Time (s)');
ylabel('State of Charge (SOC)');
title('State of Charge vs Time');
grid on