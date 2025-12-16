/**
* Returns a best attempt at the least-nested containing movable of subject, or subject.
* eg, if subject is an item in a bag on a mob in a locker in the world, returns the locker.
*/
/proc/get_atom_on_turf(atom/movable/subject)
	var/atom/parent = subject?.loc
	if (!parent || !ismovable(subject) || isarea(parent))
		return subject
	var/atom/current = subject
	do
		parent = current.loc
		if (isturf(parent))
			return current
		current = parent
	while (current)
	return subject


/proc/iswall(turf/T)
	return (istype(T, /turf/simulated/wall) || istype(T, /turf/unsimulated/wall) || istype(T, /turf/simulated/shuttle/wall))

/proc/isfloor(turf/T)
	return (istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor) || istype(T, /turf/simulated/shuttle/floor))

/proc/turf_clear(turf/T)
	for(var/atom/A in T)
		if(A.simulated)
			return 0
	return 1

// Picks a turf without a mob from the given list of turfs, if one exists.
// If no such turf exists, picks any random turf from the given list of turfs.
/proc/pick_mobless_turf_if_exists(var/list/start_turfs)
	if(!start_turfs.len)
		return null

	var/list/available_turfs = list()
	for(var/start_turf in start_turfs)
		var/mob/M = locate() in start_turf
		if(!M)
			available_turfs += start_turf
	if(!available_turfs.len)
		available_turfs = start_turfs
	return pick(available_turfs)

// Picks a turf that is clearance tiles away from the map edge given by dir, on z-level Z
/proc/pick_random_edge_turf(var/dir, var/Z, var/clearance = TRANSITIONEDGE + 1)
	if(!dir)
		return
	switch(dir)
		if(NORTH)
			return locate(rand(clearance, world.maxx - clearance), world.maxy - clearance, Z)
		if(SOUTH)
			return locate(rand(clearance, world.maxx - clearance), clearance, Z)
		if(EAST)
			return locate(world.maxx - clearance, rand(clearance, world.maxy - clearance), Z)
		if(WEST)
			return locate(clearance, rand(clearance, world.maxy - clearance), Z)

/proc/is_below_sound_pressure(var/turf/T)
	var/datum/gas_mixture/environment = T ? T.return_air() : null
	var/pressure =  environment ? environment.return_pressure() : 0
	if(pressure < SOUND_MINIMUM_PRESSURE)
		return TRUE
	return FALSE

/*
	Turf manipulation
*/

//Returns an assoc list that describes how turfs would be changed if the
//turfs in turfs_src were translated by shifting the src_origin to the dst_origin
/proc/get_turf_translation(turf/src_origin, turf/dst_origin, list/turfs_src)
	var/list/turf_map = list()
	for(var/turf/source in turfs_src)
		var/x_pos = (source.x - src_origin.x)
		var/y_pos = (source.y - src_origin.y)
		var/z_pos = (source.z - src_origin.z)

		var/turf/target = locate(dst_origin.x + x_pos, dst_origin.y + y_pos, dst_origin.z + z_pos)
		if(!target)
			log_world("## ERROR Null turf in translation @ ([dst_origin.x + x_pos], [dst_origin.y + y_pos], [dst_origin.z + z_pos])")
		turf_map[source] = target //if target is null, preserve that information in the turf map

	return turf_map

/proc/translate_turfs(var/list/translation, var/area/base_area = null, var/turf/base_turf)
	for(var/turf/source in translation)

		var/turf/target = translation[source]

		if(target)
			if(base_area) ChangeArea(target, get_area(source))
			var/leave_turf = base_turf ? base_turf : get_base_turf_by_area(base_area ? base_area : source)
			translate_turf(source, target, leave_turf)
			if(base_area) ChangeArea(source, base_area)

	//change the old turfs (Currently done by translate_turf for us)
	//for(var/turf/source in translation)
	//	source.ChangeTurf(base_turf ? base_turf : get_base_turf_by_area(source), 1, 1)

