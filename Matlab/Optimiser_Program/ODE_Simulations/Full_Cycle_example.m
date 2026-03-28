% load in the sim_handle

% ODE45 Simulation example 

%Here
charge_protocol.charge_segments = [0,20,40,60,80,100];
charge_protocol.charge_currents = [2,3,4,5,6];
charge_protocol.CV_cutoff = 0.05;
charge_protocol.discharge_segments = [100 0];
charge_protocol.discharge_currents = 5;
charge_protocol.discharge_charge_rest = 60*30;
charge_protocol.discharge_CV = 'False';
charge_protocol.charge_CV = 'True';
charge_protocol.ambient_temp = 24;


sim_results = odeSOC(sim_handler,charge_protocol);