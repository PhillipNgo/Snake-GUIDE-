% Snake Leaderboard
% Phillip Ngo

function varargout = Leaderboard(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Leaderboard_OpeningFcn, ...
                   'gui_OutputFcn',  @Leaderboard_OutputFcn, ...
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

function Leaderboard_OpeningFcn(hObject, eventdata, handles, varargin)

    handles.output = hObject;
    guidata(hObject, handles);
    

function q = combo(hObject, w, x, y, z)

    data = guidata(hObject);
    q = 0;
    for i = 1:length(data.scores)
        if w == 1
            namecount = strcmpi(data.nameChoice, data.names(i,1:15));
        else
            namecount = true;
        end
        if x == 1
            mapcount = strcmp(data.mapChoice, data.map(i,1:15));
        else
            mapcount = true;
        end
        if y == 1
            arccount = strcmp(data.arcChoice, data.arcade(i));
        else   
            arccount = true;
        end
        if z == 1
            wallcount = strcmp(data.wallChoice, data.nowall(i));
        else   
            wallcount = true;
        end
        if namecount && mapcount && arccount && wallcount
            q = q + 1;
        end
    end
    if q > 10
        q = 10;
    end

    
function [] = lead(hObject)

    data = guidata(hObject);
    for i = 1:10
       set(data.namesText(i), 'String', '-')
       set(data.scoresText(i), 'String', '0')
       set(data.lengthsText(i), 'String', '0')
       set(data.mapText(i), 'String', '-')
       set(data.arcadeText(i), 'String', '-')
       set(data.nowallText(i), 'String', '-')
    end
    x = zeros(1,length(data.scores));

    temp = combo(hObject, isrow(data.nameChoice), isrow(data.mapChoice), ...
           isrow(data.arcChoice), isrow(data.wallChoice));

    y = zeros(1, temp);

    for i = 1:length(data.scores)
        x(i) = data.scores(i) + data.lengths(i);
    end
    x = sort(x, 'descend');
    q = 1;
    while q <= temp
        for i = 1:length(x)
            for j = 1:length(data.scores)
                if isrow(data.nameChoice)
                    nameParam = strcmpi(data.names(j,1:15), data.nameChoice);
                else
                    nameParam = sum(ismember(data.names(j,1:15), data.nameChoice)) == 15;
                end
                if data.scores(j) + data.lengths(j) == x(i) && ismember(j, y) == 0 ...
                        && nameParam ...
                        && sum(ismember(data.map(j,1:15), data.mapChoice)) == 15 ...
                        && ismember(data.arcade(j), data.arcChoice) == 1 ...
                        && ismember(data.nowall(j), data.wallChoice) == 1 ...
                        && q <= 10
                    y(q) = j;
                    q = q + 1;
                end
            end
            if q > 10
                break
            end
        end
    end

    for i = 1:length(y)
       set(data.namesText(i), 'String', deblank(data.names(y(i), 1:15)))
       set(data.scoresText(i), 'String', num2str(data.scores(y(i)) + data.lengths(y(i))))
       set(data.lengthsText(i), 'String', num2str(data.lengths(y(i))))
       set(data.mapText(i), 'String', deblank(data.map(y(i), 1:15)))
       set(data.arcadeText(i), 'String', data.arcade(y(i)))
       set(data.nowallText(i), 'String', data.nowall(y(i)))
    end

    
function varargout = Leaderboard_OutputFcn(hObject, eventdata, handles)  %#ok<*INUSL>
    
    varargout{1} = handles.output;
    if exist('leaders.mat', 'file') == 2
        load('leaders')
        handles.names = lnames;
        handles.scores = lscores;
        handles.lengths = llengths;
        handles.map = lmap;
        handles.arcade = larc;
        handles.nowall = lwall;
        handles.nameChoice = handles.names;
        handles.arcChoice = ['-';'x'];
        handles.wallChoice = ['-';'x'];
        handles.mapChoice = ['Classic        ';'Big-T          ';'Plus           '; ...
                             'Blobs          ';'The I          ';'Points         '];
        handles.namesText = [handles.name1 handles.name2 handles.name3 handles.name4 handles.name5 ...
                             handles.name6 handles.name7 handles.name8 handles.name9 handles.name10];
        handles.scoresText = [handles.score1 handles.score2 handles.score3 handles.score4 handles.score5 ...
                              handles.score6 handles.score7 handles.score8 handles.score9 handles.score10];
        handles.lengthsText = [handles.length1 handles.length2  handles.length3  handles.length4  handles.length5 ...
                               handles.length6 handles.length7 handles.length8 handles.length9 handles.length10];
        handles.mapText = [handles.map1 handles.map2 handles.map3 handles.map4 handles.map5 ...
                           handles.map6 handles.map7 handles.map8 handles.map9 handles.map10];
        handles.arcadeText = [handles.arcade1 handles.arcade2 handles.arcade3 handles.arcade4 handles.arcade5 ...
                              handles.arcade6 handles.arcade7 handles.arcade8 handles.arcade9 handles.arcade10];
        handles.nowallText = [handles.wall1 handles.wall2 handles.wall3 handles.wall4 handles.wall5 ...
                              handles.wall6 handles.wall7 handles.wall8 handles.wall9 handles.wall10];
        guidata(hObject, handles);
        lead(hObject)
    else
        waitfor(errordlg('There are no scores on this computer yet! Let''s change that!'))
        close()
    end
    
    
function searchName_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    name = get(hObject, 'String');

    if isempty(name)
        data.nameChoice = handles.names;
    else
        if length(name) < 15
            for i = length(name):14
                name = strcat(name, {' '});
            end
            name = name{1};
        end
        data.nameChoice = name;
    end

    guidata(hObject, data); 
    lead(hObject)

    
function searchName_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    
function arcadeMenu_Callback(hObject, eventdata, handles)

    data = guidata(hObject);
    items = get(hObject,'String');
    index_selected = get(hObject,'Value');
    item_selected = items{index_selected};
    if strcmp(item_selected, 'Both')
        data.arcChoice = ['-';'x'];
    elseif strcmp(item_selected, 'On') 
        data.arcChoice = 'x';
    else
        data.arcChoice = '-';
    end
    guidata(hObject, data); 
    lead(hObject)

    
function arcadeMenu_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject,'String',{'Both';'On';'Off'});

    
function mapMenu_Callback(hObject, eventdata, handles)

    data = guidata(hObject);
    items = get(hObject,'String');
    index_selected = get(hObject,'Value');
    item_selected = items{index_selected};
    if strcmp(item_selected, 'All')
       data.mapChoice =['Classic        ';'Big-T          ';'Plus           '; ... 
                        'Blobs          ';'The I          ';'Points         '];
    else
        if length(item_selected) < 15
            for i = length(item_selected):14
                item_selected = strcat(item_selected, {' '});
            end
        end
        data.mapChoice = item_selected{1};
    end
    guidata(hObject, data);
    lead(hObject)

    
function mapMenu_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject,'String',{'All';'Classic';'Big-T';'Plus';'Blobs';'The I';'Points'});
    

function wallsMenu_Callback(hObject, eventdata, handles)

    data = guidata(hObject);
    items = get(hObject,'String');
    index_selected = get(hObject,'Value');
    item_selected = items{index_selected};
    if strcmp(item_selected, 'Both')
        data.wallChoice = ['-';'x'];
    elseif strcmp(item_selected, 'On')
        data.wallChoice = 'x';
    else
        data.wallChoice = '-';
    end
    guidata(hObject, data); 
    lead(hObject)

    
function wallsMenu_CreateFcn(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject,'String',{'Both';'On';'Off'});
