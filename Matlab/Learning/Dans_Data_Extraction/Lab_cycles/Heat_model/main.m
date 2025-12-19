
rho = 2300; % density of copper, kg/m^3
specificHeat = 800; % specific heat of copper, J/(kg-K)
hCoeff = 100; % Heat transfer coefficient, W/(m^2-K)
q = 3e5; % Volumentric heat source
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
endTime = 5000;
tlist = 0:50:endTime;
setInitialConditions(model,20);
model.SolverOptions.RelativeTolerance = 1.0e-3; 
model.SolverOptions.AbsoluteTolerance = 1.0e-4;

R = solvepde(model,tlist);
u = R.NodalSolution;
figure; 
plot(tlist,u(1,:)); 
grid on
title(["Temperature Along the Top Edge of " ...
       "the Plate as a Function of Time"])
xlabel("Time, seconds")
ylabel("Temperature, degrees-Kelvin")

figure;
pdeplot(model,XYData=u(:,5),Contour="on",ColorMap="jet");
title(sprintf(['Temperature In The Plate,' ...
               'Transient Solution( %d seconds)\n'],tlist(1,end)));
xlabel("X-coordinate, meters")
ylabel("Y-coordinate, meters")
axis equal;
figure;
filename = 'temperature_evolution.gif';

for k = 1:length(tlist)
    pdeplot(model, ...
        XYData = u(:,k), ...
        Contour = "on", ...
        ColorMap = "jet");
    
    title(sprintf('Temperature at t = %.1f s', tlist(k)))
    xlabel('X-coordinate (m)')
    ylabel('Y-coordinate (m)')
    axis equal
    caxis([min(u(:)) max(u(:))])   % lock color scale
    drawnow

    frame = getframe(gcf);
    im = frame2im(frame);
    [A,map] = rgb2ind(im,256);

    if k == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.1);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);
    end
end
