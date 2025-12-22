clear

load("..\Dans_Data_Extraction\Characterisation Tests\charac_02.mat")

hA = 0.0399;
mCp = 58.7796;

A = [-hA/mCp];
B = [1/mCp];
C = eye(1);
D = [0];

t = linspace(0,tt(end),1000);

u = interp1(tt,u1,t);


sys = ss(A,B,C,D);

y = lsim(sys,u,t);

plot(t,y)