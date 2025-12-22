load("../../Characterisation Tests/charac_02.mat")
rho = 2400; % kg/m^3
specificHeat = 1450; % J/(kg-K)
hCoeff = 8; % W/(m^2-K)
w = 0.675; % Power Watts
cx = 30.4;
cy = 0.2;
T_amb = tp(1);
load("Geom.mat")

model = createpde;
g = decsg(gd,'S1',('S1')');
geometryFromEdges(model,g);

figure; 
pdegplot(model,EdgeLabels="on"); 
axis([-.1 1.1 -.1 1.1]);
title("Geometry With Edge Labels Displayed")
w = (u1.^2).*0.08;
q = w/(1.6e-5);

q_lut = @(t) interp1(tt, q, t, 'linear', 'extrap');
f = @(location,state) heat_time(location,state,q_lut);
%f = @(location,~) q*location.y;
d = @(location,~) rho*specificHeat*location.y;
c = @(location,state) coeffk(location,state,cx,cy);
specifyCoefficients(model,m=0,d=d,c=c,a=0,f=f);

applyBoundaryCondition(model,"neumann", ...
                       Edge=[2,3,4],g=@(location,state) Newman_BC(location,state,hCoeff,T_amb), ...
                       q=@(location,state) Newman_BC(location,state,hCoeff,1));
applyBoundaryCondition(model,"neumann", ...
                       Edge=1,g=0, ...
                       q=0);

msh = generateMesh(model,Hmax=0.0005);
figure; 
pdeplot(model); 
axis equal
xlabel("X-coordinate, meters")
ylabel("Y-coordinate, meters")
endTime = 32668;
tlist = 0:60:endTime;
setInitialConditions(model,T_amb);
model.SolverOptions.RelativeTolerance = 1.0e-3; 
model.SolverOptions.AbsoluteTolerance = 1.0e-4;

R = solvepde(model,tlist);
u = R.NodalSolution;
% figure; 
% plot(tlist,u(1,:)); 
% grid on
% title(["Temperature Along the Top Edge of " ...
%        "the Plate as a Function of Time"])
% xlabel("Time, seconds")
% ylabel("Temperature, degrees-Kelvin")

figure;
pdeplot(model,XYData=u(:,end),Contour="on",ColorMap="jet");
title(sprintf(['Temperature In The Plate,' ...
               'Transient Solution( %d seconds)\n'],tlist(1,end)));
xlabel("X-coordinate, meters")
ylabel("Y-coordinate, meters")
axis equal;

figure;
Tmax = max(u, [], 1);   % max over nodes, for each time
Tmin = min(u, [], 1);   % min over nodes, for each time

figure;
plot(tlist, Tmax, 'r', 'LineWidth', 2); hold on
plot(tlist, Tmin, 'b', 'LineWidth', 2);
plot(tlist, interp1(tt,tp,tlist), 'g', 'LineWidth', 2);
grid on
xlabel('Time')
ylabel('Tempe')
legend('T_{max}', 'T_{min}', 'Location', 'best')
title('Sim temps vs Time')
