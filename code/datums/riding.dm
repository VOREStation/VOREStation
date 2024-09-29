// This is used to make things that are supposed to move while buckled more consistant and easier to handle code-wise.

/datum/riding
	var/next_vehicle_move = 0			// Used for move delays
	var/vehicle_move_delay = 2 			// Decisecond delay between movements, lower = faster, higher = slower
	var/keytype = null					// Can give this a type to require the rider to hold the item type inhand to move the ridden atom.
	var/nonhuman_key_exemption = FALSE	// If true, nonhumans who can't hold keys don't need them, like borgs and simplemobs.
	var/key_name = "the keys"			// What the 'keys' for the thing being rided on would be called.
	var/atom/movable/ridden = null 		// The thing that the datum is attached to.
	var/only_one_driver = FALSE			// If true, only the person in 'front' (first on list of riding mobs) can drive.
	var/rider_size = 1					// VOREStation Edit to figure out offsets for rider.

/datum/riding/New(atom/movable/_ridden)
	ridden = _ridden

/datum/riding/Destroy()
	ridden = null
	return ..()

/datum/riding/proc/handle_vehicle_layer()
	if(ridden.dir != NORTH)
		ridden.layer = ABOVE_MOB_LAYER
	else
		ridden.layer = OBJ_LAYER

/datum/riding/proc/on_vehicle_move()
	for(var/mob/living/M in ridden.buckled_mobs)
		ride_check(M)
	handle_vehicle_offsets()
	handle_vehicle_layer()

/datum/riding/proc/ride_check(mob/living/M)
	return TRUE

/datum/riding/proc/force_dismount(mob/living/M)
	ridden.unbuckle_mob(M)

/datum/riding/proc/handle_vehicle_offsets()
	var/ridden_dir = "[ridden.dir]"
	var/passindex = 0
	if(ridden.has_buckled_mobs())
		for(var/m in ridden.buckled_mobs)
			passindex++
			var/mob/living/buckled_mob = m
			var/list/offsets = get_offsets(passindex)
			var/rider_dir = get_rider_dir(passindex)
			buckled_mob.set_dir(rider_dir)
			dir_loop:
				for(var/offsetdir in offsets)
					if(offsetdir == ridden_dir)
						var/list/diroffsets = offsets[offsetdir]
						buckled_mob.pixel_x = diroffsets[1]
						if(diroffsets.len >= 2)
							buckled_mob.pixel_y = diroffsets[2]
						if(diroffsets.len == 3)
							buckled_mob.layer = diroffsets[3]
						break dir_loop

// Override this to set your vehicle's various pixel offsets
/datum/riding/proc/get_offsets(pass_index) // list(dir = x, y, layer)
	return list("[NORTH]" = list(0, 0), "[SOUTH]" = list(0, 0), "[EAST]" = list(0, 0), "[WEST]" = list(0, 0))

// Override this to set the passengers/riders dir based on which passenger they are.
// ie: rider facing the vehicle's dir, but passenger 2 facing backwards, etc.
/datum/riding/proc/get_rider_dir(pass_index)
	return ridden.dir

// KEYS
/datum/riding/proc/keycheck(mob/user)
	if(keytype)
		if(nonhuman_key_exemption && !ishuman(user))
			return TRUE

		if(user.is_holding_item_of_type(keytype))
			return TRUE
	else
		return TRUE
	return FALSE

// BUCKLE HOOKS
/datum/riding/proc/restore_position(mob/living/buckled_mob)
	if(istype(buckled_mob))
		buckled_mob.pixel_x = 0
		buckled_mob.pixel_y = 0
		buckled_mob.layer = initial(buckled_mob.layer)

// MOVEMENT
/datum/riding/proc/handle_ride(mob/user, direction)
	if(user.incapacitated())
		Unbuckle(user)
		return

	if(only_one_driver && ridden.buckled_mobs.len)
		var/mob/living/driver = ridden.buckled_mobs[1]
		if(driver != user)
			to_chat(user, "<span class='warning'>\The [ridden] can only be controlled by one person at a time, and is currently being controlled by \the [driver].</span>")
			return

	if(world.time < next_vehicle_move)
		return

	next_vehicle_move = world.time + vehicle_move_delay

	if(keycheck(user))
		if(!Process_Spacemove(direction) || !isturf(ridden.loc))
			return
		ridden.Move(get_step(ridden, direction), direction, vehicle_move_delay)

		handle_vehicle_layer()
		handle_vehicle_offsets()
	else
		to_chat(user, "<span class='warning'>You'll need [key_name] in one of your hands to move \the [ridden].</span>")

/datum/riding/proc/Unbuckle(atom/movable/M)
//	addtimer(CALLBACK(ridden, TYPE_PROC_REF(/atom/movable, unbuckle_mob), M), 0, TIMER_UNIQUE)
	spawn(0)
	// On /tg/ this uses the fancy CALLBACK system. Not entirely sure why they needed to do so with a duration of 0,
	// so if there is a reason, this should replicate it close enough. Hopefully.
		ridden.unbuckle_mob(M)

/datum/riding/proc/Process_Spacemove(direction)
	if(ridden.has_gravity())
		return TRUE

	return FALSE

/datum/riding/space/Process_Spacemove(direction)
	return TRUE



// SUBTYPES

// I'm on a
/datum/riding/boat
	keytype = /obj/item/oar
	key_name = "an oar"
	nonhuman_key_exemption = TRUE // Borgs can't hold oars.
	only_one_driver = TRUE // Would be pretty crazy if five people try to move at the same time.

