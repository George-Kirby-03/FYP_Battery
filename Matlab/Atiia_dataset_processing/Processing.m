clc
clear
load("E:\2019-01-24_batchdata_updated_struct_errorcorrect.mat")

num_exp = length(batch);

for j=1:num_exp
    num_cyc = length(batch(j).cycles);
    table_exp = 0;
    Voltage =[];
    Current = [];
    Temperature = [];
    Test_Time = [];
    Cycle = [];

    for i=1:num_cyc
      Voltage = [Voltage; batch(j).cycles(i).V];
       Current = [Current; batch(j).cycles(i).I];
      Temperature = [Temperature; batch(j).cycles(i).T];
      Test_Time = [Test_Time; batch(j).cycles(i).t];
      Cycle = [Cycle; i*ones(length(batch(j).cycles(i).t),1)];
    end

    T = table(Cycle,Test_Time,Voltage,Current,Temperature);
    name = append(batch(j).barcode,".csv");
    writetable(T,name)
end