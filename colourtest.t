% Kevin Folz,the_short1 @compsci.ca, Feb. 2004
% Program To Display each color number in taht color
% Ie: Color:14 <in color yellow
View.Set ("Graphics:650;500,title:Color Previewer By Kevin The_Short1,nobuttonbar,position:top;left")
var c, r : int := 1
colorback (black)
cls
for a : 1 .. 255
    color (a)
    locate (r, c)
    put "Color:", a ..
    r := r + 1
    if r = 32 then
	r := 1
	c := c + 10
    end if
end for
