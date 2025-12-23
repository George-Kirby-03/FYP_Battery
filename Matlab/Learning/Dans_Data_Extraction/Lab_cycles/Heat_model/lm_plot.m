clear

load("..\Dans_Data_Extraction\Characterisation Tests\charac_02.mat")

hA = 0.0399;
mCp = 58.7796;
Cc = 1.5;



discharge = 2.5;

C1 = 1.73;
C2 = 1.73;
C3 = 1.6;
C4 = 1.39;
C5 = 0.5;

A = [-hA/mCp];
B = [1/mCp];
C = eye(1);
D = [0];





C1_time = 0.2*60.^2/C1;
C2_time = 0.2*60.^2/C2;
C3_time = 0.2*60.^2/C3;
C4_time = 0.2*60.^2/C4;
C5_time = 0.2*60.^2/C5;


loops = 5;               % convergence loops

%% ================= SWEEP VARIABLE =================
rest = linspace(500,5000,20);   % rest times (s)

%% ================= PREALLOCATE =================
avg_temp  = zeros(length(rest),1);
peak_temp = zeros(length(rest),1);

temp = cell(length(rest),1);
time = cell(length(rest),1);

%% ================= SYSTEM =================
sys = ss(A,B,C,D);
IC0 = zeros(size(A,1),1);   % initial condition

%% ================= MAIN LOOP =================
for j = 1:length(rest)

    %% ---- timing ----
    disch = Cc/discharge * 60^2;
    end_rest = disch + rest(j);

    t_end = end_rest + C1_time + C2_time + C3_time + C4_time + C5_time;
    t = linspace(0, t_end, 1000)';

    %% ---- current profile ----
    I = zeros(size(t));

    I(t <= disch) = discharge;
    I(t > disch & t <= end_rest) = 0;
    I(t > end_rest & t <= end_rest+C1_time) = C1;
    I(t > end_rest+C1_time & t <= end_rest+C1_time+C2_time) = C2;
    I(t > end_rest+C1_time+C2_time & t <= end_rest+C1_time+C2_time+C3_time) = C3;
    I(t > end_rest+C1_time+C2_time+C3_time & t <= end_rest+C1_time+C2_time+C3_time+C4_time) = C4;
    I(t > end_rest+C1_time+C2_time+C3_time+C4_time & ...
      t <= end_rest+C1_time+C2_time+C3_time+C4_time+C5_time) = C5;

    %% ---- heat generation ----
    q = I.^2 * 0.075;

    %% ---- converge to steady periodic state ----
    IC = IC0;
    for k = 1:loops
        y = lsim(sys, q, t, IC);
        IC = y(end,:)';
    end

    %% ---- metrics ----
    avg_temp(j)  = trapz(t, y) / t(end);
    peak_temp(j) = max(y);

    temp{j} = y;
    time{j} = t;

    %% ---- plot ----
    xlim([-278 11722])
ylim([0.13 10.13])
grid on
title("Steady state cycle with varying rest times", "FontSize", 16)
xlabel("Time", "FontSize", 16)
ylabel("Temp (0 amb)", "FontSize", 14)
hLine = findobj(gcf,"Type","line")
hLine(15).LineWidth = 4.5000
hLine(15).LineStyle = ":"; hold on
end

%% ================= POST PLOTS =================
figure
plot(rest, avg_temp), grid on
xlabel('Rest time (s)')
ylabel('Steady-state average temperature')

figure
plot(rest, peak_temp), grid on
xlabel('Rest time (s)')
ylabel('Steady-state peak temperature')