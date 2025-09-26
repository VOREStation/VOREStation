///Component that updates the icon_state of an item when something approaches it while it's being worn.
/datum/component/reactive_icon_update
	dupe_mode = COMPONENT_DUPE_UNIQUE
	///What we want to append to our icon_state when our conditions are filled
	var/icon_prefix
	///List of which directions we want to be valid. Can be NORTH/SOUTH/EAST/WEST.
	var/list/directions
	///Range that we want it to look out for.
	var/range

/datum/component/reactive_icon_update/Initialize(icon_prefix, list/directions, range)
	if(!isitem(parent) || !isnum(range) || !icon_prefix || (!directions || !LAZYLEN(directions)))
		return COMPONENT_INCOMPATIBLE

	src.icon_prefix = icon_prefix
	src.directions = directions
	src.range = range

	var/static/list/connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(update_proximity_icon),
	)
	AddComponent(/datum/component/connect_range, parent, connections, range)

/datum/component/reactive_icon_update/proc/update_proximity_icon(atom/movable/AM, atom/old_loc)
	SIGNAL_HANDLER
	var/obj/item/our_item = parent
	if(!ismob(AM)) //Yes, ghosts can also trigger this!
		return
	var/mob/M = AM
	if(M == our_item.loc) //Ignore the mob wearing us
		return

	///What direction the mob is relative to us.
	var/mob_direction_x
	var/mob_direction_y
	var/actual_direction

	///First, we get the X and Y coordinates
	if(M.x > our_item.x)
		mob_direction_x = EAST
	else if(M.x < our_item.x)
		mob_direction_x = WEST
	else
		mob_direction_x = null //Same X as us

	if(M.y > our_item.y)
		mob_direction_y = SOUTH
	else if(M.y < our_item.y)
		mob_direction_y = NORTH
	else
		mob_direction_y = null //Same Y as us

	///Then we combine them to get our actual direction, not just cardinals.
	if(mob_direction_x == EAST && mob_direction_y == SOUTH) //Diagonals first
		actual_direction = SOUTHEAST
	else if(mob_direction_x == EAST && mob_direction_y == NORTH)
		actual_direction = NORTHEAST
	else if(mob_direction_x == WEST && mob_direction_y == SOUTH)
		actual_direction = SOUTHWEST
	else if(mob_direction_x == WEST && mob_direction_y == NORTH)
		actual_direction = NORTHWEST
	else if(mob_direction_x) //Only horizontal
		actual_direction = mob_direction_x
	else if(mob_direction_y) //Only vertical
		actual_direction = mob_direction_y
	else //Exactly ontop of us, so we don't care about direction.
		actual_direction = null
		return

	///We then make sure the actual_direction is in our directions list.
	if(actual_direction && !(actual_direction in directions)) //Not a valid direction. Convert to N/E/S/W
		//East and west take priority because those are generally the most visually striking.
		if(WEST in directions && (actual_direction == (NORTHWEST || SOUTHWEST)))
			actual_direction = WEST
		else if(EAST in directions && (actual_direction == (NORTHEAST || SOUTHEAST)))
			actual_direction = EAST
		else if(SOUTH in directions && (actual_direction == (SOUTHWEST || SOUTHEAST)))
			actual_direction = SOUTH
		else if(NORTH in directions && (actual_direction == (NORTHWEST || NORTHEAST)))
			actual_direction = NORTH
		else
			return
	//We then update our icon state. For example:
	//We have an item that has the icon_state of "cloak" and the prefix of "_direction" and we're facing NORTH
	//The icon_state will be changed to cloak_direction_north
	our_item.icon_state = initial(icon_state) + icon_prefix + "_" + actual_direction
