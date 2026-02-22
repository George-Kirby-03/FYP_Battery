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

I_maxcycles_4_d = [5.15680000000000, 7.09610000000000, 5.26460000000000, 4.29577962581568, 0];
t_maxcycles_4_d = [0, 153.583617747440, 265.194220754726, 415.633000529068, 600];

I_const_d = [5.28, 5.28, 5.28, 5.28, 0];
t_const_d = [0, 150, 300, 450, 600];

% Simulate profiles
[t_CLO1, I_CLO1, V_CLO1, T_CLO1, Pgen_CLO1] = DiscreteModel_Function(t_CLO1_d,I_CLO1_d,0.001,600);
[t_CLO2, I_CLO2, V_CLO2, T_CLO2, Pgen_CLO2] = DiscreteModel_Function(t_CLO2_d,I_CLO2_d,0.001,600);
[t_CLO3, I_CLO3, V_CLO3, T_CLO3, Pgen_CLO3] = DiscreteModel_Function(t_CLO3_d,I_CLO3_d,0.001,600);
[t_minsumT_4, I_minsumT_4, V_minsumT_4, T_minsumT_4, Pgen_minsumT_4] = DiscreteModel_Function(t_minsumT_4_d,I_minsumT_4_d,0.001,600);
[t_maxcycles_4, I_maxcycles_4, V_maxcycles_4, T_maxcycles_4, Pgen_maxcycles_4] = DiscreteModel_Function(t_maxcycles_4_d,I_maxcycles_4_d,0.001,600);
[t_const, I_const, V_const, T_const, Pgen_const] = DiscreteModel_Function(t_const_d,I_const_d,0.001,600);

%% Plot
f_size = 26;
%% Plot Current Comparison
figure
hold on
box on
plot(t_CLO1,I_CLO1,'color','#D95319','linewidth',3)
plot(t_CLO2,I_CLO2,'-.','color','#D95319','linewidth',3)
plot(t_CLO3,I_CLO3,'--','color','#D95319','linewidth',3)
plot(t_minsumT_4,I_minsumT_4,'color','magenta','linewidth',3)
plot(t_maxcycles_4,I_maxcycles_4,'-.','color','magenta','linewidth',3)
plot(t_const,I_const,'-','color','black','linewidth',3)
xlabel('Time (s)','fontSize',f_size,'interpreter','latex')
ylabel('Charging Current (A)','fontSize',f_size,'interpreter','latex')
leg = legend('CLO1','CLO2','CLO3','Minimum $\Sigma \Delta T$,','Maximum Cycles To Failure','Constant Current');
set(leg,'interpreter','latex','fontsize',f_size,'location','southeast')
set(gca,'FontSize',f_size);

%% Plot Voltage Comparison
figure
hold on
box on
plot(t_CLO1,V_CLO1,'color','#0072BD','linewidth',3)
plot(t_CLO2,V_CLO2,'-.','color','#0072BD','linewidth',3)
plot(t_CLO3,V_CLO3,'--','color','#0072BD','linewidth',3)
plot(t_minsumT_4,V_minsumT_4,'color','magenta','linewidth',3)
plot(t_maxcycles_4,V_maxcycles_4,'-.','color','magenta','linewidth',3)
plot(t_const,V_const,'-','color','black','linewidth',3)
xlabel('Time (s)','fontSize',f_size,'interpreter','latex')
ylabel('Output Voltage (V)','fontSize',f_size,'interpreter','latex')
leg = legend('CLO1','CLO2','CLO3','Minimum $\Sigma \Delta T$,','Maximum Cycles To Failure','Constant Current');
set(leg,'interpreter','latex','fontsize',f_size,'location','southeast')
set(gca,'FontSize',f_size);
axis([0 600 3.2 3.6])

%% Plot Temperature Comparison
figure
hold on
box on
plot(t_CLO1,T_CLO1,'color','#EDB120','linewidth',3)
plot(t_CLO2,T_CLO2,'-.','color','#EDB120','linewidth',3)
plot(t_CLO3,T_CLO3,'--','color','#EDB120','linewidth',3)
plot(t_minsumT_4,T_minsumT_4,'magenta','linewidth',3)
plot(t_maxcycles_4,T_maxcycles_4,'magenta-.','linewidth',3)
plot(t_const,T_const,'-','color','black','linewidth',3)
xlabel('Time (s)','fontSize',f_size,'interpreter','latex')
ylabel('Cell Temperature ($^{\circ}$C)','fontSize',f_size,'interpreter','latex')
leg = legend('CLO1','CLO2','CLO3','Minimum $\Sigma \Delta T$,','Maximum Cycles To Failure','Constant Current');
set(leg,'interpreter','latex','fontsize',f_size,'location','southeast')
set(gca,'FontSize',f_size);