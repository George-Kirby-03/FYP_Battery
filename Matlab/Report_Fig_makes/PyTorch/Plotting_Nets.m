figure()
mae_data = readtable('mae_history.csv');
train_mae = mae_data.Train_MAE;
val_mae = mae_data.Val_MAE;
plot(mae_data.Epoch,mae_data.Train_MAE,'LineWidth',2)
hold on
plot(mae_data.Epoch,mae_data.Val_MAE,'LineWidth',2)
legend(["Training Data Batch MAE", "Validation Data Batch MAE"], "Interpreter", "latex", "FontSize", 13)
xlabel("Epoch", "Interpreter", "latex", "FontSize", 13)
ylabel("Cycle MAE", "Interpreter", "latex", "FontSize", 13)
grid on