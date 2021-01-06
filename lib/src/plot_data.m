% LE 13th June 2020

%% Plots graph data onto UIAxes
function plot_data(data, time_col, time_scale, UIAxes)
    
    % Scale time column
    time_scaled = time_col * time_scale;
    
    % Plot to UIAxes
    for i = 1:size(data,2)
        plot(UIAxes, time_scaled, data(:,i), 'Color', '#2c7fb8');
        hold(UIAxes, 'on');
    end
end