// Parmaters for stupid historical reasons are:
// T - Origin
// B - Destination
/proc/translate_turf(var/turf/T, var/turf/B, var/turftoleave = null)

	//You can stay, though.
	if(istype(T,/turf/space))
		log_world("## ERROR Tried to translate a space turf: src=[log_info_line(T)] dst=[log_info_line(B)]")
		return FALSE // TODO - Is this really okay to do nothing?

	var/turf/X //New Destination Turf

	//Are we doing shuttlework? Just to save another type check later.
	var/shuttlework = 0

	T.pre_translate_A(B)
	B.pre_translate_B(T)

	//Shuttle turfs handle their own fancy moving.
	if(istype(T,/turf/simulated/shuttle))
		shuttlework = 1
		var/turf/simulated/shuttle/SS = T
		if(!SS.landed_holder) SS.landed_holder = new(SS)
		X = SS.landed_holder.land_on(B)

	//Generic non-shuttle turf move.
	else
		var/old_dir1 = T.dir
		var/old_icon_state1 = T.icon_state
		var/old_icon1 = T.icon
		var/old_decals = T.decals ? T.decals.Copy() : null

		//B.Destroy()
		X = B.ChangeTurf(T.type)
		X.setDir(old_dir1)
		X.icon_state = old_icon_state1
		X.icon = old_icon1
		X.copy_overlays(T, TRUE)
		X.decals = old_decals

	//Move the air from source to dest
	var/turf/simulated/ST = T
	if(istype(ST) && ST.zone)
		var/turf/simulated/SX = X
		if(!SX.air)
			SX.make_air()
		SX.air.copy_from(ST.zone.air)
		ST.zone.remove(ST)

	var/z_level_change = FALSE
	if(T.z != X.z)
		z_level_change = TRUE

	//Move the objects. Not forceMove because the object isn't "moving" really, it's supposed to be on the "same" turf.
	for(var/obj/O in T)
		if(O.simulated)
			O.loc = X
			if(O.light_system == STATIC_LIGHT)
				O.update_light()
			if(z_level_change) // The objects still need to know if their z-level changed.
				O.onTransitZ(T.z, X.z)

	//Move the mobs unless it's an AI eye or other eye type.
	for(var/mob/M in T)
		if(isEye(M)) continue // If we need to check for more mobs, I'll add a variable
		M.loc = X

		if(z_level_change) // Same goes for mobs.
			M.onTransitZ(T.z, X.z)

	if(shuttlework)
		var/turf/simulated/shuttle/SS = T
		SS.landed_holder.leave_turf(turftoleave)
	else if(turftoleave)
		T.ChangeTurf(turftoleave)
	else
		T.ChangeTurf(get_base_turf_by_area(T))

	T.post_translate_A(B)
	B.post_translate_B(T)

	return TRUE

//Used for border objects. This returns true if this atom is on the border between the two specified turfs
//This assumes that the atom is located inside the target turf
/atom/proc/is_between_turfs(var/turf/origin, var/turf/target)
	if (flags & ON_BORDER)
		var/testdir = get_dir(target, origin)
		return (dir & testdir)
	return TRUE

///similar function to RANGE_TURFS(), but will search spiralling outwards from the center (like the above, but only turfs)
/proc/spiral_range_turfs(dist = 0, center = usr, orange = FALSE, list/outlist = list(), tick_checked)
	outlist.Cut()
	if(!dist)
		outlist += center
		return outlist

	var/turf/t_center = get_turf(center)
	if(!t_center)
		return outlist

	var/list/turf_list = outlist
	var/turf/checked_turf
	var/y
	var/x
	var/c_dist = 1

	if(!orange)
		turf_list += t_center

	while( c_dist <= dist )
		y = t_center.y + c_dist
		x = t_center.x - c_dist + 1
		for(x in x to t_center.x + c_dist)
			checked_turf = locate(x, y, t_center.z)
			if(checked_turf)
				turf_list += checked_turf

		y = t_center.y + c_dist - 1
		x = t_center.x + c_dist
		for(y in t_center.y - c_dist to y)
			checked_turf = locate(x, y, t_center.z)
			if(checked_turf)
				turf_list += checked_turf

		y = t_center.y - c_dist
		x = t_center.x + c_dist - 1
		for(x in t_center.x - c_dist to x)
			checked_turf = locate(x, y, t_center.z)
			if(checked_turf)
				turf_list += checked_turf

		y = t_center.y - c_dist + 1
		x = t_center.x - c_dist
		for(y in y to t_center.y + c_dist)
			checked_turf = locate(x, y, t_center.z)
			if(checked_turf)
				turf_list += checked_turf
		c_dist++
		if(tick_checked)
			CHECK_TICK

	return turf_list

