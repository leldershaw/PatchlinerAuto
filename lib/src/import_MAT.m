% LE 18th August 2020 - Adapted from original code (FilterCM.m) used by Petrou Lab to produce 'Unfiltered' data

% Input Parameters:
%   filename : mat file name (*.mat)
%   cells : array of cells successfully patched
%   sweeps: number of sweeps per cell
%   iters: applied pharmocology runs
%   test_pulse: true/false

%% Imports data from .mat file into format with well labels + time column
function dataOut = import_MAT(filename, cells, sweeps, iters, test_pulse)
    % Load data from .mat file
    S = load(filename);
    cells = find(cells);
    trace_length = length(eval(['S.Trace_1_',num2str(iters), '_1_',num2str(cells(1))]));
    
    CellDatUnFilt = zeros(trace_length, sweeps*size(cells, 2));
    time = 0:1:trace_length-1; % Integers incrementing by 1
    cell_no = 1;
    label_no = 1;
    labels = strings(1, sweeps*size(cells, 2));
    
    % Format trace data with well labels
    for i = cells
        for iter = 1+test_pulse:iters
            for j = 1:sweeps
                try 
                    dataIn = eval(['S.Trace_1_',num2str(iter), '_',num2str(j),'_',num2str(i),'(:,2)']);
                    % Add well label + Pharm label
                    labels(label_no) = strcat('Well_', num2str(i), '_Pharm_', num2str(iter)); 
                catch 
                    continue;
                end
                
                CellDatUnFilt(:,label_no)=dataIn*10^9; % Convert data to nano
                label_no = label_no+1;
            end
        end
        cell_no = cell_no+1;
    end
    dataOut = [["Time(ms)" labels]; time.' CellDatUnFilt]; % Add time column
end