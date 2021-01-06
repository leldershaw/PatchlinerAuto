% LE 7th November 2019

%% Finds the rows in the data matching an interval's start and end time
function [row_start, row_end] = findTimes(time_col, time_start, time_end)
    [~,row_start] = ismember(time_start, time_col);
    [~,row_end] = ismember(time_end, time_col); 

    if ~row_start
        error('MATLAB:findTimes:startTimeNotFound',...
       'ERROR: Cannot find start time %g in time column of data.', time_start);
    end
    if ~row_end
        error('MATLAB:findTimes:endTimeNotFound',...
       'ERROR: Cannot find end time %g in time column of data.', time_end);
    end
end
