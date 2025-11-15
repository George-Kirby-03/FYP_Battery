function xn = discrit(u,xk,params,Ts)
size = length(params);
R1 = params.ic(size);
R0 = params.ic(size-1);
C = params.ic(size-2);
Q = params.ic(size-3);
l1 = 1/(R1*C);
l1 = -
end