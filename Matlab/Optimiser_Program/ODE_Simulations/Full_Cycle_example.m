% load in the sim_handle

% ODE45 Simulation example 
addpath(genpath('../Misc_functions'))
%Here

%Currently, if CV segments for charge or discharge are diabled, if limits
%are reached, the process will jump to the next segment, thus its very
%possible to accumulate SoC discrepencies from specified segments

%Common current case if for the discharge CV not enabled, this means the
%final SoC wont be 0, 

%Next idea is to allow time durations as well as just SoC durations
 
%Specifies the capacity used in calculating charge throughput, if
%Discharged is selected, the total capacity drained during the discharge
%stage is used as the battery capacity for the SoC values for charging, i.e
%no matter the battery full capacity, if only 100Q was discharged, a 10%
%SoC segment in charging corresponds to 10Q input
charge_protocol.capacity_selection = 'Discharged'; %or 'Absolute'

charge_protocol.charge_segments = [0 20 40 60 80 100]; %Specify as many segments
charge_protocol.charge_currents = [2.62 2.18 1.63 0.92 0.5] * 1.5; %Specify current per segment in c here
charge_protocol.CV_cutoff = 0.05; %Segment CV stage (if met) will stop once current falls to this limit
charge_protocol.discharge_segments = [100 0];
charge_protocol.discharge_currents = [2.5]*1.5;
charge_protocol.discharge_charge_rest = 60*30; %If set, there will be a rest period between charge and discharge ...
%(no different to manually adding a 0 current segment manually
charge_protocol.discharge_CV = 'False'; %False will mean once a discharge segment reaches vlim, it will switch to the next.
%segment instantly without running CV, it makes more sense to use this in
%conjunction with capacity_selection as 'Discharged'
charge_protocol.charge_CV = 'True';
charge_protocol.ambient_temp = 24;

warning('off', 'all') %Seems to warn it cant find original function in the function handle entry in the struct,
% but since Misc_functions is loaded to path, the function gets resolved
% correctly when called
load baseline1-800.mat
warning('on', 'all')

sim_results = odeSOC(sim_handler{1},charge_protocol);