function [cap, ocv, dcir_cc, dcir_cd, dcir_dc, dcir_dd] = getCellChars(data_file, plot_figs)
    % Extracts cell characteristics data from Maccor characterisation test
    % file. Requires two inputs: 'data_file' - string, containing the path
    % to the .csv file to be read; 'plot_figs' - boolean, if true will plot
    % test voltage & current profile, OCV curve and DCIR data, no plots if
    % false.
    %
    % Returns 6 results: 'cap' - measured capacity of cell in Ah; 'ocv' -
    % OCV vs SoC data; 'dcir_cc' - DCIR(CC) data; 'dcir_cd' - DCIR(CD)
    % data; 'dcir_dc' - DCIR(DC) data; 'dcir_dd' - DCIR(DD) data.
    
    %% Import and preprocess datafile

    data = readtable(data_file, 'ReadVariableNames', 0);
    
    % Datafile may have up to three columns of temperature data, so set
    % variable names accordingly
    if size(data, 2) == 13
        data.Properties.VariableNames = {'Rec', 'Cyc', 'Step', 'TTime', 'STime', 'AH', 'WH', 'A', 'V', 'ES', 'T1', 'T2', 'T3'};
    elseif size(data, 2) == 12
        data.Properties.VariableNames = {'Rec', 'Cyc', 'Step', 'TTime', 'STime', 'AH', 'WH', 'A', 'V', 'ES', 'T1', 'T2'};
    elseif size(data, 2) == 11
        data.Properties.VariableNames = {'Rec', 'Cyc', 'Step', 'TTime', 'STime', 'AH', 'WH', 'A', 'V', 'ES', 'T1'};
    elseif size(data, 2) == 10
        data.Properties.VariableNames = {'Rec', 'Cyc', 'Step', 'TTime', 'STime', 'AH', 'WH', 'A', 'V', 'ES'};
    else
        error('Unexpected number of columns in datafile')
    end
    
    %% Capacity & OCV
    % Get capacity of cell from full discharge in step 4
    cap = data.AH((data.ES == 133 & data.Step == 4), :);
    
    % Step 5 is rest @ 0% SoC, step 10 rest @ 10-90% SoC & step 17 rest @ 
    % 100% SoC, so get voltage reading at end of each step for charge OCV
    ocv_c = data.V((data.ES == 129 & (data.Step == 5 | data.Step == 10 | data.Step == 17)), :);
    
    % Step 17 is rest @ 100% SoC, step 22 rest @ 90-10% SoC & step 29 rest 
    % @ 0% SoC, so get voltage reading at end of each step for discharge OCV
    ocv_d = flip(data.V((data.ES == 129 & (data.Step == 17 | data.Step == 22 | data.Step == 29)), :));
    
    ocv = [(0 : 10 : 100)', ocv_d, ocv_c];
    
    %% DCIR (CC)
    % Identify start locations for DCIR charge/charge steps
    dcir_cc_loc = find(data.ES == 129 & (data.Step == 5 | data.Step == 12));
    if length(dcir_cc_loc) ~= 10
        error('Failed to find 10 DCIR(CC) pulses')
    end
    
    % Create array to hold data, populate with SoC
    dcir_cc = zeros(10, 2);
    dcir_cc(:, 1) = (0 : 10 : 90)';
    
    % For each DCIR(CC) pulse...
    for i = 1 : 10
        loc = dcir_cc_loc(i);
        
        % Get basline voltage and current
        v0 = data.V(loc, :);
        i0 = data.A(loc, :);
        
        % Step forward until current is stable (~ 10%)
        inc = 1;
        while 1
            i1 = data.A(loc + inc, :);
            if abs(data.A(loc + inc + 1, :) - i1) < 0.1 * i1        % First step within 10%
                if abs(data.A(loc + inc + 2, :) - i1) < 0.1 * i1    % Second step within 10%
                    break
                end
            end
            inc = inc + 1;
        end
        
        v1 = data.V(loc + inc, :);
        
        % Write DCIR value to variable, convert to mOhm
        dcir_cc(i, 2) = abs((v0 - v1) / (i0 - i1)) * 1000;
    end
    
    %% DCIR (CD)
    % Identify start locations for DCIR charge/discharge steps
    dcir_cd_loc = find(data.ES == 129 & (data.Step == 10 | data.Step == 17));
    if length(dcir_cd_loc) ~= 10
        error('Failed to find 10 DCIR(CD) pulses')
    end
    
    % Create array to hold data, populate with SoC
    dcir_cd = zeros(10, 2);
    dcir_cd(:, 1) = (10 : 10 : 100)';
    
    % For each DCIR(CD) pulse...
    for i = 1 : 10
        loc = dcir_cd_loc(i);
        
        % Get basline voltage and current
        v0 = data.V(loc, :);
        i0 = data.A(loc, :);
        
        % Step forward until current is stable (~ 10%)
        inc = 1;
        while 1
            i1 = data.A(loc + inc, :);
            if abs(data.A(loc + inc + 1, :) - i1) < 0.1 * i1        % First step within 10%
                if abs(data.A(loc + inc + 2, :) - i1) < 0.1 * i1    % Second step within 10%
                    break
                end
            end
            inc = inc + 1;
        end
        
        v1 = data.V(loc + inc, :);
        
        % Write DCIR value to variable, convert to mOhm
        dcir_cd(i, 2) = abs((v0 - v1) / (i0 - i1)) * 1000;
    end
    
    %% DCIR (DC)
    % Identify start locations for DCIR discharge/charge steps
    dcir_dc_loc = flip(find(data.ES == 129 & (data.Step == 24 | data.Step == 29)));    % Flip to get increasing SoC
    if length(dcir_dc_loc) ~= 10
        error('Failed to find 10 DCIR(DC) pulses')
    end
    
    % Create array to hold data, populate with SoC
    dcir_dc = zeros(10, 2);
    dcir_dc(:, 1) = (0 : 10 : 90)';
    
    % For each DCIR(DC) pulse...
    for i = 1 : 10
        loc = dcir_dc_loc(i);
        
        % Get basline voltage and current
        v0 = data.V(loc, :);
        i0 = data.A(loc, :);
        
        % Step forward until current is stable (~ 10%)
        inc = 1;
        while 1
            i1 = data.A(loc + inc, :);
            if abs(data.A(loc + inc + 1, :) - i1) < 0.1 * i1        % First step within 10%
                if abs(data.A(loc + inc + 2, :) - i1) < 0.1 * i1    % Second step within 10%
                    break
                end
            end
            inc = inc + 1;
        end
        
        v1 = data.V(loc + inc, :);
        
        % Write DCIR value to variable, convert to mOhm
        dcir_dc(i, 2) = abs((v0 - v1) / (i0 - i1)) * 1000;
    end
    
    %% DCIR (DD)
    % Identify start locations for DCIR discharge/discharge steps
    dcir_dd_loc = flip(find(data.ES == 129 & (data.Step == 17 | data.Step == 22)));    % Flip to get increasing SoC
    if length(dcir_dd_loc) ~= 10
        error('Failed to find 10 DCIR(DD) pulses')
    end
    
    % Create array to hold data, populate with SoC
    dcir_dd = zeros(10, 2);
    dcir_dd(:, 1) = (10 : 10 : 100)';
    
    % For each DCIR(DD) pulse...
    for i = 1 : 10
        loc = dcir_dd_loc(i);
        
        % Get basline voltage and current
        v0 = data.V(loc, :);
        i0 = data.A(loc, :);
        
        % Step forward until current is stable (~ 10%)
        inc = 1;
        while 1
            i1 = data.A(loc + inc, :);
            if abs(data.A(loc + inc + 1, :) - i1) < 0.1 * i1        % First step within 10%
                if abs(data.A(loc + inc + 2, :) - i1) < 0.1 * i1    % Second step within 10%
                    break
                end
            end
            inc = inc + 1;
        end
        
        v1 = data.V(loc + inc, :);
        
        % Write DCIR value to variable, convert to mOhm
        dcir_dd(i, 2) = abs((v0 - v1) / (i0 - i1)) * 1000;
    end
    
    %% Plot results
    
    if plot_figs
        % Plot voltage & current profile for test
        figure
        yyaxis left
        plot(data.TTime/3600, data.V, 'linewidth', 1.5)
        ylabel('Voltage / V')
        hold on, yyaxis right
        plot(data.TTime/3600, data.A, 'linewidth', 1.5)
        box on, grid on, set(gcf, 'Color', 'w')
        xlabel('Test time / h')
        ylabel('Current / A')
        title('Test voltage & current profile')
        
        % Plot OCV curve
        figure
        h = plot(0:10:100, [ocv_c ocv_d], 'o--');
        set(h, {'MarkerFaceColor'}, get(h, 'Color'));
        box on, grid on, set(gcf, 'Color', 'w')
        xlabel('SoC / %')
        ylabel('OCV / V')
        legend('Charge', 'Discharge', 'Location', 'SouthEast')
        title('OCV curve')

        % Plot DCIR(CC) & DCIR(DD) results
        figure
        col = lines(2);
        
        plot(dcir_cc(:, 1), dcir_cc(:, 2), '^--', 'MarkerFaceColor', col(1, :), 'LineWidth', 1.5)
        hold on
        plot(dcir_dd(:, 1), dcir_dd(:, 2), 'v--', 'MarkerFaceColor', col(2, :), 'LineWidth', 1.5)
        box on, grid on, set(gcf, 'Color', 'w')
        xlabel('SoC / %')
        ylabel('DCIR / m\Omega')
        legend('DCIR_{CC}', 'DCIR_{DD}')
        title('DCIR results')
    end

end