function [outputArg1,outputArg2] = CCCV_Simulate(sim_handler,SoC_Delta,Current,init_conditions,CV_cutoff)
%CV_SIMULATE Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    sim_handler struct
    SoC_Delta double
    Current double
    init_conditions struct
    CV_cutoff double
end
    %Figuring out the time duration for the simulation, fastest duration
    %would be with no CV limit part, i.e Q*SoC_Delta/(Current) 's 
    Tf = sim_handler.current_sol.Q * SoC_Delta / Current;
    % init_conditions.soc = total_socs(1);
    % init_conditions.polV = 0;
    % init_conditions.T = charge_protocol.ambient_temp;
    
    [t_cc, x_cc] = ode45(@(t,y) CC_dynamics(t,y,sim_handler), [0 Tf], [cell2mat(struct2cell(init_conditions)); 0]);
    vlim_sim_idx = find(x_cc(:,4) > 0.001, 1, 'first');
    if ~isempty(vlim_sim_idx) %Vlim likley hit, find time instance and run CV dynamics from this point untill SoC end reached
        %Getting battery state at the Vlim point
        x_cc_end = x_cc(vlim_sim_idx-1,:);
        %Longest duration CV could take is calculated by assuming cc charge
        %of 
        soc_remaining = abs(init_conditions.soc - x_cc(vlim_sim_idx-1,1));
        Tf_lim = sim_handler.current_sol.Q *  soc_remaining / CV_cutoff;
        [t_cv, x_cv] = ode45(@(t,y) CV_dynamics(t,y,sim_handler), [x_cc_end Tf_lim], x_cc_end);
        SoC_final = SoC_delta + init_conditions.soc;
        SoC_end_sim_idx = find(x_cv(:,1) >= SoC_final, 1, 'first');
            if isempty(SoC_end_sim_idx)
                error("Wasnt able to charge this segment even with CV")
            end
        % Append the CV section to the valid CC section
        t_soc = [t_cc(1:vlim_sim_idx-1) t_cv(1:SoC_end_sim_idx)];
        x_soc = [x_cc(1:vlim_sim_idx-1,1:3) x_cv(1:SoC_end_sim_idx,1:3)];
    else
         t_soc = t_cc(1:vlim_sim_idx-1);
         x_soc = x_cc(1:vlim_sim_idx-1,1:3);
    end

end

function dx = CV_dynamics(t, y, sim_handler)
R0 = sim_handler.current_sol.R0;
R1 = sim_handler.current_sol.R1;
C = sim_handler.current_sol.C;
Q = sim_handler.current_sol.Q;
v_ulim = param.vu;
v_llim = param.vl;
ocv_curve = param.ocv;

current = (v_ulim - ocv_curve(y(1)) - y(2))./R0;

dx1 = current./Q;
dx2 = -y(2)./(R1.*C) + current./C;
dx3 = 0;
dx = [dx1; dx2; dx3;];

end