/datum/riding/boat/handle_ride(mob/user, direction)
	var/turf/next = get_step(ridden, direction)
	var/turf/current = get_turf(ridden)

	if(istype(current, /turf/simulated/floor/water/underwater)) //don't work at the bottom of the ocean!
		to_chat(user, "<span class='warning'>The boat has sunk!</span>")
		return FALSE
	else if(istype(next, /turf/simulated/floor/water) || istype(current, /turf/simulated/floor/water)) //We can move from land to water, or water to land, but not from land to land
		..()
	else
		to_chat(user, "<span class='warning'>Boats don't go on land!</span>")
		return FALSE

/datum/riding/boat/small // 'Small' boats can hold up to two people.

/datum/riding/boat/small/get_offsets(pass_index) // list(dir = x, y, layer)
	var/H = 7 // Horizontal seperation.
	var/V = 5 // Vertical seperation.
	var/O = 2 // Vertical offset.
	switch(pass_index)
		if(1) // Person in front.
			return list(
				"[NORTH]" = list( 0, O+V, MOB_LAYER),
				"[SOUTH]" = list( 0, O,   ABOVE_MOB_LAYER),
				"[EAST]"  = list( H, O,   MOB_LAYER),
				"[WEST]"  = list(-H, O,   MOB_LAYER)
				)
		if(2) // Person in back.
			return list(
				"[NORTH]" = list( 0, O,   ABOVE_MOB_LAYER),
				"[SOUTH]" = list( 0, O+V, MOB_LAYER),
				"[EAST]"  = list(-H, O,   MOB_LAYER),
				"[WEST]"  = list( H, O,   MOB_LAYER)
				)
		else
			return null // This will runtime, but we want that since this is out of bounds.

/datum/riding/boat/small/handle_vehicle_layer()
	ridden.layer = ABOVE_MOB_LAYER

/datum/riding/boat/big // 'Big' boats can hold up to five people.

/datum/riding/boat/big/get_offsets(pass_index) // list(dir = x, y, layer)
	var/H = 12 // Horizontal seperation. Halved when facing up-down.
	var/V = 4 // Vertical seperation.
	var/O = 7 // Vertical offset.
	switch(pass_index)
		if(1) // Person in center front, first row.
			return list(
				"[NORTH]" = list( 0,   O+V,   MOB_LAYER+0.1),
				"[SOUTH]" = list( 0,   O-V,   MOB_LAYER+0.3),
				"[EAST]"  = list( H,   O,     MOB_LAYER+0.1),
				"[WEST]"  = list(-H,   O,     MOB_LAYER+0.1)
				)
		if(2) // Person in left, second row.
			return list(
				"[NORTH]" = list( H/2, O,     MOB_LAYER+0.2),
				"[SOUTH]" = list(-H/2, O,     MOB_LAYER+0.2),
				"[EAST]"  = list( 0,   O-V,   MOB_LAYER+0.2),
				"[WEST]"  = list( 0,   O+V,   MOB_LAYER)
				)
		if(3) // Person in right, second row.
			return list(
				"[NORTH]" = list(-H/2, O,     MOB_LAYER+0.2),
				"[SOUTH]" = list( H/2, O,     MOB_LAYER+0.2),
				"[EAST]"  = list( 0,   O+V,   MOB_LAYER),
				"[WEST]"  = list( 0,   O-V,   MOB_LAYER+0.2)
				)
		if(4) // Person in left, third row.
			return list(
				"[NORTH]" = list( H/2, O-V,   MOB_LAYER+0.3),
				"[SOUTH]" = list(-H/2, O+V,   MOB_LAYER+0.1),
				"[EAST]"  = list(-H,   O-V,   MOB_LAYER+0.2),
				"[WEST]"  = list( H,   O+V,   MOB_LAYER)
				)
		if(5) // Person in right, third row.
			return list(
				"[NORTH]" = list(-H/2, O-V,   MOB_LAYER+0.3),
				"[SOUTH]" = list( H/2, O+V,   MOB_LAYER+0.1),
				"[EAST]"  = list(-H,   O+V,   MOB_LAYER),
				"[WEST]"  = list( H,   O-V,   MOB_LAYER+0.2)
				)
		else
			return null // This will runtime, but we want that since this is out of bounds.

/datum/riding/boat/big/handle_vehicle_layer()
	ridden.layer = MOB_LAYER+0.4

/datum/riding/boat/get_offsets(pass_index) // list(dir = x, y, layer)
	return list("[NORTH]" = list(1, 2), "[SOUTH]" = list(1, 2), "[EAST]" = list(1, 2), "[WEST]" = list(1, 2))

/datum/riding/snowmobile
	only_one_driver = TRUE // Keep your hands to yourself back there!

/datum/riding/snowmobile/get_offsets(pass_index) // list(dir = x, y, layer)
	var/H = 3 // Horizontal seperation.
	var/V = 2 // Vertical seperation.
	var/O = 2 // Vertical offset.
	switch(pass_index)
		if(1) // Person on front.
			return list(
				"[NORTH]" = list( 0, O+V, MOB_LAYER),
				"[SOUTH]" = list( 0, O,   ABOVE_MOB_LAYER),
				"[EAST]"  = list( H, O,   MOB_LAYER),
				"[WEST]"  = list(-H, O,   MOB_LAYER)
				)
		if(2) // Person on back.
			return list(
				"[NORTH]" = list( 0, O,   ABOVE_MOB_LAYER),
				"[SOUTH]" = list( 0, O+V, MOB_LAYER),
				"[EAST]"  = list(-H, O,   MOB_LAYER),
				"[WEST]"  = list( H, O,   MOB_LAYER)
				)
		else
			return null // This will runtime, but we want that since this is out of bounds.
