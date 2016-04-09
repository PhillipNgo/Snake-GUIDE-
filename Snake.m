% Snake
% Phillip Ngo
% CONTROLS: WASD or Arrow Keys
%{
    The majority of code is actually just programming for the ARCADE MODE ]
    feature. There are a few glitches when playing arcade mode but otherwise
    the game is complete. The code probably makes no sense to anyone, I 
    didn't really comment it.

    Features:
        Arcade Mode: 
            1. Two Growth squares instead of one
            2. PLUS sign greatly increases score but not length
            3. TRIANGLE sign greatly increases length but not score
            4. X signs are an obstacle that ends the game if the user runs
               into them.
            5. Moving Squares are also obstacles that end the game if the
               user runs into them

        No Walls: Let's the user run into the walls without losing and come
                  out on the other side.
%}

%% Initialize Gui
function varargout = Snake(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Snake_OpeningFcn, ...
    'gui_OutputFcn',  @Snake_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function Snake_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<INUSL>

    handles.output = hObject;
    axes(handles.axes1);
    handles.map = 'Classic';
    handles.speed = .035;

    handles.staticTexts = [handles.titleText handles.themesText handles.scoreText handles.scoresText ...
                   handles.lengthText handles.lengthsText handles.directionsText ...
                   handles.difficultyText handles.pauseText handles.wallsCheck handles.arcadeCheck ...
                   handles.obstacleText];
    for i = 1:length(handles.staticTexts)
        set(handles.staticTexts(i), 'BackgroundColor', [0.5625 0.9297 0.5625]);
    end
    handles.wallCheck = false;
    handles.arcCheck = false;
    handles.pointColor = 'black';
    handles.snakeColor = 'black';
    handles.outlineColor = 'black';
    handles.boonColor = 'black';
    handles.obstacleColor = 'black';
    handles.oppColor = 'r';
    handles.obstaclex = -11;
    handles.obstacley = -11;
    hold on
    plot([-10 10 10 -10 -10], [-10 -10 10 10 -10], 's-', 'Color' ,handles.outlineColor, 'LineWidth', 2)
    %plot([10 -10 -10], [10 10, -10], '-', 'Color', handles.outlineColor, 'Linewidth', 3)
    axis([-10 10 -10 10])
    box off
    set(gca, 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', [], 'Color', [0.8750 1.0000 1.0000]);
    set(gcf, 'Color', [0.5625 0.9297 0.5625]);
    guidata(hObject, handles);
    

function varargout = Snake_OutputFcn(hObject, eventdata, handles) %#ok<INUSL>
    varargout{1} = handles.output;

    
%% Methods
function z = check(x, y)
    z = true;
    for i = 1:length(x)-1
        if x(length(x)) == x(i) && y(length(y)) == y(i)
            z = false;
        end
    end

    
function z = checkP(x, y, a, b)
    z = true;
    for i = 1:length(x)-1
        for j = 1:length(a)
            if a(j) == x(i) && b(j) == y(i)
                z = false;
            end
        end
    end
    
    
function v = insertx(x, w)
    v = [];
    for i = 4:length(x) + 3
        v(i) = x(i-3);
    end
    switch w
        case 'w'
            v(3) = v(4);
            v(2) = v(3);
            v(1) = v(2);
        case 'a'
            v(3) = v(4) + .5;
            v(2) = v(3) + .5;
            v(1) = v(2) + .5;
        case 's'
            v(3) = v(4);
            v(2) = v(3);
            v(1) = v(2);
        case 'd'
            v(3) = v(4) - .5;
            v(2) = v(3) - .5;
            v(1) = v(2) - .5;
    end
    
    
function v = inserty(x, w)
    v = [];
    for i = 4:length(x) + 3
        v(i) = x(i-3);
    end
    switch w
        case 'w'
            v(3) = v(4) - .5;
            v(2) = v(3) - .5;
            v(1) = v(2) - .5;
        case 'a'
            v(3) = v(4);
            v(2) = v(3);
            v(1) = v(2);
        case 's'
            v(3) = v(4) + .5;
            v(2) = v(3) + .5;
            v(1) = v(2) + .5;
        case 'd'
            v(3) = v(4);
            v(2) = v(3);
            v(1) = v(2);     
    end

    
function x = movex(x, w, hObject)
    data = guidata(hObject);
    for i = 1:length(x)-1
        x(i) = x(i + 1);
    end
    switch w
        case 'a'
            x(length(x)) = x(length(x)) - .5;
        case 'd'
            x(length(x)) = x(length(x)) + .5;

    end
    if data.wallCheck == true
        switch x(length(x))
            case 10
                x(length(x)) = -9.5;
            case -10
                x(length(x)) = 9.5;
        end
    end
    

function y = movey(y, w, hObject)
    data = guidata(hObject);
    for i = 1:length(y)-1
        y(i) = y(i + 1);
    end
    switch w
        case 'w'
            y(length(y)) = y(length(y)) + .5;
        case 's'
            y(length(y)) = y(length(y)) - .5;
    end
    if data.wallCheck == true
        switch y(length(y))
            case 10
                y(length(y)) = -9.5;
            case -10
                y(length(y)) = 9.5;
        end
    end
    
    
%% Callback Functions
function StartButton_Callback(hObject, eventdata, handles) %#ok<*DEFNU,INUSL>

    data = guidata(hObject);
    if exist('leaders.mat', 'file') == 2
        load('leaders')
    else
        lnames = [];
        lscores = [];
        llengths = [];
        lmap = [];
        larc = [];
        lwall = [];
    end
    axes(handles.axes1);
    counter = 0;
    gameover = false;
    p = data.speed;
    set(gcf,'CurrentCharacter', 'i')
    q = '';
    x = 0;
    y = 0;
    map = data.map;
    obx = data.obstaclex;
    oby = data.obstacley;
    xvals = [-.5 -1 -1.5 -2 -2.5 -3 -3.5 -4 -4.5 -5 -5.5 -6 -6.5 -7 -7.5 -8 -8.5 -9 -9.5 ...
               0 .5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5];
    yvals = [-.5 -1 -1.5 -2 -2.5 -3 -3.5 -4 -4.5 -5 -5.5 -6 -6.5 -7 -7.5 -8 -8.5 -9 -9.5 ...
               0 .5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5];
    arcades = get(handles.arcadeCheck, 'Value');
    if get(handles.arcadeCheck, 'Value') == 1
        data.arcCheck = true;
        pointx = [xvals(randi(39)) xvals(randi(39))];
        pointy = [yvals(randi(39)) yvals(randi(39))];
        boon = [15 15];
        boonp = [14 14];
        crossx = [13 13 13 13 13 13];
        crossy = [12 12 12 12 12 12];
        matchx = [11 11 11 11 11 11];
        matchy = [11 11 11 11 11 11];
        boonTime = 100;
        boonpTime = 100;
        crossTime = 0;
        roamx = [xvals(randi(39)) xvals(randi(39)) xvals(randi(39)) xvals(randi(39))];
        roamy = [yvals(randi(39)) yvals(randi(39)) yvals(randi(39)) yvals(randi(39))];
        roamCheck = '1';
    elseif get(handles.arcadeCheck, 'Value') == 0
        data.arcCheck = false;
        pointx = xvals(randi(39));
        pointy = yvals(randi(39));
    end

    while ~checkP(obx, oby, pointx(1), pointy(1))
        pointx(1) = xvals(randi(39));
        pointy(1) = yvals(randi(39));
    end
    while ~checkP(obx, oby, pointx(length(pointx)), pointy(length(pointy)))
        pointx(length(pointx)) = xvals(randi(39));
        pointy(length(pointy)) = yvals(randi(39));
    end
    wallss = get(handles.wallsCheck, 'Value');
    if get(handles.wallsCheck, 'Value') == 1
        walls = length(x) >= 1;
        data.wallCheck = true;
    elseif get(handles.wallsCheck, 'Value') == 0
        walls = x(length(x)) ~= 10 && x(length(x)) ~= -10 && y(length(y)) ~= 10 && y(length(y)) ~= -10;
        data.wallCheck = false;
    end
    move = 1;
    guidata(hObject, data);
    while check(x, y) && walls && gameover == false && checkP(obx, oby, x(length(x)), y(length(y)))
        cla
        hold on
        plot(pointx, pointy, 's', 'Color', data.pointColor, 'LineWidth', 2)

        if x(length(x)) == pointx(1) && y(length(y)) == pointy(1)  ...
           || x(length(x)) == pointx(length(pointx)) && y(length(y)) == pointy(length(pointy))
            counter = counter + 1;
            if x(length(x)) == pointx(length(pointx)) && y(length(y)) == pointy(length(pointy))
                points = 0;
                pointx(length(pointx)) = xvals(randi(39));
                pointy(length(pointy)) = yvals(randi(39));
            elseif x(length(x)) == pointx(1) && y(length(y)) == pointy(1)
                points = 1;
                pointx(1) = xvals(randi(39));
                pointy(1) = yvals(randi(39));
            end
            while ~checkP(x, y, pointx, pointy) || ~checkP(obx, oby, pointx(length(pointx)), pointy(length(pointy))) ...
                    || ~checkP(obx, oby, pointx(1), pointy(1))
                if points == 0
                    pointx(length(pointx)) = xvals(randi(39));
                    pointy(length(pointy)) = yvals(randi(39));
                else
                    pointx(1) = xvals(randi(39));
                    pointy(1) = yvals(randi(39));
                end
            end
                plot(pointx, pointy, 's', 'Color', data.pointColor, 'LineWidth', 2)
                x = insertx(x, q);  
                y = inserty(y, q);
        end
        set(gcf, 'KeyPressFcn', @(x,y)get(gcf,'CurrentCharacter'))
        z = get(gcf, 'CurrentCharacter');
        switch z 
            case 28
                z = 'a';
            case 29
                z = 'd';
            case 30
                z = 'w';
            case 31
                z = 's';
            otherwise
        end
        x = movex(x, q, hObject);
        y = movey(y, q, hObject);
        if length(x) == 1 ...
                || ~strcmp(q, 's') && strcmp(z, 'w') ... 
                || ~strcmp(q, 'd') && strcmp(z, 'a') ...
                || ~strcmp(q, 'w') && strcmp(z, 's') ...
                || ~strcmp(q, 'a') && strcmp(z, 'd') 
            q = z;
        end

        if data.arcCheck == true
            if length(x) + counter >= 80
                if length(x) + counter >= 80 && x(length(x)) == roamx(1) && y(length(y)) == roamy(1) ...
                   || length(x) + counter >= 120 && x(length(x)) == roamx(2) && y(length(y)) == roamy(2) ...
                   || length(x) + counter >= 160 && x(length(x)) == roamx(3) && y(length(y)) == roamy(3) ...
                   || length(x) + counter >= 210 && x(length(x)) == roamx(3) && y(length(y)) == roamy(3)
                gameover = true;
                end
                if move >= p*3 && gameover == false;
                    for i = 1:4
                        roamxx = roamx(i);
                        roamyy = roamy(i);
                        wasd = randi(4);
                            switch wasd
                                case 1
                                    roamy(i) = movey(roamy(i), 'w', hObject);
                                    roamCheck = 'w';
                                case 2
                                    roamx(i) = movex(roamx(i), 'a', hObject);
                                    roamCheck = 'a';
                                case 3
                                    roamy(i) = movey(roamy(i), 's', hObject);
                                    roamCheck = 's';
                                case 4
                                    roamx(i) = movex(roamx(i), 'd', hObject);
                                    roamCheck = 'd';
                            end
                        while ~checkP(x, y, roamx(i), roamy(i)) || ~checkP(obx, oby, roamx(i), roamy(i)) ...
                                || ~checkP(crossx, crossy, roamx(i), roamy(i))
                            roamx(i) = roamxx;
                            roamy(i) = roamyy;
                            wasd = randi(4);
                            switch wasd
                                case 1
                                    roamy(i) = movey(roamy(i), 'w', hObject);
                                case 2
                                    roamx(i) = movex(roamx(i), 'a', hObject);
                                case 3
                                    roamy(i) = movey(roamy(i), 's', hObject);
                                case 4
                                    roamx(i) = movex(roamx(i), 'd', hObject);
                            end
                        end
                    end
                    move = 0;
                end
                move = move + p;
                if length(x) + counter >= 210
                    plot(roamx, roamy, 's', 'Color', data.oppColor, 'LineWidth', 3)
                elseif length(x) + counter >= 160
                    plot(roamx([1 2 3]), roamy([1 2 3]), 's', 'Color', data.oppColor, 'LineWidth', 3)
                elseif length(x) + counter >= 120
                    plot(roamx([1,2]), roamy([1,2]), 's', 'Color', data.oppColor, 'LineWidth', 3)
                else
                    plot(roamx(1), roamy(1), 's', 'Color', data.oppColor, 'LineWidth', 3)
                end
            end

            if length(x) >= 31 && counter >= 10
                if ~checkP(crossx, crossy, x(length(x)), y(length(y)))
                    gameover = true;
                end
                if gameover == false 
                    if crossTime > 15 && matchx(6) ~= crossx(6) && matchy(6) ~= crossy(6)
                        crossx(6) = xvals(randi(39));
                        crossy(6) = yvals(randi(39));
                        matchx(6) = crossx(6);
                        matchy(6) = crossy(6);
                    elseif crossTime > 12 && matchx(5) ~= crossx(5) && matchy(5) ~= crossy(5)
                        crossx(5) = xvals(randi(39));
                        crossy(5) = yvals(randi(39));
                        matchx(5) = crossx(5);
                        matchy(5) = crossy(5);
                    elseif crossTime > 9 && matchx(4) ~= crossx(4) && matchy(4) ~= crossy(4)
                        crossx(4) = xvals(randi(39));
                        crossy(4) = yvals(randi(39));
                        matchx(4) = crossx(4);
                        matchy(4) = crossy(4);
                    elseif crossTime > 6 && matchx(3) ~= crossx(3) && matchy(3) ~= crossy(3)
                        crossx(3) = xvals(randi(39));
                        crossy(3) = yvals(randi(39));
                        matchx(3) = crossx(3);
                        matchy(3) = crossy(3);
                    elseif crossTime > 3 && matchx(2) ~= crossx(2) && matchy(2) ~= crossy(2)
                        crossx(2) = xvals(randi(39));
                        crossy(2) = yvals(randi(39));
                        matchx(2) = crossx(2);
                        matchy(2) = crossy(2);
                    elseif crossTime >= 0 && matchx(1) ~= crossx(1) && matchy(1) ~= crossy(1)
                        crossx(1) = xvals(randi(39));
                        crossy(1) = yvals(randi(39));
                        matchx(1) = crossx(1);
                        matchy(1) = crossy(1);
                    end
                    for i = 1:length(crossx)
                         while ~checkP(x, y, crossx(i), crossy(i)) || ~checkP(obx, oby, crossx(i), crossy(i))
                             crossx(i) = xvals(randi(39));
                             crossy(i) = yvals(randi(39));
                         end
                    end
                end
                if crossTime > 18
                    crossTime = .0001;
                    matchx = [11 11 11 11 11 11];
                    matchy = [11 11 11 11 11 11];
                end
            end

            boonRand = randi(100);
            if boonRand == 25 && boonTime > 4 ...
                    || x(length(x)) == boon(1) && y(length(y)) == boon(2)
                boonTime = 0;
                if x(length(x)) == boon(1) && y(length(y)) == boon(2)
                    for i = 1:3
                        x = insertx(x, q);
                        y = inserty(y, q);
                    end
                    boon = [15 15];
                end
                if boonRand == 25
                    boon = [xvals(randi(39)) yvals(randi(39))];
                    while ~checkP(x, y, boon(1), boon(2)) || ~checkP(obx, oby, boon(1), boon(2))
                        boon = [xvals(randi(39)) yvals(randi(39))];
                    end
                end
            end

            boonpRand = randi(100);
            if boonpRand == 25 && boonpTime > 4 ...
                    || x(length(x)) == boonp(1) && y(length(y)) == boonp(2)
                boonpTime = 0;
                if x(length(x)) == boonp(1) && y(length(y)) == boonp(2)
                    counter = counter + randi([9 12]);
                    boonp = [14 14];
                end
                if boonpRand == 25
                    boonp = [xvals(randi(39)) yvals(randi(39))];
                    while ~checkP(x, y, boonp(1), boonp(2)) || ~checkP(obx, oby, boonp(1), boonp(2))
                        boonp = [xvals(randi(39)) yvals(randi(39))];
                    end
                end
            end
            if boonTime <= 4
                plot(boon(1), boon(2), '>', 'Color', data.boonColor, 'MarkerSize', 10, 'MarkerFaceColor', data.boonColor)
                boonTime = boonTime + p;
            else
                boon = [15 15];
            end
            if boonpTime <= 4
                plot(boonp(1), boonp(2), '+', 'Color', data.boonColor, 'MarkerSize', 12, 'LineWidth', 3)
                boonpTime = boonpTime + p;
            else
                boonp = [14 14];
            end
            if (crossTime <= 19 && matchx(1) ~= 11 && matchy(1) ~= 11) || crossTime == .0001
                plot(crossx, crossy, 'x', 'Color', data.oppColor, 'LineWidth', 13)
                crossTime = crossTime + p;
            end
        end

        plot(obx, oby, 's', 'LineWidth', 3, 'MarkerFaceColor', data.obstacleColor, 'MarkerEdgeColor', data.obstacleColor)
        %   plot(obx, oby, 's', 'LineWidth', 1, 'MarkerEdgeColor', data.obstacleColor, 'MarkerEdgeColor', data.obstacleColor)
        plot(x, y, 's','Color', data.snakeColor, 'LineWidth', 2)
        plot(x(length(x)), y(length(y)), 's', 'Color' ,data.snakeColor, 'LineWidth', 2)
        plot([-10 10 10 -10 -10], [-10 -10 10 10 -10], 's-', 'Color' ,data.outlineColor, 'LineWidth', 2)
        plot([10 -10 -10], [10 10, -10], '-', 'Color', data.outlineColor, 'Linewidth', 3)
        pause(p)
        drawnow
        if strcmp(z, 'p')
            pause
        end
        hold off
        set(handles.scoreText, 'String', num2str(counter + length(x)));
        set(handles.lengthText, 'String', num2str(length(x)));
        if data.wallCheck == false
            walls = x(length(x)) ~= 10 && x(length(x)) ~= -10 && y(length(y)) ~= 10 && y(length(y)) ~= -10;
        end
        data = guidata(hObject);
    end
    name = inputdlg('Enter leaderboard name, or click ''Cancel'':', 'Leaderboard', [1, 45]);
    if ~isempty(name)
        if length(name{1}) < 15
            for i = length(name{1}):14
                name{1} = strcat(name{1}, {' '});
            end
            name = name{1};
        end
        if length(name{1}) < 15
            name = name{1}(1:15);
        end
        if length(map) < 15
            for i = length(map):14
                map = strcat(map, {' '});
            end
        end
        lnames = [lnames;name{1}]; %#ok<*NASGU>
        lscores = [lscores counter];
        llengths = [llengths length(x)];
        lmap = [lmap;map{1}];
        if arcades == 1
            larc = [larc;'x'];
        else
            larc = [larc;'-'];
        end
        if wallss == 1
            lwall = [lwall;'x'];
        else
            lwall = [lwall;'-'];
        end
        save('leaders', 'lnames', 'lscores', 'llengths', 'lmap', 'larc', 'lwall')
    end
    guidata(hObject, data);

    
function themesMenu_Callback(hObject, eventdata, handles) %#ok<INUSL>

    data = guidata(hObject);
    items = get(hObject,'String');
    index_selected = get(hObject,'Value');
    item_selected = items{index_selected};
    switch item_selected
        case 'Jungle'
            set(gcf, 'Color', [0.5625 0.9297 0.5625]);
            set(handles.axes1, 'Color', [0.8750 1.0000 1.0000])
            data.snakeColor = 'black';
            data.pointColor = 'black';
            data.outlineColor = 'black';
            data.boonColor = [0.6250 0.3203 0.1758];
            data.oppColor = 'r';
            data.obstacleColor = 'black';
            for i = 1:length(data.staticTexts)
                set(data.staticTexts(i), 'BackgroundColor'  , [0.5625 0.9297 0.5625], ...
                    'ForegroundColor', 'black');
            end
        case 'Galactic'
            set(gcf, 'Color', 'black');
            set(handles.axes1, 'Color', 'black')
            data.snakeColor = 'r';
            data.pointColor = 'b';
            data.outlineColor = 'g';
            data.boonColor = 'g';
            data.oppColor = [0.7500 0.7500 0.7500];
            data.obstacleColor = [0.1836 0.3086 0.3086];
            for i = 1:length(data.staticTexts)
                set(data.staticTexts(i), 'BackgroundColor', 'black', ...
                    'ForegroundColor', 'g');
            end
        case 'Hello Kitty'
            set(gcf, 'Color', [1 .4102 .7031]);
            set(handles.axes1, 'Color', [0.9 0.9 0.9792])
            data.snakeColor = [1 0 1];
            data.pointColor = [0.8594 0.0781 0.2344];
            data.outlineColor = 'y';
            data.boonColor = [0.5000 0 0.5000];
            data.oppColor = 'black';
            data.obstacleColor = [0.8516    0.4375    0.8359];
            for i = 1:length(data.staticTexts)
                set(data.staticTexts(i), 'BackgroundColor', [1 .4102 .7031], ...
                    'ForegroundColor', 'w');
            end
        case 'Fire'
            set(gcf, 'Color', [0.4500 0 0]);
            set(handles.axes1, 'Color', [.5430 0 0])
            data.snakeColor = [1 .2695 0];
            data.pointColor = 'r';
            data.outlineColor = [1 .5469 0];
            data.boonColor = [1.0000 0.8398 0];
            data.oppColor = [0.1328 0.5430 0.1328];
            data.obstacleColor = [0.7188 0.5234 0.0430];
            for i = 1:length(data.staticTexts)
                set(data.staticTexts(i), 'BackgroundColor', [0.4500 0 0], ...
                    'ForegroundColor', [1 .5469 0]);
            end
        case 'Sky'
            set(gcf, 'Color', [.1172 .5625 1]);
            set(handles.axes1, 'Color', [0.5273 0.8047 0.9180])
            data.snakeColor = [0 0 .8008];
            data.pointColor = [0 0 .8008];
            data.outlineColor = 'w';
            data.obstacleColor = [0 0.5430 0.5430];
            data.boonColor = [0.2813 0.2383 0.5430];
            data.oppColor = [1.0000 0.2695 0];
            for i = 1:length(data.staticTexts)
                set(data.staticTexts(i), 'BackgroundColor', [.1172 .5625 1], ...
                    'ForegroundColor', 'w');
            end
    end
    guidata(hObject, data);

function themesMenu_CreateFcn(hObject, eventdata, handles) %#ok<INUSD>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject,'String',{'Jungle';'Galactic';'Hello Kitty';'Fire';'Sky'});


function difficultyMenu_Callback(hObject, eventdata, handles) %#ok<INUSD>

    data = guidata(hObject);
    items = get(hObject,'String');
    index_selected = get(hObject,'Value');
    item_selected = items{index_selected};
    switch item_selected
        case 'Downtempo'
            data.speed = .065;
        case 'Slow'
            data.speed = .05;
        case 'Normal'
            data.speed = .035;
        case 'Fast'
            data.speed = .02;
        case 'Extreme'
            data.speed = .016;
    end
    guidata(hObject, data);
    

function difficultyMenu_CreateFcn(hObject, eventdata, handles) %#ok<INUSD>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject,'String',{'Downtempo';'Slow';'Normal';'Fast';'Extreme'});

function wallsCheck_Callback(hObject, eventdata, handles) %#ok<INUSD>

function arcadeCheck_Callback(hObject, eventdata, handles) %#ok<INUSD>


function obstacleMenu_Callback(hObject, eventdata, handles) %#ok<INUSD>

    data = guidata(hObject);
    items = get(hObject,'String');
    index_selected = get(hObject,'Value');
    item_selected = items{index_selected};
    counter = 1;
    data.obstaclex = -11;
    data.obstacley = -11;
    if strcmp(item_selected, 'Random')
        item_selected = items{randi([2,6])};
    end
    switch item_selected
        case 'Big-T'
            for i = -.5:.5:.5
               for j = -10:.5:-.5
                    data.obstaclex(counter) = i;
                    data.obstacley(counter) = j;
                    counter = counter + 1;
               end
               for j = .5:.5:6
                    data.obstaclex(counter) = i;
                    data.obstacley(counter) = j;
                    counter = counter + 1;
               end
            end
            for i = 6.5:.5:7.5
               for j = -7:.5:7 
                    data.obstacley(counter) = i;
                    data.obstaclex(counter) = j;
                    counter = counter + 1;
               end
            end
        case 'Plus'
            for i = -.5:.5:.5
               for j = -9:.5:-2.5
                  data.obstaclex(counter) = i;
                  data.obstacley(counter) = j;
                  counter = counter + 1;
                  data.obstaclex(counter) = j;
                  data.obstacley(counter) = i;
                  counter = counter + 1;
               end
               for j = 9:-.5:2.5
                  data.obstaclex(counter) = i;
                  data.obstacley(counter) = j;
                  counter = counter + 1;
                  data.obstaclex(counter) = j;
                  data.obstacley(counter) = i;
                  counter = counter + 1;
               end
            end
        case 'Blobs'
            for i = -7:.5:-2.5
                for j = 2.5:.5:7
                  data.obstaclex(counter) = i;
                  data.obstacley(counter) = j;
                  counter = counter + 1;
                  data.obstaclex(counter) = j;
                  data.obstacley(counter) = i;
                  counter = counter + 1;
                end
                for j = -7:.5:-2.5
                  data.obstaclex(counter) = i;
                  data.obstacley(counter) = j;
                  counter = counter + 1;
                  data.obstaclex(counter) = i*-1;
                  data.obstacley(counter) = j*-1;
                  counter = counter + 1;
                end
            end
        case 'The I'
            for i = -.5:.5:.5
               for j = 6:-.5:1
                  data.obstaclex(counter) = i;
                  data.obstacley(counter) = j;
                  counter = counter + 1;
                  data.obstaclex(counter) = i*-1;
                  data.obstacley(counter) = j*-1;
                  counter = counter + 1;
               end
            end
            for i = 6.5:.5:7.5
               for j = -7:.5:7 
                  data.obstaclex(counter) = j;
                  data.obstacley(counter) = i;
                  counter = counter + 1;
                  data.obstaclex(counter) = j*-1;
                  data.obstacley(counter) = i*-1;
                  counter = counter + 1;
               end
            end
        case 'Points'
            xvals = [-.5 -1 -1.5 -2 -2.5 -3 -3.5 -4 -4.5 -5 -5.5 -6 -6.5 -7 -7.5 -8 -8.5 -9 -9.5 ...
                0 .5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5];
            for i = 1:15
                data.obstaclex(i) = xvals(randi(39));
                data.obstacley(i) = xvals(randi(39));
            end
    end
    data.map = item_selected;
    guidata(hObject, data);

    
function obstacleMenu_CreateFcn(hObject, eventdata, handles) %#ok<INUSD>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject,'String',{'Classic';'Big-T';'Plus';'Blobs';'The I';'Points';'Random'});

    
function leaderboard_Callback(hObject, eventdata, handles) %#ok<INUSD>

    waitfor(Leaderboard)
