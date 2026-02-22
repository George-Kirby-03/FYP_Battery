% Code to generate current profiles such as those in the Attia paper
%Q = 0.2*1.1Ah = 792As
Q = 3960;
Q_20 = 792;

% State first 3 current in terms of C rate
%CLO1:
% I1 = 4.8;
% I2 = 5.2;
% I3 = 5.2;

%CLO2:
I1 = 5.2;
I2 = 5.2;
I3 = 4.8;

%CLO3:
% I1 = 4.4;
% I2 = 5.6;
% I3 = 5.2;

I1 = I1*1.1;
I2 = I2*1.1;
I3 = I3*1.1;

t1p5 = Q_20/I1;
t2p5 = t1p5+Q_20/I2;
t3p5 = t2p5+Q_20/I3;
t4p5 = 600;

I4 = Q_20/(t4p5-t3p5);
I5 = 0;

I4C = I4/1.1;

%
t = [0,t1p5,t2p5,t3p5,t4p5];
i_optimal = [I1,I2,I3,I4,I5];

stairs(t,i_optimal);