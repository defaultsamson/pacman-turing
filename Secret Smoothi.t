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

type Direction : enum (up, down, left, right)

% Loads all the sprites
const iMap : int := Pic.Scale (Pic.FileNew ("pacman/map.bmp"), maxx, maxy)

var iPacmanLeft : array 0 .. 2 of int
iPacmanLeft (0) := Pic.Scale (Pic.FileNew ("pacman/pacman0.bmp"), 32, 32)
iPacmanLeft (1) := Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32)
iPacmanLeft (2) := Pic.Scale (Pic.FileNew ("pacman/pacman2.bmp"), 32, 32)

var iPacmanDown : array 0 .. 2 of int
iPacmanDown (0) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman0.bmp"), 32, 32), 90, 16, 16)
iPacmanDown (1) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32), 90, 16, 16)
iPacmanDown (2) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman2.bmp"), 32, 32), 90, 16, 16)

var iPacmanRight : array 0 .. 2 of int
iPacmanRight (0) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman0.bmp"), 32, 32), 180, 16, 16)
iPacmanRight (1) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32), 180, 16, 16)
iPacmanRight (2) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman2.bmp"), 32, 32), 180, 16, 16)

var iPacmanUp : array 0 .. 2 of int
iPacmanUp (0) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman0.bmp"), 32, 32), 270, 16, 16)
iPacmanUp (1) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32), 270, 16, 16)
iPacmanUp (2) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman2.bmp"), 32, 32), 270, 16, 16)

var iPacmanDead : array 0 .. 12 of int
iPacmanDead (0) := Pic.Scale (Pic.FileNew ("pacman/pacman3.bmp"), 32, 32)
iPacmanDead (1) := Pic.Scale (Pic.FileNew ("pacman/pacman4.bmp"), 32, 32)
iPacmanDead (2) := Pic.Scale (Pic.FileNew ("pacman/pacman5.bmp"), 32, 32)
iPacmanDead (3) := Pic.Scale (Pic.FileNew ("pacman/pacman6.bmp"), 32, 32)
iPacmanDead (4) := Pic.Scale (Pic.FileNew ("pacman/pacman7.bmp"), 32, 32)
iPacmanDead (5) := Pic.Scale (Pic.FileNew ("pacman/pacman8.bmp"), 32, 32)
iPacmanDead (6) := Pic.Scale (Pic.FileNew ("pacman/pacman9.bmp"), 32, 32)
iPacmanDead (7) := Pic.Scale (Pic.FileNew ("pacman/pacman10.bmp"), 32, 32)
iPacmanDead (8) := Pic.Scale (Pic.FileNew ("pacman/pacman11.bmp"), 32, 32)
iPacmanDead (9) := Pic.Scale (Pic.FileNew ("pacman/pacman12.bmp"), 32, 32)
iPacmanDead (10) := Pic.Scale (Pic.FileNew ("pacman/pacman13.bmp"), 32, 32)
iPacmanDead (11) := Pic.Scale (Pic.FileNew ("pacman/pacman14.bmp"), 32, 32)
iPacmanDead (12) := Pic.Scale (Pic.FileNew ("pacman/pacman15.bmp"), 32, 32)


var iBlinkyLeft : array 0 .. 1 of int
iBlinkyLeft (0) := Pic.Scale (Pic.FileNew ("pacman/blinky_side1.bmp"), 32, 32)
iBlinkyLeft (1) := Pic.Scale (Pic.FileNew ("pacman/blinky_side2.bmp"), 32, 32)

var iBlinkyDown : array 0 .. 1 of int
iBlinkyDown (0) := Pic.Scale (Pic.FileNew ("pacman/blinky_down1.bmp"), 32, 32)
iBlinkyDown (1) := Pic.Scale (Pic.FileNew ("pacman/blinky_down2.bmp"), 32, 32)

var iBlinkyRight : array 0 .. 1 of int
iBlinkyRight (0) := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/blinky_side1.bmp"), 32, 32))
iBlinkyRight (1) := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/blinky_side2.bmp"), 32, 32))

