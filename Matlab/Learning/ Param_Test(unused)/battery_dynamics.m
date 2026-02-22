function dx = battery_dynamics(t, y, Q, C, R1, Current)
    x=y;
    I = Current(t);
    dx1 = I./Q;
    dx2 = -x(2)./(R1.*C) + I./C;
    dx = [dx1; dx2];
end
