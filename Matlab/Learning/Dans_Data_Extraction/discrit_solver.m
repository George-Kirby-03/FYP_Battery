function [Sim_DT, Sim_V] = discrit_solver(time,current,param,SoC)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
i_input = current;
t_input = time;
i_size = length(i_input);
v1 = zeros(1,i_size);
z = ones(1,i_size)*SoC;
DT = zeros(1,i_size);
states = [v1; z; DT];
params = length(param);
for i = 1:i_size-1
i_curr = i_input(i);
Ts = t_input(i+1) - t_input(i);
[A, B] = discrit(param,Ts);
states(:,i+1) = A*states(:,i) + B*[i_curr;i_curr.^2;states(1,i).*i_curr];
end
Sim_DT = states(3,:);
fix.poly.xe = zeros(params - 6,1);
Sim_V = polymodel(fix,param,states(2,:),1)  + states(1,:) + i_input.*(param(params-3));
end