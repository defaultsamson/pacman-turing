setscreen ("graphics:448;576, nobuttonbar, position:center;center, noecho, offscreenonly")

% Initializes all the procedures and their parameters
forward proc drawPlayScreen
forward proc drawNumber (x : int, y : int, number : int, anchor : int)
forward proc gameInput
forward proc drawMenuScreen
forward proc menuInput
forward proc reset
forward proc updateAI

const debug := false

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
const iMap : int := Pic.Scale (Pic.FileNew ("pacman/map.bmp"), maxx + 1, maxy + 2)

var iPacmanLeft : array 0 .. 3 of int
iPacmanLeft (0) := Pic.Scale (Pic.FileNew ("pacman/pacman0.bmp"), 32, 32)
iPacmanLeft (1) := Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32)
iPacmanLeft (2) := Pic.Scale (Pic.FileNew ("pacman/pacman2.bmp"), 32, 32)
iPacmanLeft (3) := Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32)

var iPacmanDown : array 0 .. 3 of int
iPacmanDown (0) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman0.bmp"), 32, 32), 90, 16, 16)
iPacmanDown (1) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32), 90, 16, 16)
iPacmanDown (2) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman2.bmp"), 32, 32), 90, 16, 16)
iPacmanDown (3) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32), 90, 16, 16)

var iPacmanRight : array 0 .. 3 of int
iPacmanRight (0) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman0.bmp"), 32, 32), 180, 16, 16)
iPacmanRight (1) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32), 180, 16, 16)
iPacmanRight (2) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman2.bmp"), 32, 32), 180, 16, 16)
iPacmanRight (3) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32), 180, 16, 16)

var iPacmanUp : array 0 .. 3 of int
iPacmanUp (0) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman0.bmp"), 32, 32), 270, 16, 16)
iPacmanUp (1) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32), 270, 16, 16)
iPacmanUp (2) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman2.bmp"), 32, 32), 270, 16, 16)
iPacmanUp (3) := Pic.Rotate (Pic.Scale (Pic.FileNew ("pacman/pacman1.bmp"), 32, 32), 270, 16, 16)

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
    import debug
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

    fcn collisionMove (xOff, yOff : int, rects : array 0 .. * of ^Rectangle) : boolean
	move (xOff, yOff)

	for i : 0 .. upper (rects)
	    if isTouching (rects (i)) then
		move (-xOff, -yOff)
		result false
	    end if
	end for

	result true
    end collisionMove



    proc draw
	if debug then
	    Draw.Line (x * 2, y * 2, x * 2, (y + height) * 2, white)
	    Draw.Line (x * 2, (y + height) * 2, (x + width) * 2, (y + height) * 2, white)
	    Draw.Line ((x + width) * 2, (y + height) * 2, (x + width) * 2, y * 2, white)
	    Draw.Line ((x + width) * 2, y * 2, x * 2, y * 2, white)
	end if
	%drawfillbox (x * 2, y * 2, (x + width) * 2, (y + height) * 2, white)
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

    fcn collisionMove (xOff, yOff : int, rects : array 0 .. * of ^Rectangle) : boolean
	result rec -> collisionMove (xOff, yOff, rects)
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

User -> setRectangle (104, 116, 16, 16)
User -> setFrames (iPacmanUp, 5, 0, 0)

var bottomWall0 : ^Rectangle
new bottomWall0
bottomWall0 -> setRectangle (0, 16, 224, 4)

var bottomWall1 : ^Rectangle
new bottomWall1
bottomWall1 -> setRectangle (0, 16, 4, 124)

var bottomWall2 : ^Rectangle
new bottomWall2
bottomWall2 -> setRectangle (20, 36, 72, 8)

var bottomWall3 : ^Rectangle
new bottomWall3
bottomWall3 -> setRectangle (132, 36, 72, 8)

var bottomWall4 : ^Rectangle
new bottomWall4
bottomWall4 -> setRectangle (220, 16, 4, 124)

var bottomWall5 : ^Rectangle
new bottomWall5
bottomWall5 -> setRectangle (108, 36, 8, 32)

