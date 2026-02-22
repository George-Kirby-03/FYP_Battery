function dx = Temp_dynamics(t, y, param, current_fun)
R0 = param.r0;
R1 = param.r1;
h = param.h;
A = param.A;
m = param.m;
Cp = param.Cp;
current = current_fun(t);
w = (R0+R1)*current.^2;
dx = [-(h*A/(m*Cp))*y + w/(m*Cp)];
end
