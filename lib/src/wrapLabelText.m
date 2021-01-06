% Adapted from: Chad Greene (2020). wraptext (https://www.mathworks.com/matlabcentral/fileexchange/53176-wraptext), MATLAB Central File Exchange. 
% Retrieved 26th March, 2020.

%% Wrap Text onto Multiple Lines (for labels)
% Converts GUIDE function to App Designer
function wrapLabelText(label, txt)
    % Create a uicontrol whose text will look like that of the label.
    h = uicontrol( ...
    'Style', 'Text', ...
    'Parent', figure('Visible', 'off'), ... % Make sure the containing figure is invisible.
    'Position', label.Position, ...
    'FontUnits', 'pixels', ... % By default App Designer uses 'pixels' but uicontrol uses 'points'. Define before the FontSize!
    'FontSize', label.FontSize, ...
    'FontName', label.FontName, ...
    'FontAngle', label.FontAngle, ...
    'FontWeight', label.FontWeight, ...
    'HorizontalAlignment', label.HorizontalAlignment ...
    );

    % Determine where the text will be wrapped.
    outtext = textwrap(h, {txt});
    delete(h);

    % Assign the text to the label.
    label.Text = outtext;
end