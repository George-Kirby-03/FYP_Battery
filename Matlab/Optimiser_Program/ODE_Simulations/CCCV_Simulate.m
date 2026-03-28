function [t_soc, x_soc] = CCCV_Simulate(sim_handler,SoC_Delta,Current,init_conditions,CV_cutoff,rest_time)
%CV_SIMULATE Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    sim_handler struct
    SoC_Delta double
    Current double
    init_conditions struct
    CV_cutoff double
    rest_time double
end

   % If current is 0 for segment, will be rest stage, just run dynamics for
   % rest time and return
   if Current == 0
        [t_soc, x_soc] = ode45(@(t,y) CC_dynamics(t,y,sim_handler,0), [0 rest_time],init_conditions);
   return 
   end

    %Figuring out the time duration for the simulation, fastest duration
    %would be with no CV limit part, i.e Q*SoC_Delta/(Current) 's 
    Tf = sim_handler.current_sol.Q * SoC_Delta / Current;
    % init_conditions.soc = total_socs(1);
    % init_conditions.polV = 0;
    % init_conditions.T = charge_protocol.ambient_temp;
    
    [t_cc, x_cc] = ode45(@(t,y) CC_dynamics(t,y,sim_handler,Current), [0 Tf], [cell2mat(struct2cell(init_conditions)); 0]);
    vlim_sim_idx = find(x_cc(:,4) > 0.001, 1, 'first');
    if ~isempty(vlim_sim_idx) %Vlim likley hit, find time instance and run CV dynamics from this point untill SoC end reached
        %Getting battery state at the Vlim point
        x_cc_end = x_cc(vlim_sim_idx-1,:);
        %Longest duration CV could take is calculated by assuming cc charge
        %of 
        soc_remaining = abs(init_conditions.soc - x_cc(vlim_sim_idx-1,1));
        Tf_lim = sim_handler.current_sol.Q *  soc_remaining / CV_cutoff;
        [t_cv, x_cv] = ode45(@(t,y) CV_dynamics(t,y,sim_handler,CV_cutoff), [x_cc_end Tf_lim], x_cc_end);
        SoC_final = SoC_delta + init_conditions.soc;
        SoC_end_sim_idx = find(x_cv(:,1) >= SoC_final, 1, 'first');
            if isempty(SoC_end_sim_idx)
                fprintf("Wasnt able to charge this segment even with CV")
                cv_cutoff_sim_idx = find(x_cv(:,4) > 0.001, 1, 'first');
                if ~isempty(cv_cutoff_sim_idx)
                    fprintf("CV Cuttoff Current reached (this should only occur at the end near 100 SoC)");
                end
            else
                error("Something went wrong")
            end
        % Append the CV section to the valid CC section
        t_soc = [t_cc(1:vlim_sim_idx-1) t_cv(1:SoC_end_sim_idx)];
        x_soc = [x_cc(1:vlim_sim_idx-1,1:3) x_cv(1:SoC_end_sim_idx,1:3)];
    else
         t_soc = t_cc;
         x_soc = x_cc(:,1:3);
    end

end


function dx = CC_dynamics(t, y, sim_handler, current)
R0 = sim_handler.current_sol.R0;
R1 = sim_handler.current_sol.R1;
C = sim_handler.current_sol.C;
Q = sim_handler.current_sol.Q;
Cp = sim_handler.current_sol.Cp;
h = sim_handler.current_sol.h;
v_ulim = sim_handler.ocv_curve(1);
v_llim = sim_handler.ocv_curve(0);
ocv_curve = sim_handler.ocv_curve;
dx4 = 0;
v = ocv_curve(y(1)) + y(2) + R0.*current;
%% Below conditions to seng V signal for vlims reach
if (v < v_llim) && current < 0
    current = 0;
    dx4 = 0.1;
end
if (v > v_ulim) && current > 0
    current = 0;
    dx4 = 0.1;
end

dx1 = current./Q;
dx2 = -y(2)./(R1.*C) + current./C;
%dx(:,3) = -(hA./mCp).*(T) + (R0./mCp).*(current_bat).^2 + (1./(mCp)).*V_RC1.*current_bat; 
dx3 = -(h/Cp)*y(3) + (R0/Cp)*current^2 + (1./(mCp))*y(2)*current;
dx = [dx1; dx2; dx3; dx4];
end

function dx = CV_dynamics(t, y, sim_handler, cv_cutoff)
R0 = sim_handler.current_sol.R0;
R1 = sim_handler.current_sol.R1;
C = sim_handler.current_sol.C;
Q = sim_handler.current_sol.Q;
Cp = sim_handler.current_sol.Cp;
h = sim_handler.current_sol.h;
v_ulim = sim_handler.ocv_curve(1);
v_llim = sim_handler.ocv_curve(0);
ocv_curve = sim_handler.ocv_curve;

current = (v_ulim - ocv_curve(y(1)) - y(2))./R0;
if current <= cv_cutoff
    dx4 = 0.1;
end
dx1 = current./Q;
dx2 = -y(2)./(R1.*C) + current./C;
dx3 = -(h/Cp)*y(3) + (R0/Cp)*current^2 + (1./(mCp))*y(2)*current;
dx = [dx1; dx2; dx3; dx4];

end
