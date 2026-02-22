function dx = dynamics(t, y, param, current_fun)
R0 = param.r0;
R1 = param.r1;
C = param.c;
Q = param.q;

current = current_fun(t);

if y(1) > 1
    dx1 = 0;
else
    dx1 = current./Q;
end
dx2 = -y(2)./(R1.*C) + current./C;

dx = [dx1; dx2];
end
