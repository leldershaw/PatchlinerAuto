% LE 10th December 2020

%% Creates output files containing the rise-times,steady state current amplitudes and tail currents
function output_files(data, plotsNum, plots_param, conductance, eK, out_path, data_path, settings_path, time_col, plot_labels, all_labels, sub, sup, volt_start, volt_steps, volt_end, current_scale, importSettings)
    
    % Output filenames + paths
    [~, file_name, ~] = fileparts(data_path);
    steady_path = fullfile(out_path, [file_name '_steady.xlsx']);
    tail_path = fullfile(out_path, [file_name '_tail.xlsx']);
    rise_path = fullfile(out_path, [file_name '_rise.xlsx']);
    cond_path = fullfile(out_path, [file_name '_conductance.xlsx']);
    executionlog_path = fullfile(out_path, 'execution_log.xlsx');
   
    % Initialise arrays
    steady_out = strings(volt_steps, plotsNum);
    tail_out = strings(volt_steps, plotsNum);
    rise_out = strings(volt_steps, plotsNum);
    cond_out = strings(volt_steps, plotsNum);
   
    %% Calculations and file creation
    for i = 1:plotsNum
        % Calculate steady state current amplitude
        [s_row_start, s_row_end] = findTimes(time_col, plots_param{i, 3}, plots_param{i, 4});
        steady_out(:, i) = mean(data{i}(s_row_start:s_row_end, :), 1).';

        % Calculate tail current
        [t_row_start, t_row_end] = findTimes(time_col, plots_param{i, 5}, plots_param{i, 6});
        tail_out(:, i) = mean(data{i}(t_row_start:t_row_end, :), 1).';

        % Calculate rise time
        [row_start, row_end] = findTimes(time_col, plots_param{i, 1}, plots_param{i, 2});
        rise_data = [time_col(row_start:row_end, :) data{i}(row_start:row_end, :)];
        
        for j = 2:size(rise_data, 2)
            lo = rise_data(1, j);
            hi = rise_data(size(rise_data, 1), j);
            
            rise = hi - lo;
            subVal = lo + rise * sub;
            supVal = lo + rise * sup;
            
            [~, subInd] = min(abs(rise_data(:, j) - subVal));
            [~, supInd] = min(abs(rise_data(:, j) - supVal));
            
            rise_out(j-1, i) = abs(rise_data(supInd, 1) - rise_data(subInd, 1));
        end
        
        % Calculate conductance
        if conductance
            [c_row_value, ~] = findTimes(time_col, plots_param{i, 7}, plots_param{i, 7});
            current = data{i}(c_row_value,:);
            volt_inc = ceil((volt_end-volt_start)/volt_steps);
            voltage = volt_start:volt_inc:volt_end;
            cond = current./(voltage-eK);
            norm_cond = cond/max(cond);
            cond_out(:,i) = norm_cond;
            
            % Plot G/Gmax (conductance)
            f = figure('visible','off');
            plot(voltage, norm_cond, 'Color', '#2c7fb8', 'Marker', '.', 'MarkerSize', 10)
            
            % Label axes + title
            xlabel(strcat('Voltage (mV)'));
            ylabel(strcat('G/Gmax'));
            temp = strcat("Conductance Figure ", num2str(i), " - ", plot_labels{i});
            title(temp,'Interpreter','none'); % setting Interpreter to 'none' allows "_" in graph title

            % Save figure to file
            saveas(f, fullfile(out_path, temp),'jpg');
        end 
    end
    
    % Write data to spreadsheets
    writematrix([plot_labels; steady_out], steady_path, 'Range', 'A1');
    writematrix([plot_labels; tail_out], tail_path, 'Range', 'A1');
    writematrix([plot_labels; rise_out], rise_path, 'Range', 'A1');
    if conductance
        writematrix([plot_labels; cond_out], cond_path, 'Range', 'A1');
    end
    
    %% Create the execution log file
    if isempty(importSettings)
        dataFile = ["Data File:" data_path strings(1,6)];
    else
        dataFile = ["Data File:" data_path strings(1,6); 
                    "   Cells:" join(string(importSettings{1}), ", ") strings(1,6);
                    "   Sweeps:" importSettings{2} strings(1,6);
                    "   Iters:" importSettings{3} strings(1,6);
                    "   Test_pulse:" importSettings{4} strings(1,6)];
    end

    plotsIncl = strings(size(plot_labels, 2), 1);
    plotsExcl = strings((size(all_labels, 2) - size(plot_labels, 2)), 1);
    m = 1;
    n = 1;
    for k = 1:size(all_labels, 2)
        if any(ismember(plot_labels, all_labels(k)))
            plotsIncl(m, 1) = all_labels(k);
            m = m+1;
        else
            plotsExcl(n, 1) = all_labels(k);
            n = n+1;
        end
    end
    
    if isempty(plotsExcl)
        plotsExcl = "None";
    end
    
    if conductance
        conduct = ["Conductance Calculation:" "True" strings(1,6);
                   "   eK:" eK  strings(1,6)];
        plots = [["Plots Included:" "Rise start" "Rise end" "Steady start" "Steady end" "Tail start" "Tail end" "Conductance"];
                 [plotsIncl plots_param(:, 1:7)]];
    else
        conduct = ["Conductance Calculation:" "False" strings(1,6)];
        plots = [["Plots Included:" "Rise start" "Rise end" "Steady start" "Steady end" "Tail start" "Tail end" ""];
                 [plotsIncl plots_param(:, 1:6) strings(size(plotsIncl, 1),1)]];
    end
    
    executionFile = [["Output Folder:" out_path strings(1,6)];
        dataFile;
        ["Settings File:" settings_path strings(1,6)];
        ["Voltage (mV):" strings(1,7)];
        ["   Start:" volt_start strings(1,6)];
        ["   End:" volt_end strings(1,6)];
        ["   Steps:" volt_steps strings(1,6)];
        ["Current Scale:" current_scale strings(1,6)];
        conduct;
        ["Rise Time Percentages:" strings(1,7)];
        ["   Sub:" sub strings(1,6)];
        ["   Sup:" sup strings(1,6)];
        strings(1,8);
        ["Number of Plots:" plotsNum strings(1,6)];
        plots;
        ["Plots Excluded:" strings(1,7)];
        [plotsExcl strings(size(plotsExcl, 1),7)]
        ];
    writematrix(executionFile, executionlog_path, 'Range', 'A1');
    
end
