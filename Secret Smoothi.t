
% Sets up the workspace
setscreen ("graphics:480;640, nobuttonbar, position:center;center, noecho, offscreenonly")

% Initializes all the procedures and their parameters
forward proc drawPlayScreen
forward proc drawNumber (x : int, y : int, number : int, anchor : int)
forward proc gameInput
forward proc drawMenuScreen
forward proc menuInput
forward proc reset
forward proc updateAI

const typeface := "Fixedsys"
const halfx := floor (maxx / 2)
const halfy := floor (maxy / 2)
const xMenuOff := 110
const yMenuOff := 430

const tickInterval := 2000 % The time in milliseconds between ticks
var currentTime := 0
var lastTick := 0

var inGame := false % Defaults to Main Menu

const numberOfOptions := 3
var optionSelected := 1

class Rectangle

    %% This tells us what can be used outside the class
    %% if not listed here it cannot be used outside the class
    export setCarAttributes, putCarAttributes

    %% These are the variables in the class
    var name : string
    var Length, cost : int

    %% These procedures modify the data in the class and output it
    proc setCarAttributes (nam : string, l, c : int)

	name := nam
	Length := l
	cost := c

    end setCarAttributes

    proc putCarAttributes

	put "Car name: ", name
	put "Car Length: ", Length
	put "Car Cost: ", cost

    end putCarAttributes

end Rectangle

var Volvo : ^Rectangle
new Volvo
% ^ can also be "pointer to"



Volvo -> setCarAttributes ("Volvo", 100, 20000)
Volvo -> putCarAttributes


% The main gameloop
loop
    currentTime := Time.Elapsed

    if (currentTime > lastTick + tickInterval) then
	if inGame = true then

	    gameInput

	    updateAI

	    drawPlayScreen

	else

	    menuInput

	    drawMenuScreen

	end if

	lastTick := currentTime
    end if

    % Caps the framerate
    % delay (millSecTickDelay)

    % Updates the frame
    View.Update
end loop

% Updates the AI to move towards the closest ball
body proc updateAI

end updateAI

% Draws the screen
body proc drawPlayScreen

end drawPlayScreen

% Draws a number (used to draw the score)
body proc drawNumber
    var font := Font.New (typeface + ":40")
    var offsetX := x
    var width := Font.Width (intstr (number), font)

    % If it anchors to the right of the number then it will offset the x to the width of the text
    if anchor = 3 then
	offsetX -= width

	% If it anchors to the middle of the number then it will offset the x to half the width of the text
    elsif anchor = 2 then
	offsetX -= floor (width / 2)
    end if

    % Fixes a bug where when score is 0 it will get drawn too far to the right
    if number = 0 and anchor = 1 then
	offsetX -= 6
    elsif number = 0 and anchor = 2 then
	offsetX -= 3
    end if

    % Draws the final number
    Font.Draw (intstr (number), offsetX, y, font, white)
end drawNumber

% Detects when players presses the key for in-game
body proc gameInput
    var chars : array char of boolean
    Input.KeyDown (chars)

    if (chars (KEY_UP_ARROW)) then

    end if

    if (chars (KEY_DOWN_ARROW)) then

    end if

    if (chars ('r')) then
	reset
    end if

    if chars (KEY_ESC) then
	inGame := false
	reset
    end if
end gameInput


% Resets the in game values
body proc reset

end reset

%Draws the menu screen
body proc drawMenuScreen

    % Draws the background and frame
    drawfillbox (0, 0, maxx, maxy, black)
    drawfillbox (0, maxy - 10, maxx, maxy, white)
    drawfillbox (0, 0, maxx, 10, white)

    % Draws main text
    Font.Draw ("PACMAN", xMenuOff, yMenuOff, Font.New (typeface + ":121:bold"), white)
    Font.Draw ("CODED BY SAMSON CLOSE", xMenuOff + 4, yMenuOff - 20, Font.New (typeface + ":8:bold"), white)
    Font.Draw ("START", xMenuOff + 2, yMenuOff - 60, Font.New (typeface + ":32:bold"), white)
    Font.Draw ("HELP", xMenuOff + 2, yMenuOff - 100, Font.New (typeface + ":32:bold"), white)
    Font.Draw ("OPTIONS", xMenuOff + 2, yMenuOff - 140, Font.New (typeface + ":32:bold"), white)

    % Draws all the option values with the font
    var font := Font.New (typeface + ":22:bold")


    % The offset for the dot
    var xOff := 0
    var yOff := 0

    % Does for each option
    if optionSelected = 1 then
	xOff := -14
	yOff := -46
    elsif optionSelected = 2 then
	xOff := -14
	yOff := -86
    elsif optionSelected = 3 then
	xOff := -14
	yOff := -126
    end if

    % Right half
    Draw.Line (xMenuOff + xOff, yMenuOff + yOff + 8, xMenuOff + xOff + 8, yMenuOff + yOff, white)
    Draw.Line (xMenuOff + xOff + 8, yMenuOff + yOff, xMenuOff + xOff, yMenuOff + yOff - 8, white)

    % Left Half
    Draw.Line (xMenuOff + xOff, yMenuOff + yOff + 8, xMenuOff + xOff - 8, yMenuOff + yOff, white)
    Draw.Line (xMenuOff + xOff - 8, yMenuOff + yOff, xMenuOff + xOff, yMenuOff + yOff - 8, white)

    % Fill
    Draw.Fill (xMenuOff + xOff, yMenuOff + yOff, white, white)
end drawMenuScreen

% Tracks the last value for the up and down keys. Used for filtering input.
var upLast := false
var downLast := false

% Detects when players hit a key on the menu screen
body proc menuInput
    var chars : array char of boolean
    Input.KeyDown (chars)

    var keyUp := chars (KEY_UP_ARROW)
    var keyDown := chars (KEY_DOWN_ARROW)

    if keyUp and not upLast and optionSelected > 1 then
	optionSelected -= 1
    end if

    if keyDown and not downLast and optionSelected < numberOfOptions then
	optionSelected += 1
    end if

    if chars (KEY_ENTER) then
	if optionSelected = 1 then
	    inGame := true
	    reset
	end if
    end if

    % Updates the filtering variables (MUST BE LAST)
    upLast := keyUp
    downLast := keyDown
end menuInput
