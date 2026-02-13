load("../RS_Battery_Lab_Analysis/RS_Baseline_og_attia_normalised.mat")
Cycle10 = GK_RS_baseline_028(GK_RS_baseline_028.Cyc_ == 10 | GK_RS_baseline_028.Cyc_ == 11 ,:);
% Select the rows from (end - 599) up to the end
Cycle10 = Cycle10(end-800:end,:);
%plot(Cycle10.TestTime,Cycle10.Volts,Cycle10.TestTime,Cycle10.Amps./2 + 3)
tt = Cycle10.TestTime - Cycle10.TestTime(1);
tp = Cycle10.Temp1;
u1 = Cycle10.Amps;
y = Cycle10.Volts;
rho = 1820; % kg/m^3
specificHeat = 1548; % J/(kg-K)
hCoeff = 158; % W/(m^2-K)
cx = 30.4;
cy = 0.2;
T_amb = tp(1);
load("Geom.mat")

model = createpde;
g = decsg(gd,'S1',('S1')'); %Not really sure what this does but worked in an example similar to this
geometryFromEdges(model,g);
% u1 = u1 * 2;
figure; 
pdegplot(model,EdgeLabels="on"); 
axis([-.1 1.1 -.1 1.1]);
title("Geomtry With edge labels")
w = (u1.^2).*0.07;
q = w/(1.8e-5); %Volumetric heat generation

q_lut = @(t) interp1(tt, q, t, 'linear', 'extrap');
v_lut = @(t) interp1(tt, y, t, 'linear', 'extrap');
f = @(location,state) heat_time(location,state,q_lut);
%f = @(location,~) q*location.y;
d = @(location,~) rho*specificHeat*location.y;
c = @(location,state) coeffk(location,state,cx,cy);
specifyCoefficients(model,m=0,d=d,c=c,a=0,f=f);

applyBoundaryCondition(model,"neumann", Edge=[2,3,4],g=@(location,state) Newman_BC(location,state,hCoeff,T_amb), ...
    q=@(location,state) Newman_BC(location,state,hCoeff,1));
applyBoundaryCondition(model,"neumann", Edge=1,g=0, q=0);

msh = generateMesh(model,Hmax=0.0005);
figure; 
pdeplot(model); 
axis equal
xlabel("X-coordinate, meters")
ylabel("Y-coordinate, meters")
endTime = tt(end); %End of pain part
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
plot(tlist, 20+ v_lut(tlist), 'LineWidth', 2);
plot(tlist, 24 + interp1(tt,u1.^2,tlist), 'LineWidth', 2);
grid on
xlabel('Time')
ylabel('Tempe')
legend('T_{max}', 'T_{min}', 'Location', 'best')
title('Sim temps vs Time')


% figure;
% step_time = 32668/60;
% for i = 1:20
% pdeplot(model,XYData=u(:,i),Contour="on",ColorMap="jet");
% caxis([21 26])
% xlabel("X-coordinate, meters")
% ylabel("Y-coordinate, meters")
% pause(1)
% end