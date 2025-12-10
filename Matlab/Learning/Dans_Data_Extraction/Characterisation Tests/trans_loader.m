clear 
load("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Learning\Dans_Data_Extraction\Characterisation Tests\charac_01.mat")
 [~, idxm] = min(abs(tt - 251964));
[~, idxmax] = min(abs(tt - 252382));
tt = tt(idxm:idxmax) - tt(idxm);
u1 = u1(idxm:idxmax);
tp = tp(idxm:idxmax);
y = y(idxm:idxmax);
tp = tp - tp(1);
save('charac_01_s4.mat')
clear







load("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Learning\Dans_Data_Extraction\Characterisation Tests\charac_02_start.mat")
t_buffer = linspace(0,200,100) ;
t_buffer = t_buffer';
tt = [t_buffer; tt + t_buffer(end)];
y = [y(1)*ones(200,1);y];
u1 = [zeros(200,1);u1];
tp = [zeros(200,1);tp];
save("charac_02_start.mat","y","u1","tt","tp");

load("C:\Users\jekir\GitHub\FYP_Battery\Matlab\Learning\Dans_Data_Extraction\Characterisation Tests\charac_02_start.mat")
[tt, ia] = unique(tt);
y = y(ia);
u1= u1(ia); tp = tp(ia); 
save("charac_02_start.mat","y","u1","tt","tp");