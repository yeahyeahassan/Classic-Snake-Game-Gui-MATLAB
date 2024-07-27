function varargout = snake_g(varargin)
% SNAKE_G MATLAB code for snake_g.fig
% Creates or raises the existing singleton for SNAKE_G.
% H = SNAKE_G returns the handle to the new or existing SNAKE_G.
% SNAKE_G('CALLBACK',...) calls the local function named CALLBACK with given inputs.
% SNAKE_G('Property','Value',...) creates or raises SNAKE_G and applies property value pairs.
clc;

% Begin initialization code 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @snake_g_OpeningFcn, ...
                   'gui_OutputFcn',  @snake_g_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code

% --- Executes just before snake_g is made visible.
function snake_g_OpeningFcn(hObject, eventdata, handles, varargin)
% Initializes the GUI and sets default command line output.
% hObject    handle to figure
% eventdata  reserved for future use
% handles    structure with handles and user data
% varargin   command line arguments

handles.output = hObject; % Set default command line output
guidata(hObject, handles); % Update handles structure
axes(handles.axes1); % Set up the axes
axis('off'); % Turn off axis

% --- Outputs from this function are returned to the command line.
function varargout = snake_g_OutputFcn(hObject, eventdata, handles)
% Returns the output argument from handles structure.
% hObject    handle to figure
% eventdata  reserved for future use
% handles    structure with handles and user data

varargout{1} = handles.output; % Get default command line output
start_game_Callback(hObject, eventdata, handles); % Start the game

% --- Executes on button press in up.
function up_Callback(hObject, eventdata, handles)
% Handles the 'Up' button press.
% hObject    handle to up button
% eventdata  reserved for future use
% handles    structure with handles and user data

global direction move_status;
if ~(direction == 4)
    direction = 2; % Set direction to up
    move_status = 1; % Enable movement
end

% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
% Handles the 'Right' button press.
% hObject    handle to right button
% eventdata  reserved for future use
% handles    structure with handles and user data

global direction move_status;
if ~(direction == 3)
    direction = 1; % Set direction to right
    move_status = 1; % Enable movement
end

% --- Executes on button press in down.
function down_Callback(hObject, eventdata, handles)
% Handles the 'Down' button press.
% hObject    handle to down button
% eventdata  reserved for future use
% handles    structure with handles and user data

global direction move_status;
if ~(direction == 2)
    direction = 4; % Set direction to down
    move_status = 1; % Enable movement
end

% --- Executes on button press in left.
function left_Callback(hObject, eventdata, handles)
% Handles the 'Left' button press.
% hObject    handle to left button
% eventdata  reserved for future use
% handles    structure with handles and user data

global direction move_status;
if ~(direction == 1)
    direction = 3; % Set direction to left
    move_status = 1; % Enable movement
end

% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% Handles the 'Pause' button press.
% hObject    handle to pause button
% eventdata  reserved for future use
% handles    structure with handles and user data

global move_status;
move_status = 0; % Disable movement

% --- Executes on button press in start_game.
function start_game_Callback(hObject, eventdata, handles)
% Handles the 'Start Game' button press.
% hObject    handle to start_game button
% eventdata  reserved for future use
% handles    structure with handles and user data

global mat_r mat_g mat_b;
global direction; direction = 2; % Initial direction
global points; points = 0; % Initialize points
global move_status; move_status = 0; % Movement status
t = 0.1; % Initial speed
locx = [50 50 50 50 50 50 50 50 50];
locy = [60 61 62 63 64 65 66 67 68];

mat_r = zeros(100,100);
mat_g = zeros(100,100);
mat_b = zeros(100,100);
update_snake(locx, locy); % Update snake's initial position

% Place a food item
while(1)
    pt_x = randperm(size(mat_r,1),1);
    pt_y = randperm(size(mat_r,1),1);
    if sum(locx == pt_x & locy == pt_y) == 0
        break;
    end
end
mat_r(pt_x, pt_y) = 255;
mat_g(pt_x, pt_y) = 255;
mat_b(pt_x, pt_y) = 255;

imshow(uint8(cat(3, mat_r, mat_g, mat_b))); % Display the initial frame

