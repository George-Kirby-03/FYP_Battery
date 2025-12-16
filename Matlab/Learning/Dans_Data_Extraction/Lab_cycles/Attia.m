% ocv_curve_T = cell(30,1);
% 
% figure
% hold on
% 
% for i = 10:30
%     ocv_curve_T{i} = polyfit(p01C_Curve.z, p01C_Curve.y, i);
%     plot(p01C_Curve.z, polyval(ocv_curve_T{i}, p01C_Curve.z))
% end
% 
% legend("Degree " + string(10:30), 'Location', 'best')


pwd
clear
load('RS_Params.mat')

% p.r1 = CROR1(end);
% p.r0 = CROR1(2);
% p.c = CROR1(1);
% p.r1 = 0.03;
% p.r0 = 0.035;
% p.c = 120;
% p.r1 = 0.07;
% p.r0 = 0.163 - p.r1;
p.r1 = 0.03;
p.r0 = 0.075 - p.r1;
p.c = 289;
p.q = 1.53*60*60;

p.ocv = ocv_curve_2;
p.vu = polyval(p.ocv,1);
p.vl = polyval(p.ocv,0);
R0 = p.r0;
R1 = p.r1;
Curr = p.q/(60^2);

Cap = linspace(0,1,150);
C_max = (p.vu - polyval(ocv_curve_2,Cap))/((R0+R1)*1.5);

plot(Cap,C_max)