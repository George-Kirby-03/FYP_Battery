%% Code to compare the various profiles of the Nature paper optimum and others
% Define charging profiles
I_CLO1_d = [5.28, 5.72, 5.72, 4.576, 0];
t_CLO1_d = [0, 150, 288.461538461538, 426.923076923077, 600];

I_CLO2_d = [5.72, 5.72, 5.28, 4.576, 0];
t_CLO2_d = [0, 138.461538461538, 276.923076923077, 426.923076923077, 600];

I_CLO3_d = [4.84, 6.16, 5.72, 4.67723893805310, 0];
t_CLO3_d = [0, 163.636363636364, 292.207792207792, 430.669330669331, 600];

I_minsumT_4_d = [5.96773472310006, 5.29017565969733, 5.00315340483273, 4.97254151940521, 0];
t_minsumT_4_d = [0, 132.713673906165, 282.425148712904, 440.725311813036, 600];

I_minsumT_8_d = [6.38526429692114, 5.57849444491625, 5.37655229975438, 5.19173269060626, 5.05050056580312, 4.94765712931794, 4.86214071352456, 5.13116262367609, 0];
t_minsumT_8_d = [0, 62.0177930913438, 133.004688195430, 206.657835774427, 282.932949228651, 361.341018852742, 441.378901359485, 522.824508003177, 600];

% Simulate profiles
[t_CLO1, I_CLO1, V_CLO1, T_CLO1, Pgen_CLO1] = DiscreteModel_Function(t_CLO1_d,I_CLO1_d,0.001,600);
[t_CLO2, I_CLO2, V_CLO2, T_CLO2, Pgen_CLO2] = DiscreteModel_Function(t_CLO2_d,I_CLO2_d,0.001,600);
[t_CLO3, I_CLO3, V_CLO3, T_CLO3, Pgen_CLO3] = DiscreteModel_Function(t_CLO3_d,I_CLO3_d,0.001,600);
[t_minsumT_4, I_minsumT_4, V_minsumT_4, T_minsumT_4, Pgen_minsumT_4] = DiscreteModel_Function(t_minsumT_4_d,I_minsumT_4_d,0.001,600);
[t_minsumT_8, I_minsumT_8, V_minsumT_8, T_minsumT_8, Pgen_minsumT_8] = DiscreteModel_Function(t_minsumT_8_d,I_minsumT_8_d,0.001,600);

%% Plot
f_size = 16;
%% Plot Current Comparison
figure
hold on
plot(t_CLO1,I_CLO1,'color','#D95319','linewidth',1.5)
plot(t_CLO2,I_CLO2,'--','color','#D95319','linewidth',1.5)
plot(t_CLO3,I_CLO3,':','color','#D95319','linewidth',1.5)
plot(t_minsumT_4,I_minsumT_4,'color','#A2142F','linewidth',1.5)
plot(t_minsumT_8,I_minsumT_8,'--','color','#A2142F','linewidth',1.5)
grid on
xlabel('Time (s)','fontSize',f_size,'interpreter','latex')
ylabel('Charging Current (A)','fontSize',f_size,'interpreter','latex')
leg = legend('CLO1','CLO2','CLO3','Minimum $\Sigma \Delta T$, 4 steps','Minimum $\Sigma \Delta T$, 8 steps');
set(leg,'interpreter','latex','fontsize',f_size,'location','southeast')
set(gca,'FontSize',f_size);

%% Plot Voltage Comparison
figure
hold on
plot(t_CLO1,V_CLO1,'color','#0072BD','linewidth',1.5)
plot(t_CLO2,V_CLO2,'--','color','#0072BD','linewidth',1.5)
plot(t_CLO3,V_CLO3,':','color','#0072BD','linewidth',1.5)
plot(t_minsumT_4,V_minsumT_4,'color','c','linewidth',1.5)
plot(t_minsumT_8,V_minsumT_8,'--','color','c','linewidth',1.5)
grid on
xlabel('Time (s)','fontSize',f_size,'interpreter','latex')
ylabel('Output Voltage (V)','fontSize',f_size,'interpreter','latex')
leg = legend('CLO1','CLO2','CLO3','Minimum $\Sigma \Delta T$, 4 steps','Minimum $\Sigma \Delta T$, 8 steps');
set(leg,'interpreter','latex','fontsize',f_size,'location','southeast')
set(gca,'FontSize',f_size);

%% Plot Temperature Comparison
figure
hold on
plot(t_CLO1,T_CLO1,'color','#EDB120','linewidth',1.5)
plot(t_CLO2,T_CLO2,'--','color','#EDB120','linewidth',1.5)
plot(t_CLO3,T_CLO3,':','color','#EDB120','linewidth',1.5)
plot(t_minsumT_4,T_minsumT_4,'yellow','linewidth',1.5)
plot(t_minsumT_8,T_minsumT_8,'yellow--','linewidth',1.5)
grid on
xlabel('Time (s)','fontSize',f_size,'interpreter','latex')
ylabel('Cell Temperature ($^{\circ}$C)','fontSize',f_size,'interpreter','latex')
leg = legend('CLO1','CLO2','CLO3','Minimum $\Sigma \Delta T$, 4 steps','Minimum $\Sigma \Delta T$, 8 steps');
set(leg,'interpreter','latex','fontsize',f_size,'location','southeast')
set(gca,'FontSize',f_size);

