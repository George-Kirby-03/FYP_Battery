x1=x(:,1);x2=x(:,2);
u1=vdat.InputCurrent(t);
R0=R0Model(p,x1,u1);
voltage_model=OCVModel(p,x1)+x2+R0.*u1;
% for i=2:vdat.OCV_Np
%     voltage_model=voltage_model+p(:,i).*x1.^(i-1);
% end
voltage_measured=vdat.OutputVoltage(t);
stageCost = (voltage_model-voltage_measured).^2;
% weight=(t/t(end)-0.5).^2*4*100+1;
% stageCost = weight.*(voltage_model-voltage_measured).^2;
