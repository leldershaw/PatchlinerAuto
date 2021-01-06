% LE 18th August 2020

%% Scales and gathers data for each plot and gives each a unique title
function [plots, titles] = gatherPlots(data, wells, wellValues, plot_labels, volt_steps, scale)
    
    % Scale conversion
    scales = {'micro', 'nano', 'pico'}; % data is orginally in nano
    scale_mults = {0.001, 1, 1000};
    scale_map = containers.Map(scales, scale_mults);
    
    % Gather data for each plot
    plots = cell(0);
    titles = cell(0);
    col_start = 2;
    count = 1;

    for j = 1:size(wellValues, 2)
        if wellValues(j)
            p = find(contains(plot_labels, wells{j}));
            
            for k = 1:size(p, 2)
                plot_end = (col_start + p(k) * volt_steps) - 1;
                plot_start = plot_end - (volt_steps - 1);
                
                % Scales data and stores according to plot
                plots{count} = data(:, plot_start:plot_end) * scale_map(scale);
                titles{count} = plot_labels(p(k));
                count = count + 1;
            end
        end
    end
end