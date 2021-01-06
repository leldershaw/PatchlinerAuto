% LE 13th June 2020

%% Imports and identifies wells for data
function [data, plot_labels, time_col, time_max] = initialiseData(data_path, dataOut, volt_steps)
         
    % Import data
    if isequal(dataOut, 0)
        data_file = importdata(data_path);
        data = data_file.data;
        headers = data_file.colheaders;
    else
        data = str2double(dataOut(2:length(dataOut),:));
        headers = cellstr(dataOut(1,:));
    end
        
    % Plot parameters
    col_start = 2;
    
    % Identify time column
    time_col = data(:, 1);
    time_max = time_col(size(time_col,1));
    
    % Identify wells in data
    plots_num = floor((size(data,2)-1)/volt_steps);
    plot_labels = strings(1, plots_num);
    for i = 1:plots_num
        plot_labels(i) = headers(col_start);
        col_start = col_start + volt_steps;
    end
end
