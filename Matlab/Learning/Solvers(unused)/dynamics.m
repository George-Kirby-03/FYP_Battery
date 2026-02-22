function dx = dynamics(t, y, param, current_fun)

R1 = param.r1;
C = param.c;
Q = param.q;
current = current_fun(t);

%% Below conditions to ensure unsafe voltages not reached 
if y(1) <=0.01 && current< 0
    current = 0;
end

if y(1) >=1 && current> 0
    current = 0;
end

dx(1) = current./Q;
dx(2) = -y(2)./(R1.*C) + current./C;
end
