%% This code calculate how much chemicals should be used to get desired concentration

function ChemicalMolarWeightCalculation()
%Mass: mass on scale in the unit of milligrams.
%MW: Molar weight of chemical in the unit of gram per mole
%C: Chemical concentration wanted in the unit of millimolar
%V: Chemical final solution volume in the unit of 1 uL
% Mass = MW*C*V/1e6;

% Reference: urea 13C 99% MW: 61.05
%            pyruvic-1-13C acid 99% MW: 89.05

cx = 200; % calculator horizontal position
cy = 70; % calculator vertical position
cl = 900; % calculator length
cw = 600; % calculator width
FontSize = 15;
    % Create a figure
    fig = figure('Name', 'Chemical Molar Weight Calculation', 'NumberTitle', 'off', ...
                 'Position', [cx, cy, cl, cw], 'MenuBar', 'none');
             
    % Create text labels
    tlx = cl/100; %text labels x position
    tly = cw/6; %text labels y position
    tlw = cw/6; %text labels width
    tll = cw*3/5; %text labels length
    uicontrol('Style', 'text', 'String', 'Enter three known variables:', ...
              'Position', [tlx*5, tly*4.5, cw*3/5, cw/8],'FontSize',FontSize+2);
    uicontrol('Style', 'text', 'String', 'Reference', ...
              'Position', [tlx*55, tly*5, cw*3/5, cw/8],'FontSize',FontSize-1);
    uicontrol('Style', 'text', 'String', '1-13C Pyruvic Acid MW: 89.05g/mol', ...
              'Position', [tlx*55, tly*4.5, cw*3/5, cw/8],'FontSize',FontSize-1);
    uicontrol('Style', 'text', 'String', 'Urea-13C MW: 61.05g/mol', ...
              'Position', [tlx*55, tly*4, cw*3/5, cw/8],'FontSize',FontSize-1);

    str1 = ('mass on scale (mg) =');
    str2 = ('Molar weight (g/mol) =');
    str3 = ('Chemical concentration (mM) =');
    str4 = (['Chemical volume (',char(956),'L)']);

    uicontrol('Style', 'text', 'String', str1, 'Position', [tlx, tly*3, tll, tlw],'FontSize',FontSize);
    uicontrol('Style', 'text', 'String', str2, 'Position', [tlx, tly*2, tll, tlw],'FontSize',FontSize);
    uicontrol('Style', 'text', 'String', str3, 'Position', [tlx, tly*1, tll, tlw],'FontSize',FontSize);

    % uicontrol('Style', 'text', 'String', 'Chemical volume (μL) =', 'Position', [tlx, tly*0, tll, tlw],'FontSize',FontSize);
    uicontrol('Style', 'text', 'String', str4, 'Position', [tlx, tly*0, tll, tlw],'FontSize',FontSize);
    
    ifx = 38*tlx; %input fields x position
    ify = cy*0.9; %compensation of y position
    ifl = tll/3; %input fields length   
    ifw = cw/13; %input fields width

    % Create input fields
    edit_Mass = uicontrol('Style', 'edit', 'Position', [ifx, ify+tly*3, ifl, ifw],'FontSize',FontSize);
    edit_MW = uicontrol('Style', 'edit', 'Position', [ifx, ify+tly*2, ifl, ifw],'FontSize',FontSize);
    edit_C = uicontrol('Style', 'edit', 'Position', [ifx, ify+tly*1, ifl, ifw],'FontSize',FontSize);
    edit_V = uicontrol('Style', 'edit', 'Position', [ifx, ify+tly*0, ifl, ifw],'FontSize',FontSize);
    
    % Create a button to calculate
    btn_calculate = uicontrol('Style', 'pushbutton', 'String', 'Calculate', ...
                              'Position', [70*tlx, ify+tly*0, ifl, tlw*0.8],'FontSize',FontSize, ...
                              'Callback', @calculateCallback);
    
    btn_reset = uicontrol('Style', 'pushbutton', 'String', 'Reset', ...
                          'Position', [70*tlx, ify+tly*2, ifl, tlw*0.8],'FontSize',FontSize, ...
                          'Callback', @resetCallback);

    % Function to calculate the missing variable
    function calculateCallback(~, ~)
        Mass = str2double(get(edit_Mass, 'String'));
        MW = str2double(get(edit_MW, 'String'));
        C = str2double(get(edit_C, 'String'));
        V = str2double(get(edit_V, 'String'));
        % Mass = MW*C*V/1e6;
        if ~isnan(Mass) && ~isnan(MW) && ~isnan(C) && isnan(V)
            V = Mass*1e6 / (MW * C);
            set(edit_V, 'String', num2str(V));
        elseif ~isnan(Mass) && ~isnan(MW) && isnan(C) && ~isnan(V)
            C = Mass*1e6  / (MW * V);
            set(edit_C, 'String', num2str(C));
        elseif ~isnan(Mass) && isnan(MW) && ~isnan(C) && ~isnan(V)
            MW = Mass*1e6  / (C * V);
            set(edit_MW, 'String', num2str(MW));
        elseif isnan(Mass) && ~isnan(MW) && ~isnan(C) && ~isnan(V)
            Mass = MW * C * V/1e6;
            set(edit_Mass, 'String', num2str(Mass));
        else
            msgbox('Please provide three known variables and leave one empty.', 'Error', 'error');
        end
    end

    % Function to reset all variables
    function resetCallback(~, ~)
        set(edit_Mass, 'String', '');
        set(edit_MW, 'String', '');
        set(edit_C, 'String', '');
        set(edit_V, 'String', '');

    end
end