/**
 * Converts mouse-pos control coordinates to a specific turf location on the map.
 *
 * Handles the conversion between control-space mouse coordinates and screen-space map coordinates,
 * accounting for various BYOND quirks and display scaling factors.
 *
 * @param mousepos_x	The x-coordinate of the mouse click (in control pixels, top-left origin)
 * @param mousepos_y	The y-coordinate of the mouse click (in control pixels, top-left origin)
 * @param sizex			x control width of the map
 * @param sizey			y control width of the map
 * @param viewing_client The client whose view perspective to use for the conversion
 *
 * @return The turf at the calculated map position, or the closest one if out of bounds, as well as the residual x and y map offsets
 *
 * Important Notes:
 * - This WILL be incorrect when client pixel_wxyz is animating, and it WILL be incorrect if the user is gliding, because we don't have a good way to compensate this on the serverside. Yay!!!
 * - Mouse coordinates originate from the top-left corner because we can't have consistency in this engine
 * - Coordinate systems are inconsistent between control pixels and screen pixels
 * - Something on the byond side (icon size likely? needs debugging) affects the control pixels
 * - This uses the ratios between them rather than absolute values for reliable results
 * - For absolute value comparisons, dividing by 2 may work as a temporary hack,
 *   but using ratios (as implemented in the proc) is the recommended approach
 */
/proc/get_loc_from_mousepos(mousepos_x, mousepos_y, sizex, sizey, client/viewing_client)
	if(sizex == 0 || sizey == 0) //contexts where this information is not availible should return 0 in size, aka tgui passthrough
		return list(null, 0, 0)
	var/turf/baseloc = get_turf(viewing_client.eye)
	var/list/actual_view = getviewsize(viewing_client ? viewing_client.view : world.view)

	var/screen_width = actual_view[1] * ICON_SIZE_X
	var/screen_height = actual_view[2] * ICON_SIZE_Y

	//handle letterboxing to get the right sizes and mouseposes
	var/size_ratio = sizex/sizey
	var/screen_ratio = screen_width/screen_height
	if(size_ratio < screen_ratio) //sizex too high, y has black banners
		var/effective_height = sizex / screen_ratio
		var/banner_height = (sizey - effective_height) / 2
		mousepos_y -= banner_height
		sizey -= (banner_height*2)
	else if (size_ratio > screen_ratio) //sizey too high, x has black banners
		var/effective_width = sizey * screen_ratio
		var/banner_width = (sizex - effective_width) / 2
		mousepos_x -= banner_width
		sizex -= (banner_width*2)

	// if its a black banner, just assume we clicked the turf
	mousepos_x = max(mousepos_x, 0)
	mousepos_y = max(mousepos_y, 0)

	//fix ratios being off due to screen width/height
	var/x_ratio = sizex/screen_width
	var/y_ratio = sizey/screen_height
	mousepos_x /= x_ratio
	mousepos_y /= y_ratio

	//relative to bottom left corner of turf in the middle of the screen
	var/relative_x = mousepos_x - (screen_width / 2) + (ICON_SIZE_X/2) + viewing_client.pixel_x + viewing_client.pixel_w
	var/relative_y = -(mousepos_y - (screen_height / 2))+ (ICON_SIZE_Y/2) - 1 + viewing_client.pixel_y + viewing_client.pixel_z
	var/turf_x_diff = FLOOR(relative_x / ICON_SIZE_X, 1)
	var/turf_y_diff = FLOOR(relative_y / ICON_SIZE_Y, 1)

	var/click_turf_x = baseloc.x + turf_x_diff
	var/click_turf_y = baseloc.y + turf_y_diff
	var/click_turf_z = baseloc.z

	var/turf/click_turf = locate(clamp(click_turf_x, 1, world.maxx), clamp(click_turf_y, 1, world.maxy), click_turf_z)

	var/x_residual = relative_x % ICON_SIZE_X
	var/y_residual = relative_y % ICON_SIZE_Y
	return list(click_turf, x_residual, y_residual)
