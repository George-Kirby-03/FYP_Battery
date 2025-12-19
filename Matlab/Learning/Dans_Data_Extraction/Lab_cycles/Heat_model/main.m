
rho = 2300; % density of copper, kg/m^3
specificHeat = 800; % specific heat of copper, J/(kg-K)
hCoeff = 100; % Heat transfer coefficient, W/(m^2-K)
w = 20; % Volumentric heat source
cx = 100;
cy = 40;
T_amb = 20;
load("Geom.mat")
model = createpde;
g = decsg(gd,'S1',('S1')');
geometryFromEdges(model,g);

figure; 
pdegplot(model,EdgeLabels="on"); 
axis([-.1 1.1 -.1 1.1]);
title("Geometry With Edge Labels Displayed")

q = w/(1.65e-5);
%%
% c = thick*k;
% f = 2*hCoeff*ta + 2*emiss*stefanBoltz*ta^4;
% d = thick*rho*specificHeat;

%a = @(~,state) 2*hCoeff + 2*emiss*stefanBoltz*state.u.^3;
f = @(location,~) q*location.y;
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
endTime = 500;
tlist = 0:5:endTime;
setInitialConditions(model,20);
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
pdeplot(model,XYData=u(:,20),Contour="on",ColorMap="jet");
title(sprintf(['Temperature In The Plate,' ...
               'Transient Solution( %d seconds)\n'],tlist(1,end)));
xlabel("X-coordinate, meters")
ylabel("Y-coordinate, meters")
axis equal;

