load RS_Param_Retry.mat

load Paings_A_1_200.mat

soc = linspace(0,1,100);

figure();
grid on 
plot(soc,ocv_curve_2(soc))
hold on
plot(soc,sim_handler{3}.ocv_curve(soc))
xlabel("SoC (0-1 / 0-100\%)","Interpreter","latex","FontSize",13)
ylabel("$V_{oc}(SoC)$","Interpreter","latex","FontSize",13)
