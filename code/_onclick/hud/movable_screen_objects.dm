
//////////////////////////
//Movable Screen Objects//
//   By RemieRichards	//
//////////////////////////


//Movable Screen Object
//Not tied to the grid, places it's center where the cursor is

/obj/screen/movable
	mouse_drag_pointer = 'icons/effects/mouse_pointers/screen_drag.dmi'
	var/snap2grid = FALSE
	var/moved = FALSE
	var/locked = FALSE
	var/x_off = -16
	var/y_off = -16

//Snap Screen Object
//Tied to the grid, snaps to the nearest turf

/obj/screen/movable/snap
	snap2grid = TRUE


/obj/screen/movable/MouseDrop(over_object, src_location, over_location, src_control, over_control, params)
	if(locked) // no! i am locked! begone!
		return
	var/position = mouse_params_to_position(params)
	if(!position)
		return

	screen_loc = position
	moved = screen_loc

/// Takes mouse parmas as input, returns a string representing the appropriate mouse position
/obj/screen/movable/proc/mouse_params_to_position(params)
	var/list/modifiers = params2list(params)

	//No screen-loc information? abort.
	if(!LAZYACCESS(modifiers, SCREEN_LOC))
		return

	var/client/our_client = usr.client
	var/list/offset = screen_loc_to_offset(LAZYACCESS(modifiers, SCREEN_LOC), our_client?.view)

	if(snap2grid) //Discard Pixel Values
		offset[1] = FLOOR(offset[1], ICON_SIZE_X) // drops any pixel offset
		offset[2] = FLOOR(offset[2], ICON_SIZE_Y) // drops any pixel offset
	else //Normalise Pixel Values (So the object drops at the center of the mouse, not 16 pixels off)
		offset[1] += x_off
		offset[2] += y_off
	return offset_to_screen_loc(offset[1], offset[2], our_client?.view)

// Must stay for now, for subtypes
/obj/screen/movable/proc/encode_screen_X(X)
	var/view_dist = world.view
	if(view_dist)
		view_dist = view_dist
	if(X > view_dist+1)
		. = "EAST-[view_dist *2 + 1-X]"
	else if(X < view_dist +1)
		. = "WEST+[X-1]"
	else
		. = "CENTER"

/obj/screen/movable/proc/decode_screen_X(X)
	var/view_dist = world.view
	if(view_dist)
		view_dist = view_dist
	//Find EAST/WEST implementations
	if(findtext(X,"EAST-"))
		var/num = text2num(copytext(X,6)) //Trim EAST-
		if(!num)
			num = 0
		. = view_dist*2 + 1 - num
	else if(findtext(X,"WEST+"))
		var/num = text2num(copytext(X,6)) //Trim WEST+
		if(!num)
			num = 0
		. = num+1
	else if(findtext(X,"CENTER"))
		. = view_dist+1
	else
		. = text2num(X)

/obj/screen/movable/proc/encode_screen_Y(Y)
	var/view_dist = world.view
	if(view_dist)
		view_dist = view_dist
	if(Y > view_dist+1)
		. = "NORTH-[view_dist*2 + 1-Y]"
	else if(Y < view_dist+1)
		. = "SOUTH+[Y-1]"
	else
		. = "CENTER"

/obj/screen/movable/proc/decode_screen_Y(Y)
	var/view_dist = world.view
	if(view_dist)
		view_dist = view_dist
	if(findtext(Y,"NORTH-"))
		var/num = text2num(copytext(Y,7)) //Trim NORTH-
		if(!num)
			num = 0
		. = view_dist*2 + 1 - num
	else if(findtext(Y,"SOUTH+"))
		var/num = text2num(copytext(Y,7)) //Time SOUTH+
		if(!num)
			num = 0
		. = num+1
	else if(findtext(Y,"CENTER"))
		. = view_dist+1
	else
		. = text2num(Y)

//Debug procs
/client/proc/test_movable_UI()
	set category = "Debug"
	set name = "Spawn Movable UI Object"

	var/obj/screen/movable/M = new()
	M.name = "Movable UI Object"
	M.icon_state = "block"
	M.maptext = "Movable"
	M.maptext_width = 64

	var/screen_l = tgui_input_text(usr,"Where on the screen? (Formatted as 'X,Y' e.g: '1,1' for bottom left)","Spawn Movable UI Object")
	if(!screen_l)
		return

	M.screen_loc = screen_l

	screen += M


/client/proc/test_snap_UI()
	set category = "Debug"
	set name = "Spawn Snap UI Object"

	var/obj/screen/movable/snap/S = new()
	S.name = "Snap UI Object"
	S.icon_state = "block"
	S.maptext = "Snap"
	S.maptext_width = 64

	var/screen_l = tgui_input_text(usr,"Where on the screen? (Formatted as 'X,Y' e.g: '1,1' for bottom left)","Spawn Snap UI Object")
	if(!screen_l)
		return

	S.screen_loc = screen_l

	screen += S