% Game loop
while(1)
    imshow(uint8(cat(3, mat_r, mat_g, mat_b))); % Update display
    pause(t); % Pause to control game speed
    if move_status
        len = length(locx);
        for i = 1:len
            mat_r(locx(i), locy(i)) = 0;
            mat_g(locx(i), locy(i)) = 0;
            mat_b(locx(i), locy(i)) = 0;
        end
        % Check if the snake ate the food
        if sum((locx(1) == pt_x) & (locy(1) == pt_y)) == 1
            % Grow the snake
            locx = [locx locx(end)];
            locy = [locy locy(end)];
            % Place a new food item
            while(1)
                pt_x = randperm(size(mat_r,1),1);
                pt_y = randperm(size(mat_r,1),1);
                if sum(locx == pt_x & locy == pt_y) == 0
                    break;
                end
            end
            mat_r(pt_x, pt_y) = 255;
            mat_g(pt_x, pt_y) = 255;
            mat_b(pt_x, pt_y) = 255;
            points = points + 1; % Increase points
            set(handles.score, 'String', num2str(points)); % Update score display
            
            % Simulate open mouth animation
            for k = 1:5
                mat_r(locx(1), locy(1)) = 0;
                mat_g(locx(1), locy(1)) = 0;
                mat_b(locx(1), locy(1)) = 255;
                imshow(uint8(cat(3, mat_r, mat_g, mat_b))); % Update display
                pause(0.1); % Pause for animation effect
                
                update_snake(locx, locy); % Restore normal snake appearance
                imshow(uint8(cat(3, mat_r, mat_g, mat_b))); % Update display
                pause(0.1); % Pause for animation effect
            end
        else
            locx(2:len) = locx(1:len-1);
            locy(2:len) = locy(1:len-1);
        end
        % Update snake's head position
        if direction == 1
            if locy(1) == 100
                locy(1) = 1;
            else
                locy(1) = locy(1) + 1;
            end
        elseif direction == 2
            if locx(1) == 1
                locx(1) = 100;
            else 
                locx(1) = locx(1) - 1;
            end
        elseif direction == 3
            if locy(1) == 1
                locy(1) = 100;
            else
                locy(1) = locy(1) - 1;
            end
        elseif direction == 4
            if locx(1) == 100
                locx(1) = 1;
            else
                locx(1) = locx(1) + 1;
            end
        end
        % Check for collision with itself
        if sum((locx(2:end) == locx(1)) & (locy(2:end) == locy(1)))
            mat_r(:,:) = 255;
            mat_g(:,:) = 0;
            mat_b(:,:) = 0;
            imshow(uint8(cat(3, mat_r, mat_g, mat_b)));
            msgbox('Game over..!');
            break;
        end
        update_snake(locx, locy); % Update snake's display
        % Adjust speed based on points
        if points == 5
            t = 0.08;
        elseif points == 10
            t = 0.05;
        elseif points == 15
            t = 0.03;
        elseif points == 30
            t = 0.01;
        elseif points == 50
            t = 0.008;
        end
    end
end

% --- Executes on button press in end_game.
function end_game_Callback(hObject, eventdata, handles)
% Handles the 'End Game' button press.
% hObject    handle to end_game button
% eventdata  reserved for future use
% handles    structure with handles and user data

close; % Close the figure

function update_snake(locx, locy)
% Updates the snake's display.
% locx    x-coordinates of the snake
% locy    y-coordinates of the snake

global mat_r mat_g mat_b
mat_r(locx(1), locy(1)) = 255;
mat_g(locx(1), locy(1)) = 0;
mat_b(locx(1), locy(1)) = 0;

for i = 2:length(locx)
    mat_r(locx(i), locy(i)) = 0;
    mat_g(locx(i), locy(i)) = 255;
    mat_b(locx(i), locy(i)) = 0;
end

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% Handles key presses for movement controls.
% hObject    handle to figure
% eventdata  structure with key press information
% handles    structure with handles and user data

global direction move_status;
switch(eventdata.Key)
    case 'uparrow'
        if ~(direction == 4)
            direction = 2; % Set direction to up
            move_status = 1; % Enable movement
        end
    case 'downarrow'
        if ~(direction == 2)
            direction = 4; % Set direction to down
            move_status = 1; % Enable movement
        end
    case 'rightarrow'
        if ~(direction == 3)
            direction = 1; % Set direction to right
            move_status = 1; % Enable movement
        end
    case 'leftarrow'
        if ~(direction == 1)
            direction = 3; % Set direction to left
            move_status = 1; % Enable movement
        end
    case 'return'
        move_status = 0; % Pause movement
    otherwise
        direction = direction; % No change in direction
        move_status = 1; % Enable movement
end
