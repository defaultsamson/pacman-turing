setscreen ("graphics:448;576, nobuttonbar, position:center;center, noecho, offscreenonly")

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

const tickInterval := (1000 / 60) % The time in milliseconds between ticks
var currentTime := 0
var lastTick := 0

var inGame := false % Defaults to Main Menu

const numberOfOptions := 3
var optionSelected := 1

% Loads all the sprites
const iMap : int := Pic.Scale (Pic.FileNew ("pacman/map.bmp"), maxx, maxy)

const iPacmanLeft0 : int := Pic.Scale (Pic.FileNew ("pacman/pacman0.bmp"), 32, 32)
const iPacmanLeft1 : int := Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32)
const iPacmanLeft2 : int := Pic.Scale (Pic.FileNew ("pacman/pacman2.bmp"), 32, 32)

const iPacmanDown0 : int := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman0.bmp"), 32, 32), 90, 16, 16)
const iPacmanDown1 : int := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32), 90, 16, 16)
const iPacmanDown2 : int := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman2.bmp"), 32, 32), 90, 16, 16)

const iPacmanRight0 : int := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman0.bmp"), 32, 32), 180, 16, 16)
const iPacmanRight1 : int := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32), 180, 16, 16)
const iPacmanRight2 : int := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman2.bmp"), 32, 32), 180, 16, 16)

const iPacmanUp0 : int := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman0.bmp"), 32, 32), 270, 16, 16)
const iPacmanUp1 : int := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32), 270, 16, 16)
const iPacmanUp2 : int := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman2.bmp"), 32, 32), 270, 16, 16)

const iPacmanDead0 : int := Pic.Scale (Pic.FileNew ("pacman/pacman3.bmp"), 32, 32)
const iPacmanDead1 : int := Pic.Scale (Pic.FileNew ("pacman/pacman4.bmp"), 32, 32)
const iPacmanDead2 : int := Pic.Scale (Pic.FileNew ("pacman/pacman5.bmp"), 32, 32)
const iPacmanDead3 : int := Pic.Scale (Pic.FileNew ("pacman/pacman6.bmp"), 32, 32)
const iPacmanDead4 : int := Pic.Scale (Pic.FileNew ("pacman/pacman7.bmp"), 32, 32)
const iPacmanDead5 : int := Pic.Scale (Pic.FileNew ("pacman/pacman8.bmp"), 32, 32)
const iPacmanDead6 : int := Pic.Scale (Pic.FileNew ("pacman/pacman9.bmp"), 32, 32)
const iPacmanDead7 : int := Pic.Scale (Pic.FileNew ("pacman/pacman10.bmp"), 32, 32)
const iPacmanDead8 : int := Pic.Scale (Pic.FileNew ("pacman/pacman11.bmp"), 32, 32)
const iPacmanDead9 : int := Pic.Scale (Pic.FileNew ("pacman/pacman12.bmp"), 32, 32)
const iPacmanDead10 : int := Pic.Scale (Pic.FileNew ("pacman/pacman13.bmp"), 32, 32)
const iPacmanDead11 : int := Pic.Scale (Pic.FileNew ("pacman/pacman14.bmp"), 32, 32)
const iPacmanDead12 : int := Pic.Scale (Pic.FileNew ("pacman/pacman15.bmp"), 32, 32)


const iBlinkyLeft1 : int := Pic.Scale (Pic.FileNew ("pacman/blinky_side1.bmp"), 32, 32)
const iBlinkyLeft2 : int := Pic.Scale (Pic.FileNew ("pacman/blinky_side2.bmp"), 32, 32)

const iBlinkyDown1 : int := Pic.Scale (Pic.FileNew ("pacman/blinky_down1.bmp"), 32, 32)
const iBlinkyDown2 : int := Pic.Scale (Pic.FileNew ("pacman/blinky_down2.bmp"), 32, 32)

const iBlinkyRight1 : int := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/blinky_side1.bmp"), 32, 32))
const iBlinkyRight2 : int := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/blinky_side2.bmp"), 32, 32))

const iBlinkyUp1 : int := Pic.Scale (Pic.FileNew ("pacman/blinky_up1.bmp"), 32, 32)
const iBlinkyUp2 : int := Pic.Scale (Pic.FileNew ("pacman/blinky_up2.bmp"), 32, 32)


const iClydeLeft1 : int := Pic.Scale (Pic.FileNew ("pacman/clyde_side1.bmp"), 32, 32)
const iClydeLeft2 : int := Pic.Scale (Pic.FileNew ("pacman/clyde_side2.bmp"), 32, 32)

const iClydeDown1 : int := Pic.Scale (Pic.FileNew ("pacman/clyde_down1.bmp"), 32, 32)
const iClydeDown2 : int := Pic.Scale (Pic.FileNew ("pacman/clyde_down2.bmp"), 32, 32)

