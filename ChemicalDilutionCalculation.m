%% This code calculate how much chemicals should be used to get desired concentration

function ChemicalDilutionCalculation()
%CB: Chemical concentration before dilution in the unit of millimoles
%VB: Chemical volume needed before dilution in the unit of 1 uL
%CA: Chemical concentration after dilution in the unit of millimoles
%VA: Chemical volume after dilution in the unit of 1 uL

cx = 50; % calculator horizontal position
cy = 70; % calculator vertical position
cl = 600; % calculator length
cw = 400; % calculator width
FontSize = 13;
    % Create a figure
    
    fig = figure('Name', 'Chemical Dilution Calculation', 'NumberTitle', 'off', ...
                 'Position', [cx, cy, cl, cw], 'MenuBar', 'none');
             
    % Create text labels
    tlx = cl/100; %text labels x position
    tly = cw/6; %text labels y position
    tlw = cw/6; %text labels width
    tll = cw*3/5; %text labels length
    uicontrol('Style', 'text', 'String', 'Enter three known variables:', ...
              'Position', [tlx*15, tly*4.5, cw, cw/8],'FontSize',FontSize+2);
   
    str1 = (['Chemical concentration';'before dilution (mM) =']);
    str2 = (['   Chemical volume    ';'before dilution (uL) =']);
    str3 = (['Chemical concentration';' after dilution (mM) =']);
    str4 = (['   Chemical volume    ';' after dilution (uL) =']);

    uicontrol('Style', 'text', 'String', str1, 'Position', [tlx, tly*3, tll, tlw],'FontSize',FontSize);
    uicontrol('Style', 'text', 'String', str2, 'Position', [tlx, tly*2, tll, tlw],'FontSize',FontSize);
    uicontrol('Style', 'text', 'String', str3, 'Position', [tlx, tly*1, tll, tlw],'FontSize',FontSize);
    uicontrol('Style', 'text', 'String', str4, 'Position', [tlx, tly*0, tll, tlw],'FontSize',FontSize);
    
    ifx = 39*tlx; %input fields x position
    ify = cy*0.45; %compensation of y position
    ifl = tll/3; %input fields length   
    ifw = cw/13; %input fields width

    % Create input fields
    edit_CB = uicontrol('Style', 'edit', 'Position', [ifx, ify+tly*3, ifl, ifw],'FontSize',FontSize);
    edit_VB = uicontrol('Style', 'edit', 'Position', [ifx, ify+tly*2, ifl, ifw],'FontSize',FontSize);
    edit_CA = uicontrol('Style', 'edit', 'Position', [ifx, ify+tly*1, ifl, ifw],'FontSize',FontSize);
    edit_VA = uicontrol('Style', 'edit', 'Position', [ifx, ify+tly*0, ifl, ifw],'FontSize',FontSize);
    
    % Create a button to calculate
    btn_calculate = uicontrol('Style', 'pushbutton', 'String', 'Calculate', ...
                              'Position', [70*tlx, ify+tly*0, ifl, tlw*0.8],'FontSize',FontSize, ...
                              'Callback', @calculateCallback);
    
    btn_reset = uicontrol('Style', 'pushbutton', 'String', 'Reset', ...
                          'Position', [70*tlx, ify+tly*2, ifl, tlw*0.8],'FontSize',FontSize, ...
                          'Callback', @resetCallback);

    % Function to calculate the missing variable
    function calculateCallback(~, ~)
        CB = str2double(get(edit_CB, 'String'));
        VB = str2double(get(edit_VB, 'String'));
        CA = str2double(get(edit_CA, 'String'));
        VA = str2double(get(edit_VA, 'String'));
        % CB*VB = CA*VA;
        if ~isnan(CB) && ~isnan(VB) && ~isnan(CA) && isnan(VA)
            VA = CB*VB/CA;
            set(edit_VA, 'String', num2str(VA));
        elseif ~isnan(VB) && ~isnan(CB) && ~isnan(VA) && isnan(CA)
            CA = CB*VB/VA;
            set(edit_CA, 'String', num2str(CA));
        elseif ~isnan(VB) && ~isnan(CA) && ~isnan(VA) && isnan(CB)
            CB = CA*VA/VB;
            set(edit_CB, 'String', num2str(CB));
        elseif ~isnan(CB) && ~isnan(CA) && ~isnan(VA) && isnan(VB)
            VB = CA*VA/CB;
            set(edit_VB, 'String', num2str(VB));
        else
            msgbox('Please provide three known variables and leave one empty.', 'Error', 'error');
        end
    end

    % Function to reset all variables
    function resetCallback(~, ~)
        set(edit_VA, 'String', '');
        set(edit_VB, 'String', '');
        set(edit_CA, 'String', '');
        set(edit_CB, 'String', '');

    end
end