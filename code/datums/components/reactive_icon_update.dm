///Component that updates the icon_state of an item when something approaches.
///NOTE: This uses the initial icon of the object, meaning it will not work properly with items that change their icon_state for other reasons.
/datum/component/reactive_icon_update
	dupe_mode = COMPONENT_DUPE_UNIQUE
	///What we want to append to our icon_state when our conditions are filled
	var/icon_prefix
	///List of which directions we want to be valid. Can be NORTH/SOUTH/EAST/WEST along with NORTHEAST/SOUTHEAST/SOUTHWEST/NORTHWEST
	var/list/directions
	///Range that we want it to look out for.
	var/range
	///What type of mobs trigger the icon change.
	var/list/triggering_mobs = list(/mob/living)

/datum/component/reactive_icon_update/Initialize(icon_prefix, list/directions, range, triggering_mobs)
	if(!isobj(parent) || !isnum(range) || (!directions || !LAZYLEN(directions)) || (triggering_mobs && !LAZYLEN(triggering_mobs)))
		return COMPONENT_INCOMPATIBLE

	src.icon_prefix = icon_prefix
	src.directions = directions
	src.range = range
	if(triggering_mobs)
		src.triggering_mobs = triggering_mobs

	var/static/list/connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(update_proximity_icon),
	)
	AddComponent(/datum/component/connect_range, parent, connections, range)

/datum/component/reactive_icon_update/UnregisterFromParent()

	directions.Cut()
	triggering_mobs.Cut()

/datum/component/reactive_icon_update/proc/update_proximity_icon(atom/current_loc, atom/movable/AM, atom/old_loc)
	SIGNAL_HANDLER
	var/obj/our_item = parent
	if(!ismob(AM) || !mob_check(AM))
		return
	var/mob/M = AM
	if(M == our_item.loc) //Ignore the mob wearing us
		return

	///What direction the mob is relative to us.
	var/mob_direction_x
	var/mob_direction_y
	var/actual_direction

	///First, we get the X and Y coordinates
	var/x
	var/y
	if(our_item.x && our_item.y)
		x = our_item.x
		y = our_item.y
	if(our_item.x == 0 || our_item.y == 0) //We're inside of something! Clothing is a great example of this.
		if(our_item.loc)
			x = our_item.loc.x
			y = our_item.loc.y
			if(x == 0 || y == 0) //We're two layers deep, just give up.
				return
	if(M.x > x)
		mob_direction_x = EAST
	else if(M.x < x)
		mob_direction_x = WEST
	else
		mob_direction_x = null //Same X as us

	if(M.y > y)
		mob_direction_y = NORTH
	else if(M.y < y)
		mob_direction_y = SOUTH
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
		return

	///We then make sure the actual_direction is in our directions list.
	if(actual_direction && !(actual_direction in directions)) //Not a valid direction. Convert to N/E/S/W
		//East and west take priority because those are generally the most visually striking.
		if((WEST in directions) && (actual_direction == (NORTHWEST || SOUTHWEST)))
			actual_direction = WEST
		else if((EAST in directions) && (actual_direction == (NORTHEAST || SOUTHEAST)))
			actual_direction = EAST
		else if((SOUTH in directions) && (actual_direction == (SOUTHWEST || SOUTHEAST)))
			actual_direction = SOUTH
		else if((NORTH in directions) && (actual_direction == (NORTHWEST || NORTHEAST)))
			actual_direction = NORTH
		else
			return
	var/directional_name
	switch(actual_direction)
		if(NORTH)
			directional_name = "north"
		if(EAST)
			directional_name = "east"
		if(SOUTH)
			directional_name = "south"
		if(WEST)
			directional_name = "west"
		if(NORTHEAST)
			directional_name = "northeast"
		if(SOUTHEAST)
			directional_name = "southeast"
		if(SOUTHWEST)
			directional_name = "southwest"
		if(NORTHWEST)
			directional_name = "northwest"
	//We then update our icon state. For example:
	//We have an item that has the icon_state of "cloak" and the prefix of "_direction" and we're facing NORTH
	//The icon_state will be changed to cloak_direction_north
	our_item.icon_state = initial(our_item.icon_state) + icon_prefix + "_" + directional_name

///Variant of the reactive_icon_update component that allows for setting what slot is should be in to update it!
/datum/component/reactive_icon_update/clothing

/datum/component/reactive_icon_update/clothing/update_proximity_icon(atom/current_loc, atom/movable/AM, atom/old_loc)
	. = ..()
	//Code to actually update the mob wearing us
	var/obj/our_object = parent
	if(ishuman(our_object.loc)) //If we're being worn
		var/mob/living/carbon/human/wearing_mob = our_object.loc

		//Code to actually update the mob wearing us
		//Only suit and uniform for now...Feel free to expand if you need.
		if(wearing_mob.wear_suit == our_object)
			wearing_mob.update_inv_wear_suit()
			return
		if(wearing_mob.w_uniform == our_object)
			wearing_mob.update_inv_w_uniform()
			return


//Example item for testing directions.
/obj/item/tool/screwdriver/test_driver
	icon = 'icons/obj/directional_test.dmi'

/obj/item/tool/screwdriver/test_driver/Initialize(mapload)
	..()
	icon_state = "screwdriver"
	AddComponent(/datum/component/reactive_icon_update, directions = list(NORTH, EAST, SOUTH, WEST, SOUTHWEST, SOUTHEAST, NORTHEAST, NORTHWEST), range = 3)

/datum/component/reactive_icon_update/proc/mob_check(mob/triggering_mob)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(is_type_in_list(triggering_mob, triggering_mobs))
		return TRUE
	return FALSE
