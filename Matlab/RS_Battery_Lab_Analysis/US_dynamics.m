function dx = US_dynamics(t, y, param, current_fun)
R0 = param.r0;
R1 = param.r1;
C = param.c;
Q = param.q;
v_ulim = param.vu;
v_llim = param.vl;
current = current_fun(t);
ocv_curve = param.ocv;
dx3 = 0;
v= polyval(ocv_curve, y(1)) + y(2) + R0.*current;
%% Below conditions to ensure unsafe voltages not reached 
if (v < v_llim) && current < 0
    current = 0;
    dx3 = 1;
    dx1 = 0;
end
if (v >= v_ulim) && current > 0
    current = 0;
    dx3 = 1;
end

dx1 = current./Q;
dx2 = -y(2)./(R1.*C) + current./C;

dx = [dx1; dx2; dx3;];
end
