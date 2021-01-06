% LE 14th June 2020

%% Saves graphs to JPG files
function save_figures(out_path, plots, plot_num, titles, time_col, time_scale, time_abbrev, current_scale)
    
    % Scale time column
    time_scaled = time_col * time_scale;
    
    for i = 1:plot_num
        data = plots{i};
        f = figure('visible','off');

        % Plotting data to figure
        for j = 1:size(data,2)
            plot(time_scaled, data(:,j), 'Color', '#2c7fb8');
            hold on;
        end
        hold off;
        
        % Label axes + title
        xlabel(strcat('Time (', time_abbrev, ')'));
        ylabel(strcat('Current (', current_scale, ')'));
        temp = strcat("Figure ", num2str(i), " - ", titles{i});
        title(temp,'Interpreter','none'); % setting Interpreter to 'none' allows "_" in graph title

        % Save figure to file
        saveas(f, fullfile(out_path, temp),'jpg');
    end
end
