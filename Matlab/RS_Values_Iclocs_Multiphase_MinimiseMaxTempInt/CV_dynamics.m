function dx = CV_dynamics(t, y, param)
R0 = param.r0;
R1 = param.r1;
C = param.c;
Q = param.q;
v_ulim = param.vu;
v_llim = param.vl;
ocv_curve = param.ocv;

current = (v_ulim - ocv_curve(y(1)) - y(2))./R0;

dx1 = current./Q;
dx2 = -y(2)./(R1.*C) + current./C;
dx3 = 0;
dx = [dx1; dx2; dx3;];
end