var bottomWall6 : ^Rectangle
new bottomWall6
bottomWall6 -> setRectangle (84, 60, 56, 8)

var bottomWall7 : ^Rectangle
new bottomWall7
bottomWall7 -> setRectangle (60, 36, 8, 32)

var bottomWall8 : ^Rectangle
new bottomWall8
bottomWall8 -> setRectangle (156, 36, 8, 32)

var bottomWall9 : ^Rectangle
new bottomWall9
bottomWall9 -> setRectangle (0, 60, 20, 8)

var bottomWall10 : ^Rectangle
new bottomWall10
bottomWall10 -> setRectangle (204, 60, 20, 8)

var bottomWall11 : ^Rectangle
new bottomWall11
bottomWall11 -> setRectangle (60, 84, 32, 8)

var bottomWall12 : ^Rectangle
new bottomWall12
bottomWall12 -> setRectangle (132, 84, 32, 8)

var bottomWall13 : ^Rectangle
new bottomWall13
bottomWall13 -> setRectangle (108, 84, 8, 32)

var bottomWall14 : ^Rectangle
new bottomWall14
bottomWall14 -> setRectangle (84, 108, 56, 8)

var leftWall1 : ^Rectangle
new leftWall1
leftWall1 -> setRectangle (0, 108, 44, 32)

var leftWall2 : ^Rectangle
new leftWall2
leftWall2 -> setRectangle (36, 60, 8, 32)

var rightWall1 : ^Rectangle
new rightWall1
rightWall1 -> setRectangle (180, 108, 44, 32)

var rightWall2 : ^Rectangle
new rightWall2
rightWall2 -> setRectangle (180, 60, 8, 32)

var leftWall3 : ^Rectangle
new leftWall3
leftWall3 -> setRectangle (20, 84, 24, 8)

var rightWall3 : ^Rectangle
new rightWall3
rightWall3 -> setRectangle (180, 84, 24, 8)

var leftWall4 : ^Rectangle
new leftWall4
leftWall4 -> setRectangle (0, 156, 44, 32)

var rightWall4 : ^Rectangle
new rightWall4
rightWall4 -> setRectangle (180, 156, 44, 32)

var leftWall5 : ^Rectangle
new leftWall5
leftWall5 -> setRectangle (60, 108, 8, 32)

var rightWall5 : ^Rectangle
new rightWall5
rightWall5 -> setRectangle (156, 108, 8, 32)

var centerWall1 : ^Rectangle
new centerWall1
centerWall1 -> setRectangle (84, 132, 56, 4)

var centerWall2 : ^Rectangle
new centerWall2
centerWall2 -> setRectangle (84, 132, 4, 32)

var centerWall3 : ^Rectangle
new centerWall3
centerWall3 -> setRectangle (84, 160, 20, 4)

var centerWall4 : ^Rectangle
new centerWall4
centerWall4 -> setRectangle (120, 160, 20, 4)

var centerWall5 : ^Rectangle
new centerWall5
centerWall5 -> setRectangle (136, 132, 4, 32)

var leftWall6 : ^Rectangle
new leftWall6
leftWall6 -> setRectangle (0, 156, 4, 108)

var rightWall6 : ^Rectangle
new rightWall6
rightWall6 -> setRectangle (220, 156, 4, 108)

var upperWall1 : ^Rectangle
new upperWall1
upperWall1 -> setRectangle (0, 260, 224, 4)

var upperWall2 : ^Rectangle
new upperWall2
upperWall2 -> setRectangle (108, 228, 8, 36)

var upperWall3 : ^Rectangle
new upperWall3
upperWall3 -> setRectangle (108, 180, 8, 32)

var upperWall4 : ^Rectangle
new upperWall4
upperWall4 -> setRectangle (84, 204, 56, 8)

var upperWall5 : ^Rectangle
new upperWall5
upperWall5 -> setRectangle (60, 228, 32, 16)

var upperWall6 : ^Rectangle
new upperWall6
upperWall6 -> setRectangle (132, 228, 32, 16)

var upperWall7 : ^Rectangle
new upperWall7
upperWall7 -> setRectangle (20, 228, 24, 16)

var upperWall8 : ^Rectangle
new upperWall8
upperWall8 -> setRectangle (180, 228, 24, 16)