var iBlinkyUp : array 0 .. 1 of int
iBlinkyUp (0) := Pic.Scale (Pic.FileNew ("pacman/blinky_up1.bmp"), 32, 32)
iBlinkyUp (1) := Pic.Scale (Pic.FileNew ("pacman/blinky_up2.bmp"), 32, 32)

var iClydeLeft : array 0 .. 1 of int
iClydeLeft (0) := Pic.Scale (Pic.FileNew ("pacman/clyde_side1.bmp"), 32, 32)
iClydeLeft (1) := Pic.Scale (Pic.FileNew ("pacman/clyde_side2.bmp"), 32, 32)

var iClydeDown : array 0 .. 1 of int
iClydeDown (0) := Pic.Scale (Pic.FileNew ("pacman/clyde_down1.bmp"), 32, 32)
iClydeDown (1) := Pic.Scale (Pic.FileNew ("pacman/clyde_down2.bmp"), 32, 32)

var iClydeRight : array 0 .. 1 of int
iClydeRight (0) := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/clyde_side1.bmp"), 32, 32))
iClydeRight (1) := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/clyde_side2.bmp"), 32, 32))

var iClydeUp : array 0 .. 1 of int
iClydeUp (0) := Pic.Scale (Pic.FileNew ("pacman/clyde_up1.bmp"), 32, 32)
iClydeUp (1) := Pic.Scale (Pic.FileNew ("pacman/clyde_up2.bmp"), 32, 32)


var iInkyLeft : array 0 .. 1 of int
iInkyLeft (0) := Pic.Scale (Pic.FileNew ("pacman/inky_side1.bmp"), 32, 32)
iInkyLeft (1) := Pic.Scale (Pic.FileNew ("pacman/inky_side2.bmp"), 32, 32)

var iInkyDown : array 0 .. 1 of int
iInkyDown (0) := Pic.Scale (Pic.FileNew ("pacman/inky_down1.bmp"), 32, 32)
iInkyDown (1) := Pic.Scale (Pic.FileNew ("pacman/inky_down2.bmp"), 32, 32)

var iInkyRight : array 0 .. 1 of int
iInkyRight (0) := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/inky_side1.bmp"), 32, 32))
iInkyRight (1) := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/inky_side2.bmp"), 32, 32))

var iInkyUp : array 0 .. 1 of int
iInkyUp (0) := Pic.Scale (Pic.FileNew ("pacman/inky_up1.bmp"), 32, 32)
iInkyUp (1) := Pic.Scale (Pic.FileNew ("pacman/inky_up2.bmp"), 32, 32)


var iPinkyLeft : array 0 .. 1 of int
iPinkyLeft (0) := Pic.Scale (Pic.FileNew ("pacman/pinky_side1.bmp"), 32, 32)
iPinkyLeft (1) := Pic.Scale (Pic.FileNew ("pacman/pinky_side2.bmp"), 32, 32)

var iPinkyDown : array 0 .. 1 of int
iPinkyDown (0) := Pic.Scale (Pic.FileNew ("pacman/pinky_down1.bmp"), 32, 32)
iPinkyDown (1) := Pic.Scale (Pic.FileNew ("pacman/pinky_down2.bmp"), 32, 32)

var iPinkyRight : array 0 .. 1 of int
iPinkyRight (0) := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/pinky_side1.bmp"), 32, 32))
iPinkyRight (1) := Pic.Mirror (Pic.Scale (Pic.FileNew ("pacman/pinky_side2.bmp"), 32, 32))

var iPinkyUp : array 0 .. 1 of int
iPinkyUp (0) := Pic.Scale (Pic.FileNew ("pacman/pinky_up1.bmp"), 32, 32)
iPinkyUp (1) := Pic.Scale (Pic.FileNew ("pacman/pinky_up2.bmp"), 32, 32)

View.SetTransparentColor (black)




