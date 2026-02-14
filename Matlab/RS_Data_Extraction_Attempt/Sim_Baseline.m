clear

p.r1 = 0.07;
p.r0 = 0.16- p.r1;
p.c = 300;
p.q = 1.53*60*60;
p.vu = polyval(ocv_curve,1);
p.vl = polyval(ocv_curve,0);
p.ocv = ocv_curve;
R0 = p.r0;
R1 = p.r1;
Curr = p.q/(60^2);

Cl = linspace(-4,-0.5,15)';
hrl = linspace(0.1,1.5,7)';
socl = ones(10,7);

op = ocv_curve;
f = @(x) polyval(op, x) - y(1);
init = fzero(f, 0.8);