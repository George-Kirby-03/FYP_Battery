T = readtable("./mae_history_lstm.csv");

figure();
plot(T.Epoch,T.Train_MAE)
hold on
plot(T.Epoch,T.Val_MAE)
legend(["Training Data Batch MAE","Validation Data Batch MAE"],"Interpreter","latex")
xlabel("Epoch","Interpreter","latex",'FontSize',13)
ylabel("Cycle MAE","Interpreter","latex",'FontSize',13)