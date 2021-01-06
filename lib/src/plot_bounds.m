% LE 29th November 2020

%% Plots bounds for time intervals onto UIAxes
function plot_bounds(data, time_col, time_scale, time_start, time_end, s_start, s_end, t_start, t_end, c_value, conductance, UIAxes)
    
    % Rise-time box (black)
    [row_start, row_end] = findTimes(time_col, time_start, time_end);
    r_minVal = min(data(row_start:row_end, :), [], 'all');
    r_maxVal = max(data(row_start:row_end, :), [], 'all');
    rectangle(UIAxes, 'Position', [time_start*time_scale, r_minVal, time_end*time_scale-time_start*time_scale, r_maxVal-r_minVal], 'EdgeColor', 'k', 'LineWidth', 1.5);

    % Steady state current amplitude box (red)
    [s_row_start, s_row_end] = findTimes(time_col, s_start, s_end);
    s_minVal = min(data(s_row_start:s_row_end, :), [], 'all');
    s_maxVal = max(data(s_row_start:s_row_end, :), [], 'all');
    rectangle(UIAxes, 'Position', [s_start*time_scale, s_minVal, s_end*time_scale-s_start*time_scale, s_maxVal-s_minVal], 'EdgeColor','r', 'LineWidth', 1.5);
    hold(UIAxes, 'on');

    % Tail box (green)
    [t_row_start, t_row_end] = findTimes(time_col, t_start, t_end);
    t_minVal = min(data(t_row_start:t_row_end, :), [], 'all');
    t_maxVal = max(data(t_row_start:t_row_end, :), [], 'all');
    rectangle(UIAxes, 'Position', [t_start*time_scale, t_minVal, t_end*time_scale-t_start*time_scale, t_maxVal-t_minVal], 'EdgeColor','g', 'LineWidth', 1.5);
    hold(UIAxes, 'on');
    
    % Conductance line (pink)
    if conductance
        c_minVal = min(data, [], 'all');
        c_maxVal = max(data, [], 'all');
        line(UIAxes, [c_value*time_scale, c_value*time_scale], [c_minVal, c_maxVal], 'Color', 'm', 'LineWidth', 2.25);
        hold(UIAxes, 'on');
    end
    
end