const iClydeRight1 : int := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/clyde_side1.bmp"), 32, 32))
const iClydeRight2 : int := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/clyde_side2.bmp"), 32, 32))

const iClydeUp1 : int := Pic.Scale (Pic.FileNew ("pacman/clyde_up1.bmp"), 32, 32)
const iClydeUp2 : int := Pic.Scale (Pic.FileNew ("pacman/clyde_up2.bmp"), 32, 32)


const iInkyLeft1 : int := Pic.Scale (Pic.FileNew ("pacman/inky_side1.bmp"), 32, 32)
const iInkyLeft2 : int := Pic.Scale (Pic.FileNew ("pacman/inky_side2.bmp"), 32, 32)

const iInkyDown1 : int := Pic.Scale (Pic.FileNew ("pacman/inky_down1.bmp"), 32, 32)
const iInkyDown2 : int := Pic.Scale (Pic.FileNew ("pacman/inky_down2.bmp"), 32, 32)

const iInkyRight1 : int := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/inky_side1.bmp"), 32, 32))
const iInkyRight2 : int := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/inky_side2.bmp"), 32, 32))

const iInkyUp1 : int := Pic.Scale (Pic.FileNew ("pacman/inky_up1.bmp"), 32, 32)
const iInkyUp2 : int := Pic.Scale (Pic.FileNew ("pacman/inky_up2.bmp"), 32, 32)


const iPinkyLeft1 : int := Pic.Scale (Pic.FileNew ("pacman/pinky_side1.bmp"), 32, 32)
const iPinkyLeft2 : int := Pic.Scale (Pic.FileNew ("pacman/pinky_side2.bmp"), 32, 32)

const iPinkyDown1 : int := Pic.Scale (Pic.FileNew ("pacman/pinky_down1.bmp"), 32, 32)
const iPinkyDown2 : int := Pic.Scale (Pic.FileNew ("pacman/pinky_down2.bmp"), 32, 32)

const iPinkyRight1 : int := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/pinky_side1.bmp"), 32, 32))
const iPinkyRight2 : int := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/pinky_side2.bmp"), 32, 32))

const iPinkyUp1 : int := Pic.Scale (Pic.FileNew ("pacman/pinky_up1.bmp"), 32, 32)
const iPinkyUp2 : int := Pic.Scale (Pic.FileNew ("pacman/pinky_up2.bmp"), 32, 32)

View.SetTransparentColor (black)




class Rectangle

    %% This tells us what can be used outside the class
    %% if not listed here it cannot be used outside the class
    export setRectangle, x, y, width, height, isTouching, move

    var x, y, width, height : int

    proc setRectangle (newX, newY, newWidth, newHeight : int)
	x := newX
	y := newY
	width := newWidth
	height := newHeight
    end setRectangle

    fcn isTouching (rect : ^Rectangle) : boolean
	result (x < rect -> x + rect -> width and x + width > rect -> x and y < rect -> y + rect -> height and y + height > rect -> y)
    end isTouching

    proc setPosition (xPos, yPos : int)
	x := xPos
	y := yPos
    end setPosition

    proc move (xOff, yOff : int)
	x := x + xOff
	y := y + yOff
    end move

end Rectangle

var Butt : ^Rectangle
new Butt

Butt -> setRectangle (500, 4, 100, 200)

var Ox : ^Rectangle
new Ox

Ox -> setRectangle (5, 4, 100, 200)


var isTouched := false


% The main gameloop
loop
    currentTime := Time.Elapsed

    isTouched := Butt -> isTouching (Ox)

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

    % Updates the frame
    View.Update
end loop

% Updates the AI to move towards the closest ball
body proc updateAI

end updateAI

var pacX := maxx div 2
var pacY := maxy div 2

% Draws the screen
body proc drawPlayScreen
    % Draws the background
    drawfillbox (0, 0, maxx, maxy, black)

    Pic.Draw (iBlinkyRight2, pacX, pacY, picUnderMerge)

    Pic.Draw (iMap, 0, 0, picUnderMerge)
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
	pacY := pacY + 3
    end if

    if (chars (KEY_DOWN_ARROW)) then
	pacY := pacY - 3
    end if

    if (chars (KEY_RIGHT_ARROW)) then
	pacX := pacX + 3
    end if

    if (chars (KEY_LEFT_ARROW)) then
	pacX := pacX - 3
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

    % Draws the background
    drawfillbox (0, 0, maxx, maxy, black)

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
	elsif optionSelected = 2 then

	elsif optionSelected = 3 then

	end if
    end if

    % Updates the filtering variables (MUST BE LAST)
    upLast := keyUp
    downLast := keyDown
end menuInput