var upperWall9 : ^Rectangle
new upperWall9
upperWall9 -> setRectangle (20, 204, 24, 8)

var upperWall10 : ^Rectangle
new upperWall10
upperWall10 -> setRectangle (180, 204, 24, 8)

var upperWall11 : ^Rectangle
new upperWall11
upperWall11 -> setRectangle (60, 156, 8, 56)

var upperWall12 : ^Rectangle
new upperWall12
upperWall12 -> setRectangle (156, 156, 8, 56)

var upperWall13 : ^Rectangle
new upperWall13
upperWall13 -> setRectangle (60, 180, 32, 8)

var upperWall14 : ^Rectangle
new upperWall14
upperWall14 -> setRectangle (132, 180, 32, 8)

var walls : array 0 .. 45 of ^Rectangle
walls (0) := bottomWall0
walls (1) := bottomWall1
walls (2) := bottomWall2
walls (3) := bottomWall3
walls (4) := bottomWall4
walls (5) := bottomWall5
walls (6) := bottomWall6
walls (7) := bottomWall7
walls (8) := bottomWall8
walls (9) := bottomWall9
walls (10) := bottomWall10
walls (11) := bottomWall11
walls (12) := bottomWall12
walls (13) := bottomWall13
walls (14) := bottomWall14
walls (15) := leftWall1
walls (16) := leftWall2
walls (17) := rightWall1
walls (18) := rightWall2
walls (19) := leftWall3
walls (20) := rightWall3
walls (21) := leftWall4
walls (22) := rightWall4
walls (23) := leftWall5
walls (24) := rightWall5
walls (25) := centerWall1
walls (26) := centerWall2
walls (27) := centerWall3
walls (28) := centerWall4
walls (29) := centerWall5
walls (30) := leftWall6
walls (31) := rightWall6
walls (32) := upperWall1
walls (33) := upperWall2
walls (34) := upperWall3
walls (35) := upperWall4
walls (36) := upperWall5
walls (37) := upperWall6
walls (38) := upperWall7
walls (39) := upperWall8
walls (40) := upperWall9
walls (41) := upperWall10
walls (42) := upperWall11
walls (43) := upperWall12
walls (44) := upperWall13
walls (45) := upperWall14

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

var autoUp := false
var autoUpOverride := true
var autoDown := false
var autoDownOverride := true
var autoRight := false
var autoRightOverride := true
var autoLeft := false
var autoLeftOverride := true

% Detects when players presses the key for in-game
body proc gameInput
    var chars : array char of boolean
    Input.KeyDown (chars)

    if (chars (KEY_UP_ARROW)) then
	if User -> collisionMove (0, 1, walls) then
	    autoUp := true
	    autoDown := false
	    autoUpOverride := true
	end if
    else
	autoUpOverride := false
    end if

    if (chars (KEY_DOWN_ARROW)) then
	if User -> collisionMove (0, -1, walls) then
	    autoDown := true
	    autoUp := false
	    autoDownOverride := true
	end if
    else
	autoDownOverride := false
    end if

    if (chars (KEY_RIGHT_ARROW)) then
	if User -> collisionMove (1, 0, walls) then
	    autoRight := true
	    autoLeft := false
	    autoRightOverride := true
	end if
    else
	autoRightOverride := false
    end if

    if (chars (KEY_LEFT_ARROW)) then
	if User -> collisionMove (-1, 0, walls) then
	    autoLeft := true
	    autoRight := false
	    autoLeftOverride := true
	end if
    else
	autoLeftOverride := false
    end if

    if autoRight and not autoRightOverride then
	if not User -> collisionMove (1, 0, walls) then
	    autoRight := false
	end if
    elsif autoLeft and not autoLeftOverride then
	if not User -> collisionMove (-1, 0, walls) then
	    autoLeft := false
	end if
    elsif autoUp and not autoUpOverride then
	if not User -> collisionMove (0, 1, walls) then
	    autoUp := false
	end if
    elsif autoDown and not autoDownOverride then
	if not User -> collisionMove (0, -1, walls) then
	    autoDown := false
	end if
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
