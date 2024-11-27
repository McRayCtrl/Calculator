% This code calculate how long a 2 by 4 should be cut to fit in Z shape structure
% Author: Qing Wang
% Date: 11/25/2024

function cut2by4()

cx = 10; % calculator horizontal position
cy = 50; % calculator vertical position
cl = 800; % calculator length
cw = 600; % calculator width
FontSize = 15;

% HBL: Horizontal bars length.
% BD: Distance between upper horizontal bar and lower horizontal bar
% DBL: Diagonal bar length
% MD: Mark distance

    % Create a figure
    fig = figure('Name', 'cut2by4', 'NumberTitle', 'off', ...
                 'Position', [cx, cy, cl, cw], 'MenuBar', 'none');
             
    % Create text labels
    tlx = cl/100; %text labels x position
    tly = cw/6; %text labels y position
    tlw = cw/6; %text labels width
    tll = cw*3/5; %text labels length
    uicontrol('Style', 'text', 'String', 'Enter Z shape Structure info:', ...
              'Position', [tlx*5, tly*4.5, cw*3/5, cw/8],'FontSize',FontSize+2);
    
    str1 = ('Horizontal bars length (inches) =');
    str2 = ('Distance between horizontal bars (inches) =');
    str3 = ('Marks distance (inches) =');
    str4 = ('Diagonal bar length (inches) =');

    uicontrol('Style', 'text', 'String', str1, 'Position', [tlx, tly*3, tll, tlw],'FontSize',FontSize);
    uicontrol('Style', 'text', 'String', str2, 'Position', [tlx, tly*2, tll, tlw],'FontSize',FontSize);
    uicontrol('Style', 'text', 'String', str3, 'Position', [tlx, tly*1, tll, tlw],'FontSize',FontSize);
    uicontrol('Style', 'text', 'String', str4, 'Position', [tlx, tly*0, tll, tlw],'FontSize',FontSize);

    ifx = 45*tlx; %input fields x position
    ify = cy*0.9; %compensation of y position
    ifl = tll/3; %input fields length   
    ifw = cw/13; %input fields width

    % Create input fields
    edit_HBL = uicontrol('Style', 'edit', 'Position', [ifx, ify+tly*3, ifl, ifw],'FontSize',FontSize);
    edit_BD = uicontrol('Style', 'edit', 'Position', [ifx, ify+tly*2, ifl, ifw],'FontSize',FontSize);
    edit_MD = uicontrol('Style', 'edit', 'Position', [ifx, ify+tly*1, ifl, ifw],'FontSize',FontSize);
    edit_DBL = uicontrol('Style', 'edit', 'Position', [ifx, ify+tly*0, ifl, ifw],'FontSize',FontSize);
    
    % Create a button to calculate
    btn_calculate = uicontrol('Style', 'pushbutton', 'String', 'Calculate', ...
                              'Position', [70*tlx, ify+tly*0, ifl, tlw*0.8],'FontSize',FontSize, ...
                              'Callback', @calculateCallback);
    
    btn_reset = uicontrol('Style', 'pushbutton', 'String', 'Reset', ...
                          'Position', [70*tlx, ify+tly*2, ifl, tlw*0.8],'FontSize',FontSize, ...
                          'Callback', @resetCallback);

    % Function to calculate the variable
    function calculateCallback(~, ~)
        HBL = str2double(get(edit_HBL, 'String'));
        BD = str2double(get(edit_BD, 'String'));
        MD = str2double(get(edit_MD, 'String'));
        DBL = str2double(get(edit_DBL, 'String'));

        if ~isnan(HBL) && ~isnan(BD) && isnan(MD) && isnan(DBL) 

            bl = HBL; % bar length
            bd = BD; % bar distance

            h = 1.5; % 2 inches actual size
            w = 3.5; % 4 inches actual size

            N = 10*bd+1; % resolution
            mN = 1000;
            ub = bd/2.*ones(1,N); % upper bar
            ub2 = (bd/2+w).*ones(1,N); % upper bar 2
            lb = -bd/2.*ones(1,N); % lower bar
            lb2 = -(bd/2+w).*ones(1,N); % lower bar 2

            x = linspace(-bl/2,bl/2,N);
            
            m = (bd/bl); %slope of diagonal bar
          
            db = m.*x; % diagonal bar
            b = (w/2)*(sqrt(m^2+1)); % y intercept
            db1 = m.*x+b; % diagonal bar
            db2 = m.*x-b; % diagonal bar

            sp = 0.1; % start point
            ep = 10; % end point

            mv = linspace(m*sp,m*ep,mN); %slope variable of diagonal bar

            dbm=zeros(length(mv),N);
            bm=zeros(length(mv),N);
            db1m=zeros(length(mv),N);
            db2m=zeros(length(mv),N);

            df = inf(1,mN); % difference of diagonal bar end side to top bar

            for ii = 1:mN
                dbm(ii,:) = mv(ii).*x; % diagonal bar
                bm(ii,:) = (w/2)*(sqrt(mv(ii)^2+1)); % y intercept
                db1m(ii,:) = mv(ii).*x+bm(ii,:); % diagonal bar
                db2m(ii,:) = mv(ii).*x-bm(ii,:); % diagonal bar

                df(ii) = abs(db2m(ii,end)-bd/2);

            end

            [mmv, jj] = min(df(:)); %find minimum of mv and index of this minimum

            nm = mv(jj); % new slope
            thetar = atan(nm); % new slope angle in radian
            thetad = 180*thetar/pi; % new slope angle in degree

            dbl = bl*sqrt(nm^2+1)-nm*w; % diagonal bar length
            mp = w/nm; % marked position
            
            MD = mp;
            DBL = dbl;

            set(edit_DBL, 'String', num2str(DBL));
            set(edit_MD, 'String', num2str(MD));

            figure(2);
            set(gcf,'Position', [820 60 1500 700])

            subplot(1,2,1)
            plot(x,ub,'o')
            hold on
            plot(x,lb,'o')
            plot(x,ub2,'o')
            plot(x,lb2,'o')
            ylim([-bd*1.5 bd*1.5])
            xlim([-bl*1.5 bl*1.5])
            pbaspect([1 m 1])

            plot(x,db,'o')
            plot(x,db1,'o')
            plot(x,db2,'o')
            hold off

            subplot(1,2,2)
            plot(x,ub,'o')
            hold on
            plot(x,lb,'o')
            plot(x,ub2,'o')
            plot(x,lb2,'o')

            plot(x,dbm(jj,:),'o')
            plot(x,db1m(jj,:),'o')
            plot(x,db2m(jj,:),'o')

            ylim([-bd*1.5 bd*1.5])
            xlim([-bl*1.5 bl*1.5])

            pbaspect([1 m 1])
        else
            msgbox('Please provide Z shape structure info.', 'Error', 'error');
        end
    end

    % Function to reset all variables
    function resetCallback(~, ~)
        set(edit_HBL, 'String', '');
        set(edit_BD, 'String', '');
        set(edit_MD, 'String', '');
        set(edit_DBL, 'String', '');

    end

end