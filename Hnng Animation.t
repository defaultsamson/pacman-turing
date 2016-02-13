	var pics : array 0 .. 2 of int
	var sprite: int
	for i : 0 .. 2
	    pics (i) := Pic.FileNew ("pacman/pacman" + intstr (i) + ".bmp")
	    if Error.Last not= 0 then
		put "Error loading image: ", Error.LastMsg
		return
	    end if
	end for
	sprite := Sprite.New (pics (0))
	Sprite.SetPosition (sprite, maxx div 2, maxy div 2, true)
	Sprite.Show (sprite)
	for i : 1 .. 100
	    Sprite.ChangePic (sprite, pics (i mod 3))
	    delay(50)
	end for
	Sprite.Free (sprite)