class Rectangle
    %% This tells us what can be used outside the class
    %% if not listed here it cannot be used outside the class
    export setRectangle, x, y, width, height, isTouching, move, draw, setPosition, collisionMove

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

    fcn intersects (inX, inY : int) : boolean
	result (inX > x and inX < x + width and inY > y and inY < inY + height)
    end intersects

    proc setPosition (xPos, yPos : int)
	x := xPos
	y := yPos
    end setPosition

    proc move (xOff, yOff : int)
	x := x + xOff
	y := y + yOff
    end move

    proc collisionMove (xOff, yOff : int, rects : array 0 .. * of ^Rectangle)
	move (xOff, yOff)

	for i : 0 .. upper (rects)
	    if isTouching (rects (i)) then
		move (-xOff, -yOff)
		return
	    end if
	end for
    end collisionMove



    proc draw
	drawfillbox (x * 2, y * 2, (x + width) * 2, (y + height) * 2, white)
    end draw

end Rectangle


class SpriteRectangle
    import Rectangle
    %% This tells us what can be used outside the class
    %% if not listed here it cannot be used outside the class
    export setRectangle, x, y, width, height, isTouching, move, draw, setPosition, setFrames, collisionMove

    var rec : ^Rectangle
    new rec

    var frames : array 0 .. 15 of int
    var framesLength := 0

    var spriteOffsetX := 0
    var spriteOffsetY := 0

    var framesPassed := 0
    var currentFrame := 0
    var ticksPerFrame := 0

    % tpf = ticks per frame. The amount of render ticks required to pass before the sprite changes.
    proc setFrames (a : array 0 .. * of int, tpf, spriteOffX, spriteOffY : int)
	ticksPerFrame := tpf
	framesLength := upper (a)

	spriteOffsetX := spriteOffX
	spriteOffsetY := spriteOffY

	for i : 0 .. framesLength
	    frames (i) := a (i)
	end for
    end setFrames

    proc setRectangle (newX, newY, newWidth, newHeight : int)
	rec -> setRectangle (newX, newY, newWidth, newHeight)
    end setRectangle

    fcn isTouching (rect : ^Rectangle) : boolean
	result rec -> isTouching (rect)
    end isTouching

    proc setPosition (xPos, yPos : int)
	rec -> setPosition (xPos, yPos)
    end setPosition

    fcn x : int
	result rec -> x
    end x

    fcn y : int
	result rec -> y
    end y

    fcn width : int
	result rec -> width
    end width

    fcn height : int
	result rec -> height
    end height

    proc collisionMove (xOff, yOff : int, rects : array 0 .. * of ^Rectangle)
	rec -> collisionMove (xOff, yOff, rects)
    end collisionMove

    proc move (xOff, yOff : int)
	rec -> move (xOff, yOff)
    end move

    proc draw
	framesPassed := framesPassed + 1

	if framesPassed >= ticksPerFrame then
	    framesPassed := 0
	    currentFrame := currentFrame + 1

	    if currentFrame > framesLength then
		currentFrame := 0
	    end if
	end if

	Pic.Draw (frames (currentFrame), x * 2, y * 2, picUnderMerge)

	rec -> draw
    end draw

end SpriteRectangle

var User : ^SpriteRectangle
new User

User -> setRectangle (200, 100, 16, 16)
User -> setFrames (iPacmanUp, 10, 0, 0)

var Ox : ^Rectangle
new Ox

Ox -> setRectangle (50, 60, 10, 20)


var walls : array 0 .. 1 of ^Rectangle
walls (0) := Ox
walls (1) := Ox

var isTouched := false


% The main gameloop
loop
    currentTime := Time.Elapsed

    isTouched := User -> isTouching (Ox)

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

% Draws the screen
body proc drawPlayScreen
    % Draws the background
    drawfillbox (0, 0, maxx, maxy, black)

    Pic.Draw (iMap, 0, 0, picUnderMerge)

    User -> draw

    for i : 0 .. upper (walls)
	walls (i) -> draw
    end for
end drawPlayScreen

% Detects when players presses the key for in-game
body proc gameInput
    var chars : array char of boolean
    Input.KeyDown (chars)

    if (chars (KEY_UP_ARROW)) then
	User -> collisionMove (0, 1, walls)
    end if

    if (chars (KEY_DOWN_ARROW)) then
	User -> collisionMove (0, -1, walls)
    end if

    if (chars (KEY_RIGHT_ARROW)) then
	User -> collisionMove (1, 0, walls)
    end if

    if (chars (KEY_LEFT_ARROW)) then
	User -> collisionMove (-1, 0, walls)
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
