/atom/movable
	layer = OBJ_LAYER
	glide_size = 8
	appearance_flags = TILE_BOUND|PIXEL_SCALE|KEEP_TOGETHER|LONG_GLIDE

	var/last_move = null
	/// A list containing arguments for Moved().
	VAR_PRIVATE/tmp/list/active_movement
	var/anchored = FALSE
	var/move_resist = MOVE_RESIST_DEFAULT
	var/move_force = MOVE_FORCE_DEFAULT
	var/pull_force = PULL_FORCE_DEFAULT
	var/mob/pulledby = null

	///Are we moving with inertia? Mostly used as an optimization
	var/inertia_moving = FALSE
	///Multiplier for inertia based movement in space
	var/inertia_move_multiplier = 1
	///Object "weight", higher weight reduces acceleration applied to the object
	var/inertia_force_weight = 1
	///0: not doing a diagonal move. 1 and 2: doing the first/second step of the diagonal move
	var/moving_diagonally = 0
	///attempt to resume grab after moving instead of before.
	var/atom/movable/moving_from_pull
	///Holds information about any movement loops currently running/waiting to run on the movable. Lazy, will be null if nothing's going on
	var/datum/movement_packet/move_packet
	///contains every client mob corresponding to every client eye in this container. lazily updated by SSparallax and is sparse:
	///only the last container of a client eye has this list assuming no movement since SSparallax's last fire
	var/list/client_mobs_in_contents

	/**
	  * In case you have multiple types, you automatically use the most useful one.
	  * IE: Skating on ice, flippers on water, flying over chasm/space, etc.
	  * I recommend you use the movetype_handler system and not modify this directly, especially for living mobs.
	  */
	var/movement_type = GROUND

	var/atom/movable/pulling
	var/grab_state = GRAB_PASSIVE
	/// The strongest grab we can acomplish
	var/max_grab = GRAB_PASSIVE

	///is the mob currently ascending or descending through z levels?
	var/currently_z_moving

	/// Whether this atom should have its dir automatically changed when it moves. Setting this to FALSE allows for things such as directional windows to retain dir on moving without snowflake code all of the place.
	var/set_dir_on_move = TRUE

	/// Datum that keeps all data related to zero-g drifting and handles related code/comsigs
	var/datum/drift_handler/drift_handler




















	var/move_speed = 10
	var/l_move_time = 1
	var/throwing = 0
	var/thrower
	var/turf/throw_source = null
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = 0
	var/item_state = null // Used to specify the item state for the on-mob overlays.
	var/icon_scale_x = DEFAULT_ICON_SCALE_X // Used to scale icons up or down horizonally in update_transform().
	var/icon_scale_y = DEFAULT_ICON_SCALE_Y // Used to scale icons up or down vertically in update_transform().
	var/icon_rotation = DEFAULT_ICON_ROTATION // Used to rotate icons in update_transform()
	var/icon_expected_height = 32
	var/icon_expected_width = 32
	var/old_x = 0
	var/old_y = 0
	var/datum/riding/riding_datum = null
	var/does_spin = TRUE // Does the atom spin when thrown (of course it does :P)
	var/cloaked = FALSE //If we're cloaked or not
	var/image/cloaked_selfimage //The image we use for our client to let them see where we are
	var/belly_cycles = 0 // Counting current belly process cycles for autotransfer.
	var/autotransferable = TRUE // Toggle for autotransfer mechanics.
	var/recursive_listeners
	var/listening_recursive = NON_LISTENING_ATOM
	var/unacidable = TRUE

/atom/movable/Initialize(mapload)
	. = ..()

	// This one is incredible.
	// `if (x) else { /* code */ }` is surprisingly fast, and it's faster than a switch, which is seemingly not a jump table.
	// From what I can tell, a switch case checks every single branch individually, although sane, is slow in a hot proc like this.
	// So, we make the most common `blocks_emissive` value, EMISSIVE_BLOCK_GENERIC, 0, getting to the fast else branch quickly.
	// If it fails, then we can check over every value it can be (here, EMISSIVE_BLOCK_UNIQUE is the only one that matters).
	// This saves several hundred milliseconds of init time.
	if (blocks_emissive)
		if (blocks_emissive == EMISSIVE_BLOCK_UNIQUE)
			render_target = ref(src)
			em_block = new(src, render_target)
			add_overlay(list(em_block), TRUE)
			RegisterSignal(em_block, COMSIG_QDELETING, PROC_REF(emblocker_gc))
	else
		var/mutable_appearance/gen_emissive_blocker = mutable_appearance(icon, icon_state, plane = PLANE_EMISSIVE, alpha = src.alpha)
		gen_emissive_blocker.color = GLOB.em_block_color
		gen_emissive_blocker.dir = dir
		gen_emissive_blocker.appearance_flags |= appearance_flags
		add_overlay(list(gen_emissive_blocker), TRUE)

	if(opacity)
		AddElement(/datum/element/light_blocking)
	if(icon_scale_x != DEFAULT_ICON_SCALE_X || icon_scale_y != DEFAULT_ICON_SCALE_Y || icon_rotation != DEFAULT_ICON_ROTATION)
		update_transform()
	switch(light_system)
		if(STATIC_LIGHT)
			update_light()
		if(MOVABLE_LIGHT)
			AddComponent(/datum/component/overlay_lighting, starts_on = light_on)
		if(MOVABLE_LIGHT_DIRECTIONAL)
			AddComponent(/datum/component/overlay_lighting, is_directional = TRUE, starts_on = light_on)
	if (listening_recursive)
		set_listening(listening_recursive)


/atom/movable/Destroy()
	if(em_block)
		cut_overlay(em_block)
		UnregisterSignal(em_block, COMSIG_QDELETING)
		QDEL_NULL(em_block)

	unbuckle_all_mobs(force = TRUE)

	if(opacity)
		RemoveElement(/datum/element/light_blocking)

	if(pulledby)
		pulledby.stop_pulling()
	if(pulling)
		stop_pulling()

	if(orbiting)
		stop_orbit()
		orbiting = null

	if(move_packet)
		if(!QDELETED(move_packet))
			qdel(move_packet)
		move_packet = null

	LAZYNULL(client_mobs_in_contents)

	. = ..()

	for(var/movable_content in contents)
		qdel(movable_content)

	moveToNullspace()

	// Checking length(vis_contents) before cutting has significant speed benefits
	if (length(vis_contents))
		vis_contents.Cut()

	for(var/atom/movable/A as anything in vis_locs)
		A.vis_contents -= src

	QDEL_NULL(riding_datum)
	set_listening(NON_LISTENING_ATOM)

/atom/movable/proc/onZImpact(turf/impacted_turf, levels, impact_flags = NONE)
	SHOULD_CALL_PARENT(TRUE)
	if(!(impact_flags & ZIMPACT_NO_MESSAGE))
		visible_message(
			span_danger("[src] crashes into [impacted_turf]!"),
			span_userdanger("You crash into [impacted_turf]!"),
		)
	if(!(impact_flags & ZIMPACT_NO_SPIN))
		INVOKE_ASYNC(src, PROC_REF(SpinAnimation), 5, 2)
	SEND_SIGNAL(src, COMSIG_ATOM_ON_Z_IMPACT, impacted_turf, levels)
	return TRUE

/*
 * Attempts to move using zMove if direction is UP or DOWN, step if not
 *
 * Args:
 * direction: The direction to go
 * z_move_flags: bitflags used for checks in zMove and can_z_move
*/
/atom/movable/proc/try_step_multiz(direction, z_move_flags = ZMOVE_FLIGHT_FLAGS)
	if(direction == UP || direction == DOWN)
		return zMove(direction, null, z_move_flags)
	return step(src, direction)

/*
 * The core multi-z movement proc. Used to move a movable through z levels.
 * If target is null, it'll be determined by the can_z_move proc, which can potentially return null if
 * conditions aren't met (see z_move_flags defines in __DEFINES/movement.dm for info) or if dir isn't set.
 * Bear in mind you don't need to set both target and dir when calling this proc, but at least one or two.
 * This will set the currently_z_moving to CURRENTLY_Z_MOVING_GENERIC if unset, and then clear it after
 * Forcemove().
 *
 *
 * Args:
 * * dir: the direction to go, UP or DOWN, only relevant if target is null.
 * * target: The target turf to move the src to. Set by can_z_move() if null.
 * * z_move_flags: bitflags used for various checks in both this proc and can_z_move(). See __DEFINES/movement.dm.
 */
/atom/movable/proc/zMove(dir, turf/target, z_move_flags = ZMOVE_FLIGHT_FLAGS)
	if(!target)
		target = can_z_move(dir, get_turf(src), null, z_move_flags)
		if(!target)
			set_currently_z_moving(FALSE, TRUE)
			return FALSE

	var/list/moving_movs = get_z_move_affected(z_move_flags)

	for(var/atom/movable/movable as anything in moving_movs)
		movable.currently_z_moving = currently_z_moving || CURRENTLY_Z_MOVING_GENERIC
		movable.forceMove(target)
		movable.set_currently_z_moving(FALSE, TRUE)
	// This is run after ALL movables have been moved, so pulls don't get broken unless they are actually out of range.
	if(z_move_flags & ZMOVE_CHECK_PULLS)
		for(var/atom/movable/moved_mov as anything in moving_movs)
			if(z_move_flags & ZMOVE_CHECK_PULLEDBY && moved_mov.pulledby && (moved_mov.z != moved_mov.pulledby.z || get_dist(moved_mov, moved_mov.pulledby) > 1))
				moved_mov.pulledby.stop_pulling()
			if(z_move_flags & ZMOVE_CHECK_PULLING)
				moved_mov.check_pulling(TRUE)
	return TRUE

/// Returns a list of movables that should also be affected when src moves through zlevels, and src.
/atom/movable/proc/get_z_move_affected(z_move_flags)
	. = list(src)
	if(buckled_mobs)
		. |= buckled_mobs
	if(!(z_move_flags & ZMOVE_INCLUDE_PULLED))
		return
	for(var/mob/living/buckled as anything in buckled_mobs)
		if(buckled.pulling)
			. |= buckled.pulling
	if(pulling)
		. |= pulling
		if (pulling.buckled_mobs)
			. |= pulling.buckled_mobs

		//makes conga lines work with ladders and flying up and down; checks if the guy you are pulling is pulling someone,
		//then uses recursion to run the same function again
		if (pulling.pulling)
			. |= pulling.pulling.get_z_move_affected(z_move_flags)

/**
 * Checks if the destination turf is elegible for z movement from the start turf to a given direction and returns it if so.
 * Args:
 * * direction: the direction to go, UP or DOWN, only relevant if target is null.
 * * start: Each destination has a starting point on the other end. This is it. Most of the times the location of the source.
 * * z_move_flags: bitflags used for various checks. See __DEFINES/movement.dm.
 * * rider: A living mob in control of the movable. Only non-null when a mob is riding a vehicle through z-levels.
 */
/atom/movable/proc/can_z_move(direction, turf/start, turf/destination, z_move_flags = ZMOVE_FLIGHT_FLAGS, mob/living/rider)
	if(!start)
		start = get_turf(src)
		if(!start)
			return FALSE
	if(!direction)
		if(!destination)
			return FALSE
		direction = get_dir_multiz(start, destination)
	if(direction != UP && direction != DOWN)
		return FALSE
	if(!destination)
		destination = get_step_multiz(start, direction)
		if(!destination)
			if(z_move_flags & ZMOVE_FEEDBACK)
				to_chat(rider || src, span_warning("There's nowhere to go in that direction!"))
			return FALSE
	if(SEND_SIGNAL(src, COMSIG_CAN_Z_MOVE, start, destination) & COMPONENT_CANT_Z_MOVE)
		return FALSE
	if(z_move_flags & ZMOVE_FALL_CHECKS && (throwing || (movement_type & (FLYING|FLOATING)) || !has_gravity(start)))
		return FALSE
	if(z_move_flags & ZMOVE_CAN_FLY_CHECKS && !(movement_type & (FLYING|FLOATING)) && has_gravity(start))
		if(z_move_flags & ZMOVE_FEEDBACK)
			if(rider)
				to_chat(rider, span_warning("[src] [p_are()] incapable of flight."))
			else
				to_chat(src, span_warning("You are not Superman."))
		return FALSE
	if((!(z_move_flags & ZMOVE_IGNORE_OBSTACLES) && !(start.zPassOut(direction) && destination.zPassIn(direction))) || (!(z_move_flags & ZMOVE_ALLOW_ANCHORED) && anchored))
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(rider || src, span_warning("You can't move there!"))
		return FALSE
	return destination //used by some child types checks and zMove()

/atom/movable/vv_edit_var(var_name, var_value)
	var/static/list/banned_edits = list(NAMEOF_STATIC(src, step_x) = TRUE, NAMEOF_STATIC(src, step_y) = TRUE, NAMEOF_STATIC(src, step_size) = TRUE, NAMEOF_STATIC(src, bounds) = TRUE)
	var/static/list/careful_edits = list(NAMEOF_STATIC(src, bound_x) = TRUE, NAMEOF_STATIC(src, bound_y) = TRUE, NAMEOF_STATIC(src, bound_width) = TRUE, NAMEOF_STATIC(src, bound_height) = TRUE)
	var/static/list/not_falsey_edits = list(NAMEOF_STATIC(src, bound_width) = TRUE, NAMEOF_STATIC(src, bound_height) = TRUE)
	if(banned_edits[var_name])
		return FALSE //PLEASE no.
	if(careful_edits[var_name] && (var_value % ICON_SIZE_ALL) != 0)
		return FALSE
	if(not_falsey_edits[var_name] && !var_value)
		return FALSE

	switch(var_name)
		if(NAMEOF(src, x))
			var/turf/current_turf = locate(var_value, y, z)
			if(current_turf)
				admin_teleport(current_turf)
				return TRUE
			return FALSE
		if(NAMEOF(src, y))
			var/turf/T = locate(x, var_value, z)
			if(T)
				admin_teleport(T)
				return TRUE
			return FALSE
		if(NAMEOF(src, z))
			var/turf/T = locate(x, y, var_value)
			if(T)
				admin_teleport(T)
				return TRUE
			return FALSE
		if(NAMEOF(src, loc))
			if(isatom(var_value) || isnull(var_value))
				admin_teleport(var_value)
				return TRUE
			return FALSE
		if(NAMEOF(src, anchored))
			set_anchored(var_value)
			. = TRUE
		if(NAMEOF(src, pulledby))
			set_pulledby(var_value)
			. = TRUE
		if(NAMEOF(src, glide_size))
			set_glide_size(var_value)
			. = TRUE

	if(!isnull(.))
		datum_flags |= DF_VAR_EDITED
		return

	return ..()

/atom/movable/proc/start_pulling(atom/movable/pulled_atom, state, force = move_force, supress_message = FALSE)
	if(QDELETED(pulled_atom))
		return FALSE
	if(!(pulled_atom.can_be_pulled(src, force)))
		return FALSE

	// If we're pulling something then drop what we're currently pulling and pull this instead.
	if(pulling)
		if(state == 0)
			stop_pulling()
			return FALSE
		// Are we trying to pull something we are already pulling? Then enter grab cycle and end.
		if(pulled_atom == pulling)
			setGrabState(state)
			if(istype(pulled_atom,/mob/living))
				var/mob/living/pulled_mob = pulled_atom
				pulled_mob.grabbedby(src)
			return TRUE
		stop_pulling()

	if(pulled_atom.pulledby)
		log_combat(pulled_atom, pulled_atom.pulledby, "pulled from", src)
		pulled_atom.pulledby.stop_pulling() //an object can't be pulled by two mobs at once.
	pulling = pulled_atom
	pulled_atom.set_pulledby(src)
	SEND_SIGNAL(src, COMSIG_ATOM_START_PULL, pulled_atom, state, force)
	setGrabState(state)
	if(ismob(pulled_atom))
		var/mob/pulled_mob = pulled_atom
		log_combat(src, pulled_mob, "grabbed", addition="passive grab")
		if(!supress_message)
			pulled_mob.visible_message(span_warning("[src] grabs [pulled_mob] passively."), \
				span_danger("[src] grabs you passively."))
	return TRUE

/atom/movable/proc/stop_pulling()
	if(!pulling)
		return
	pulling.set_pulledby(null)
	setGrabState(GRAB_PASSIVE)
	var/atom/movable/old_pulling = pulling
	pulling = null
	SEND_SIGNAL(old_pulling, COMSIG_ATOM_NO_LONGER_PULLED, src)
	SEND_SIGNAL(src, COMSIG_ATOM_NO_LONGER_PULLING, old_pulling)

///Reports the event of the change in value of the pulledby variable.
/atom/movable/proc/set_pulledby(new_pulledby)
	if(new_pulledby == pulledby)
		return FALSE //null signals there was a change, be sure to return FALSE if none happened here.
	. = pulledby
	pulledby = new_pulledby


/atom/movable/proc/Move_Pulled(atom/moving_atom)
	if(!pulling)
		return FALSE
	if(pulling.anchored || pulling.move_resist > move_force || !pulling.Adjacent(src, src, pulling))
		stop_pulling()
		return FALSE
	if(isliving(pulling))
		var/mob/living/pulling_mob = pulling
		if(pulling_mob.buckled && pulling_mob.buckled.buckle_prevents_pull) //if they're buckled to something that disallows pulling, prevent it
			stop_pulling()
			return FALSE
	if(get_turf(moving_atom) == loc && pulling.density)
		return FALSE
	var/move_dir = get_dir(pulling.loc, moving_atom)
	if(!Process_Spacemove(move_dir))
		return FALSE
	pulling.Move(get_step(pulling.loc, move_dir), move_dir, glide_size)
	return TRUE

/mob/living/Move_Pulled(atom/moving_atom)
	. = ..()
	if(!. || !isliving(moving_atom))
		return
	var/mob/living/pulled_mob = moving_atom
	set_pull_offsets(pulled_mob, grab_state, animate = FALSE)

/**
 * Checks if the pulling and pulledby should be stopped because they're out of reach.
 * If z_allowed is TRUE, the z level of the pulling will be ignored.This is to allow things to be dragged up and down stairs.
 */
/atom/movable/proc/check_pulling(only_pulling = FALSE, z_allowed = FALSE)
	if(pulling)
		if(get_dist(src, pulling) > 1 || (z != pulling.z && !z_allowed))
			stop_pulling()
		else if(!isturf(loc))
			stop_pulling()
		else if(pulling && !isturf(pulling.loc) && pulling.loc != loc) //to be removed once all code that changes an object's loc uses forceMove().
			log_game("DEBUG:[src]'s pull on [pulling] wasn't broken despite [pulling] being in [pulling.loc]. Pull stopped manually.")
			stop_pulling()
		else if(pulling.anchored || pulling.move_resist > move_force)
			stop_pulling()
	if(!only_pulling && pulledby && moving_diagonally != FIRST_DIAG_STEP && (get_dist(src, pulledby) > 1 || (z != pulledby.z && !z_allowed))) //separated from our puller and not in the middle of a diagonal move.
		pulledby.stop_pulling()

/atom/movable/proc/set_glide_size(target = 8)
	if (HAS_TRAIT(src, TRAIT_NO_GLIDE))
		return
	SEND_SIGNAL(src, COMSIG_MOVABLE_UPDATE_GLIDE_SIZE, target)
	glide_size = target

	//for(var/mob/buckled_mob as anything in buckled_mobs)
	//	buckled_mob.set_glide_size(target)

/**
 * meant for movement with zero side effects. only use for objects that are supposed to move "invisibly" (like eye mobs or ghosts)
 * if you want something to move onto a tile with a beartrap or recycler or tripmine or mouse without that object knowing about it at all, use this
 * most of the time you want forceMove()
 */
/atom/movable/proc/abstract_move(atom/new_loc)
	RESOLVE_ACTIVE_MOVEMENT // This should NEVER happen, but, just in case...
	var/atom/old_loc = loc
	var/direction = get_dir(old_loc, new_loc)
	loc = new_loc
	Moved(old_loc, direction, TRUE, momentum_change = FALSE)

////////////////////////////////////////
// Here's where we rewrite how byond handles movement except slightly different
// To be removed on step_ conversion
// All this work to prevent a second bump
/atom/movable/Move(atom/newloc, direction, glide_size_override = 0, update_dir = TRUE)
	. = FALSE
	if(!newloc || newloc == loc)
		return
	SEND_SIGNAL(src, COMSIG_MOVABLE_ATTEMPTED_MOVE, newloc, direction)
	// A mid-movement... movement... occurred, resolve that first.
	RESOLVE_ACTIVE_MOVEMENT

	if(!direction)
		direction = get_dir(src, newloc)

	if(set_dir_on_move && dir != direction && update_dir)
		setDir(direction)

	var/is_multi_tile_object = is_multi_tile_object(src)

	var/list/old_locs
	if(is_multi_tile_object && isturf(loc))
		old_locs = locs // locs is a special list, this is effectively the same as .Copy() but with less steps
		for(var/atom/exiting_loc as anything in old_locs)
			if(!exiting_loc.Exit(src, direction))
				return
	else
		if(!loc.Exit(src, direction))
			return

	var/list/new_locs
	if(is_multi_tile_object && isturf(newloc))
		var/dx = newloc.x
		var/dy = newloc.y
		var/dz = newloc.z
		new_locs = block(
			dx, dy, dz,
			dx + ceil(bound_width / 32), dy + ceil(bound_height / 32), dz
		) // If this is a multi-tile object then we need to predict the new locs and check if they allow our entrance.
		for(var/atom/entering_loc as anything in new_locs)
			if(!entering_loc.Enter(src))
				return
			if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, entering_loc) & COMPONENT_MOVABLE_BLOCK_PRE_MOVE)
				return
	else // Else just try to enter the single destination.
		if(!newloc.Enter(src))
			return
		if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, newloc) & COMPONENT_MOVABLE_BLOCK_PRE_MOVE)
			return

	// Past this is the point of no return
	var/atom/oldloc = loc
	var/area/oldarea = get_area(oldloc)
	var/area/newarea = get_area(newloc)

	SET_ACTIVE_MOVEMENT(oldloc, direction, FALSE, old_locs)
	loc = newloc

	. = TRUE

	if(old_locs) // This condition will only be true if it is a multi-tile object.
		for(var/atom/exited_loc as anything in (old_locs - new_locs))
			exited_loc.Exited(src, direction)
	else // Else there's just one loc to be exited.
		oldloc.Exited(src, direction)
	if(oldarea != newarea)
		oldarea.Exited(src, direction)

	if(new_locs) // Same here, only if multi-tile.
		for(var/atom/entered_loc as anything in (new_locs - old_locs))
			entered_loc.Entered(src, oldloc, old_locs)
	else
		newloc.Entered(src, oldloc, old_locs)
	if(oldarea != newarea)
		newarea.Entered(src, oldarea)

	RESOLVE_ACTIVE_MOVEMENT

////////////////////////////////////////

/atom/movable/Move(atom/newloc, direct, glide_size_override = 0, update_dir = TRUE)
	var/atom/movable/pullee = pulling
	var/turf/current_turf = loc
	if(!moving_from_pull)
		check_pulling(z_allowed = TRUE)
	if(!loc || !newloc)
		return FALSE
	var/atom/oldloc = loc
	//Early override for some cases like diagonal movement
	if(glide_size_override && glide_size != glide_size_override)
		set_glide_size(glide_size_override)

	if(loc != newloc)
		if (!(direct & (direct - 1))) //Cardinal move
			. = ..()
		else //Diagonal move, split it into cardinal moves
			moving_diagonally = FIRST_DIAG_STEP
			var/first_step_dir
			// The `&& moving_diagonally` checks are so that a forceMove taking
			// place due to a Crossed, Bumped, etc. call will interrupt
			// the second half of the diagonal movement, or the second attempt
			// at a first half if step() fails because we hit something.
			if (direct & NORTH)
				if (direct & EAST)
					if (step(src, NORTH) && moving_diagonally)
						first_step_dir = NORTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, EAST)
					else if (moving_diagonally && step(src, EAST))
						first_step_dir = EAST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, NORTH)
				else if (direct & WEST)
					if (step(src, NORTH) && moving_diagonally)
						first_step_dir = NORTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, WEST)
					else if (moving_diagonally && step(src, WEST))
						first_step_dir = WEST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, NORTH)
			else if (direct & SOUTH)
				if (direct & EAST)
					if (step(src, SOUTH) && moving_diagonally)
						first_step_dir = SOUTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, EAST)
					else if (moving_diagonally && step(src, EAST))
						first_step_dir = EAST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, SOUTH)
				else if (direct & WEST)
					if (step(src, SOUTH) && moving_diagonally)
						first_step_dir = SOUTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, WEST)
					else if (moving_diagonally && step(src, WEST))
						first_step_dir = WEST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, SOUTH)
			if(moving_diagonally == SECOND_DIAG_STEP)
				if(!. && set_dir_on_move && update_dir)
					setDir(first_step_dir)
				else if(!inertia_moving)
					newtonian_move(dir2angle(direct))
				//if(client_mobs_in_contents)
					//update_parallax_contents()
			moving_diagonally = 0
			return

	if(!loc || (loc == oldloc && oldloc != newloc))
		last_move = 0
		set_currently_z_moving(FALSE, TRUE)
		return

	if(. && pulling && pulling == pullee && pulling != moving_from_pull) //we were pulling a thing and didn't lose it during our move.
		if(pulling.anchored)
			stop_pulling()
		else
			//puller and pullee more than one tile away or in diagonal position and whatever the pullee is pulling isn't already moving from a pull as it'll most likely result in an infinite loop a la ouroborus.
			if(!pulling.pulling?.moving_from_pull)
				var/pull_dir = get_dir(pulling, src)
				var/target_turf = current_turf

				// Pulling things down/up stairs. zMove() has flags for check_pulling and stop_pulling calls.
				// You may wonder why we're not just forcemoving the pulling movable and regrabbing it.
				// The answer is simple. forcemoving and regrabbing is ugly and breaks conga lines.
				if(pulling.z != z)
					target_turf = get_step(pulling, get_dir(pulling, current_turf))

				if(target_turf != current_turf || (moving_diagonally != SECOND_DIAG_STEP && ISDIAGONALDIR(pull_dir)) || get_dist(src, pulling) > 1)
					pulling.move_from_pull(src, target_turf, glide_size)
			if (pulledby)
				if (pulledby.currently_z_moving)
					check_pulling(z_allowed = TRUE)
				//don't call check_pulling() here at all if there is a pulledby that is not currently z moving
				//because it breaks stair conga lines, for some fucking reason.
				//it's fine because the pull will be checked when this whole proc is called by the mob doing the pulling anyways
			else
				check_pulling()

	//glide_size strangely enough can change mid movement animation and update correctly while the animation is playing
	//This means that if you don't override it late like this, it will just be set back by the movement update that's called when you move turfs.
	if(glide_size_override)
		set_glide_size(glide_size_override)

	last_move = direct

	if(set_dir_on_move && dir != direct && update_dir)
		setDir(direct)

	if(currently_z_moving)
		if(. && loc == newloc)
			var/turf/pitfall = get_turf(src)
			pitfall.zFall(src, falling_from_move = TRUE)
		else
			set_currently_z_moving(FALSE, TRUE)

/// Called when src is being moved to a target turf because another movable (puller) is moving around.
/atom/movable/proc/move_from_pull(atom/movable/puller, turf/target_turf, glide_size_override)
	moving_from_pull = puller
	Move(target_turf, get_dir(src, target_turf), glide_size_override)
	moving_from_pull = null

/**
 * Called after a successful Move(). By this point, we've already moved.
 * Arguments:
 * * old_loc is the location prior to the move. Can be null to indicate nullspace.
 * * movement_dir is the direction the movement took place. Can be NONE if it was some sort of teleport.
 * * The forced flag indicates whether this was a forced move, which skips many checks of regular movement.
 * * The old_locs is an optional argument, in case the moved movable was present in multiple locations before the movement.
 * * momentum_change represents whether this movement is due to a "new" force if TRUE or an already "existing" force if FALSE
 **/
/atom/movable/proc/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	SHOULD_CALL_PARENT(TRUE)

	if (!moving_diagonally && !inertia_moving && momentum_change && movement_dir)
		newtonian_move(dir2angle(movement_dir))
	// If we ain't moving diagonally right now, update our parallax
	// We don't do this all the time because diag movements should trigger one call to this, not two
	// Waste of cpu time, and it fucks the animate
	//if (!moving_diagonally && client_mobs_in_contents)
	//	update_parallax_contents()

	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old_loc, movement_dir, forced, old_locs, momentum_change)

	if(old_loc)
		SEND_SIGNAL(old_loc, COMSIG_ATOM_ABSTRACT_EXITED, src, movement_dir)
	if(loc)
		SEND_SIGNAL(loc, COMSIG_ATOM_ABSTRACT_ENTERED, src, old_loc, old_locs)

	var/turf/old_turf = get_turf(old_loc)
	var/turf/new_turf = get_turf(src)

	/* We dont have SSspatial yet
	if(HAS_SPATIAL_GRID_CONTENTS(src))
		if(old_turf && new_turf && (old_turf.z != new_turf.z \
			|| GET_SPATIAL_INDEX(old_turf.x) != GET_SPATIAL_INDEX(new_turf.x) \
			|| GET_SPATIAL_INDEX(old_turf.y) != GET_SPATIAL_INDEX(new_turf.y)))

			SSspatial_grid.exit_cell(src, old_turf)
			SSspatial_grid.enter_cell(src, new_turf)

		else if(old_turf && !new_turf)
			SSspatial_grid.exit_cell(src, old_turf)

		else if(new_turf && !old_turf)
			SSspatial_grid.enter_cell(src, new_turf)
	*/

	// Handle any buckled mobs on this movable
	if(has_buckled_mobs())
		handle_buckled_mob_movement(old_loc, movement_dir, movetime)
	if(riding_datum)
		riding_datum.handle_vehicle_layer()
		riding_datum.handle_vehicle_offsets()
	for (var/datum/light_source/light as anything in light_sources) // Cycle through the light sources on this atom and tell them to update.
		light.source_atom.update_light()

	return TRUE

/mob/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	//If we return focus to our own mob, but we are still inside something with an inherent remote view. Restart it.
	if(client)
		restore_remote_views()

/atom/movable/setDir(newdir)
	. = ..(newdir)
	if(riding_datum)
		riding_datum.handle_vehicle_offsets()

/atom/movable/relaymove(mob/user, direction)
	. = ..()
	if(riding_datum)
		riding_datum.handle_ride(user, direction)

// Make sure you know what you're doing if you call this
// You probably want CanPass()
///atom/movable/Cross(atom/movable/crossed_atom)
//	if(SEND_SIGNAL(src, COMSIG_MOVABLE_CROSS, crossed_atom) & COMPONENT_BLOCK_CROSS)
//		return FALSE
//	if(SEND_SIGNAL(crossed_atom, COMSIG_MOVABLE_CROSS_OVER, src) & COMPONENT_BLOCK_CROSS)
//		return FALSE
//	return CanPass(crossed_atom, get_dir(src, crossed_atom))

///default byond proc that is deprecated for us in lieu of signals. do not call
///atom/movable/Crossed(atom/movable/crossed_atom, oldloc)
//	SHOULD_NOT_OVERRIDE(TRUE)
//	CRASH("atom/movable/Crossed() was called!")

/**
 * `Uncross()` is a default BYOND proc that is called when something is *going*
 * to exit this atom's turf. It is prefered over `Uncrossed` when you want to
 * deny that movement, such as in the case of border objects, objects that allow
 * you to walk through them in any direction except the one they block
 * (think side windows).
 *
 * While being seemingly harmless, most everything doesn't actually want to
 * use this, meaning that we are wasting proc calls for every single atom
 * on a turf, every single time something exits it, when basically nothing
 * cares.
 *
 * This overhead caused real problems on Sybil round #159709, where lag
 * attributed to Uncross was so bad that the entire master controller
 * collapsed and people made Among Us lobbies in OOC.
 *
 * If you want to replicate the old `Uncross()` behavior, the most apt
 * replacement is [`/datum/element/connect_loc`] while hooking onto
 * [`COMSIG_ATOM_EXIT`].
 */
///atom/movable/Uncross()
//	SHOULD_NOT_OVERRIDE(TRUE)
//	CRASH("Uncross() should not be being called, please read the doc-comment for it for why.")

/**
 * default byond proc that is normally called on everything inside the previous turf
 * a movable was in after moving to its current turf
 * this is wasteful since the vast majority of objects do not use Uncrossed
 * use connect_loc to register to COMSIG_ATOM_EXITED instead
 */
///atom/movable/Uncrossed(atom/movable/uncrossed_atom)
//	SHOULD_NOT_OVERRIDE(TRUE)
//	CRASH("/atom/movable/Uncrossed() was called")

/atom/movable/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(locs && locs.len >= 2)	// If something is standing on top of us, let them pass.
		if(mover.loc in locs)
			. = TRUE
	return .

/atom/movable/Bump(atom/A)
	if(!A)
		CRASH("Bump was called with no argument.")
	. = ..()
	if(throwing)
		throw_impact(A)
		throwing = 0
		if(QDELETED(A))
			return

	SEND_SIGNAL(src, COMSIG_MOVABLE_BUMP, A)

	A.Bumped(src)
	A.last_bumped = world.time

///Sets the anchored var and returns if it was successfully changed or not.
/atom/movable/proc/set_anchored(anchorvalue)
	SHOULD_CALL_PARENT(TRUE)
	if(anchored == anchorvalue)
		return
	. = anchored
	anchored = anchorvalue
	if(anchored && pulledby)
		pulledby.stop_pulling()
	SEND_SIGNAL(src, COMSIG_MOVABLE_SET_ANCHORED, anchorvalue)

/// Sets the currently_z_moving variable to a new value. Used to allow some zMovement sources to have precedence over others.
/atom/movable/proc/set_currently_z_moving(new_z_moving_value, forced = FALSE)
	if(forced)
		currently_z_moving = new_z_moving_value
		return TRUE
	var/old_z_moving_value = currently_z_moving
	currently_z_moving = max(currently_z_moving, new_z_moving_value)
	return currently_z_moving > old_z_moving_value

/atom/movable/proc/forceMove(atom/destination)
	. = FALSE
	if(destination)
		. = doMove(destination)
	else
		CRASH("No valid destination passed into forceMove")

/atom/movable/proc/moveToNullspace()
	return doMove(null)

/atom/movable/proc/doMove(atom/destination)
	. = FALSE
	RESOLVE_ACTIVE_MOVEMENT

	var/atom/oldloc = loc
	var/is_multi_tile = bound_width > ICON_SIZE_X || bound_height > ICON_SIZE_Y

	SET_ACTIVE_MOVEMENT(oldloc, NONE, TRUE, null)

	if(destination)
		///zMove already handles whether a pull from another movable should be broken.
		if(pulledby && !currently_z_moving)
			pulledby.stop_pulling()

		var/same_loc = oldloc == destination
		var/area/old_area = get_area(oldloc)
		var/area/destarea = get_area(destination)
		var/movement_dir = get_dir(src, destination)

		moving_diagonally = 0

		loc = destination

		if(!same_loc)
			if(loc == oldloc)
				// when attempting to move an atom A into an atom B which already contains A, BYOND seems
				// to silently refuse to move A to the new loc. This can really break stuff (see #77067)
				stack_trace("Attempt to move [src] to [destination] was rejected by BYOND, possibly due to cyclic contents")
				return FALSE

			if(is_multi_tile && isturf(destination))
				var/dx = destination.x
				var/dy = destination.y
				var/dz = destination.z
				var/list/new_locs = block(
					dx, dy, dz,
					dx + ROUND_UP(bound_width / ICON_SIZE_X), dy + ROUND_UP(bound_height / ICON_SIZE_Y), dz
				)
				if(old_area && old_area != destarea)
					old_area.Exited(src, movement_dir)
				for(var/atom/left_loc as anything in locs - new_locs)
					left_loc.Exited(src, movement_dir)

				for(var/atom/entering_loc as anything in new_locs - locs)
					entering_loc.Entered(src, movement_dir)

				if(old_area && old_area != destarea)
					destarea.Entered(src, movement_dir)
			else
				if(oldloc)
					oldloc.Exited(src, movement_dir)
					if(old_area && old_area != destarea)
						old_area.Exited(src, movement_dir)
				destination.Entered(src, oldloc)
				if(destarea && old_area != destarea)
					destarea.Entered(src, old_area)

		. = TRUE

	//If no destination, move the atom into nullspace (don't do this unless you know what you're doing)
	else
		. = TRUE

		if (oldloc)
			loc = null
			var/area/old_area = get_area(oldloc)
			if(is_multi_tile && isturf(oldloc))
				for(var/atom/old_loc as anything in locs)
					old_loc.Exited(src, NONE)
			else
				oldloc.Exited(src, NONE)

			if(old_area)
				old_area.Exited(src, NONE)

	RESOLVE_ACTIVE_MOVEMENT

/**
 * Called when a movable changes z-levels.
 *
 * Arguments:
 * * old_turf - The previous turf they were on before.
 * * new_turf - The turf they have now entered.
 * * same_z_layer - If their old and new z levels are on the same level of plane offsets or not
 * * notify_contents - Whether or not to notify the movable's contents that their z-level has changed. NOTE, IF YOU SET THIS, YOU NEED TO MANUALLY SET PLANE OF THE CONTENTS LATER
 */
/atom/movable/proc/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_MOVABLE_Z_CHANGED, old_turf, new_turf, same_z_layer)
	SEND_SIGNAL(src, COMSIG_OBSERVER_Z_MOVED, old_turf, new_turf) // is it placed somewhere else?

	if(!notify_contents)
		return

	for (var/atom/movable/content as anything in src) // Notify contents of Z-transition.
		content.on_changed_z_level(old_turf, new_turf, same_z_layer)

/**
 * Called whenever an object moves and by mobs when they attempt to move themselves through space
 * And when an object or action applies a force on src, see [newtonian_move][/atom/movable/proc/newtonian_move]
 *
 * Return FALSE to have src start/keep drifting in a no-grav area and TRUE to stop/not start drifting
 *
 * Mobs should return 1 if they should be able to move of their own volition, see [/client/proc/Move]
 *
 * Arguments:
 * * movement_dir - 0 when stopping or any dir when trying to move
 * * continuous_move - If this check is coming from something in the context of already drifting
 */
/atom/movable/proc/Process_Spacemove(movement_dir = 0, continuous_move = FALSE)
	if(has_gravity())
		return TRUE

	if(SEND_SIGNAL(src, COMSIG_MOVABLE_SPACEMOVE, movement_dir, continuous_move) & COMSIG_MOVABLE_STOP_SPACEMOVE)
		return TRUE

	if(pulledby && (pulledby.pulledby != src || moving_from_pull))
		return TRUE

	if(throwing)
		return TRUE

	if(!isturf(loc))
		return TRUE

	if (handle_spacemove_grabbing())
		return TRUE

	return FALSE

/// Only moves the object if it's under no gravity
/// Accepts the direction to move, if the push should be instant, and an optional parameter to fine tune the start delay
/// Drift force determines how much acceleration should be applied. Controlled cap, if set, will ensure that if the object was moving slower than the cap before, it cannot accelerate past the cap from this move.
/atom/movable/proc/newtonian_move(inertia_angle, instant = FALSE, start_delay = 0, drift_force = 1 NEWTONS, controlled_cap = null, force_loop = TRUE)
	if(!isturf(loc) || Process_Spacemove(angle2dir(inertia_angle), continuous_move = TRUE))
		return FALSE

	if (!isnull(drift_handler))
		if (drift_handler.newtonian_impulse(inertia_angle, start_delay, drift_force, controlled_cap, force_loop))
			return TRUE

	new /datum/drift_handler(src, inertia_angle, instant, start_delay, drift_force)
	// Something went wrong and it failed to create itself, most likely we have a higher priority loop already
	if (QDELETED(drift_handler))
		return FALSE
	return TRUE

//called when src is thrown into hit_atom
/atom/movable/proc/throw_impact(atom/hit_atom, var/speed)
	if(isliving(hit_atom))
		var/mob/living/M = hit_atom
		if(M.buckled == src)
			return // Don't hit the thing we're buckled to.
		M.hitby(src,speed)

	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, src.last_move)
		O.hitby(src,speed)

	else if(isturf(hit_atom))
		src.throwing = 0
		var/turf/T = hit_atom
		T.hitby(src,speed)

//decided whether a movable atom being thrown can pass through the turf it is in.
/atom/movable/proc/hit_check(var/speed)
	if(src.throwing)
		for(var/atom/A in get_turf(src))
			if(A == src)
				continue
			if(A.is_incorporeal())
				continue
			if(isliving(A))
				var/mob/living/M = A
				if(M.lying)
					continue
				src.throw_impact(A,speed)
			if(isobj(A))
				if(!A.density || A.throwpass)
					continue
				// Special handling of windows, which are dense but block only from some directions
				if(istype(A, /obj/structure/window))
					var/obj/structure/window/W = A
					if (!W.is_fulltile() && !(turn(src.last_move, 180) & A.dir))
						continue
				// Same thing for (closed) windoors, which have the same problem
				else if(istype(A, /obj/machinery/door/window) && !(turn(src.last_move, 180) & A.dir))
					continue
				src.throw_impact(A,speed)

/atom/movable/proc/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, datum/callback/callback) //If this returns FALSE then callback will not be called.
	. = TRUE
	if (!target || speed <= 0 || QDELETED(src) || (target.z != src.z))
		return FALSE

	if (pulledby)
		pulledby.stop_pulling()

	var/datum/thrownthing/TT = new(src, target, range, speed, thrower, callback)
	throwing = TT

	pixel_z = 0
	if(spin && does_spin)
		SpinAnimation(4,1)

	SSthrowing.processing[src] = TT
	if (SSthrowing.state == SS_PAUSED && length(SSthrowing.currentrun))
		SSthrowing.currentrun[src] = TT

//Overlays
/atom/movable/overlay
	var/atom/master = null
	anchored = TRUE

/atom/movable/overlay/Initialize(mapload)
	. = ..()
	for(var/x in src.verbs)
		src.verbs -= x

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
	return

/atom/movable/proc/touch_map_edge()
	if(z in using_map.sealed_levels)
		return

	if(using_map.use_overmap)
		overmap_spacetravel(get_turf(src), src)
		return

	var/move_to_z = src.get_transit_zlevel()
	if(move_to_z)
		var/new_z = move_to_z
		var/new_x
		var/new_y

		if(x <= TRANSITIONEDGE)
			new_x = world.maxx - TRANSITIONEDGE - 2
			new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (x >= (world.maxx - TRANSITIONEDGE + 1))
			new_x = TRANSITIONEDGE + 1
			new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (y <= TRANSITIONEDGE)
			new_y = world.maxy - TRANSITIONEDGE -2
			new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		else if (y >= (world.maxy - TRANSITIONEDGE + 1))
			new_y = TRANSITIONEDGE + 1
			new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		if(SSticker && istype(SSticker.mode, /datum/game_mode/nuclear)) //only really care if the game mode is nuclear
			var/datum/game_mode/nuclear/G = SSticker.mode
			G.check_nuke_disks()

		var/turf/T = locate(new_x, new_y, new_z)
		if(istype(T))
			forceMove(T)

//by default, transition randomly to another zlevel
/atom/movable/proc/get_transit_zlevel()
	var/list/candidates = using_map.accessible_z_levels.Copy()
	candidates.Remove("[src.z]")

	if(!candidates.len)
		return null
	return text2num(pickweight(candidates))

// Returns the current scaling of the sprite.
// Note this DOES NOT measure the height or width of the icon, but returns what number is being multiplied with to scale the icons, if any.
/atom/movable/proc/get_icon_scale_x()
	return icon_scale_x

/atom/movable/proc/get_icon_scale_y()
	return icon_scale_y

/atom/movable/proc/update_transform()
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	M.Turn(icon_rotation)
	src.transform = M

// Use this to set the object's scale.
/atom/movable/proc/adjust_scale(new_scale_x, new_scale_y)
	if(isnull(new_scale_y))
		new_scale_y = new_scale_x
	if(new_scale_x != 0)
		icon_scale_x = new_scale_x
	if(new_scale_y != 0)
		icon_scale_y = new_scale_y
	update_transform()

/atom/movable/proc/adjust_rotation(new_rotation)
	icon_rotation = new_rotation
	update_transform()

// Called when touching a lava tile.
/atom/movable/proc/lava_act()
	fire_act(null, 10000, 1000)


// Procs to cloak/uncloak
/atom/movable/proc/cloak()
	if(cloaked)
		return FALSE
	cloaked = TRUE
	. = TRUE // We did work

	var/static/animation_time = 1 SECOND
	cloaked_selfimage = get_cloaked_selfimage()

	//Wheeee
	cloak_animation(animation_time)

	//Needs to be last so people can actually see the effect before we become invisible
	if(cloaked) // Ensure we are still cloaked after the animation delay
		plane = CLOAKED_PLANE

/atom/movable/proc/uncloak()
	if(!cloaked)
		return FALSE
	cloaked = FALSE
	. = TRUE // We did work

	var/static/animation_time = 1 SECOND
	QDEL_NULL(cloaked_selfimage)

	//Needs to be first so people can actually see the effect, so become uninvisible first
	plane = initial(plane)

	//Oooooo
	uncloak_animation(animation_time)


// Animations for cloaking/uncloaking
/atom/movable/proc/cloak_animation(var/length = 1 SECOND)
	//Save these
	var/initial_alpha = alpha

	//Animate alpha fade
	animate(src, alpha = 0, time = length)

	//Animate a cloaking effect
	var/our_filter = filters.len+1 //Filters don't appear to have a type that can be stored in a var and accessed. This is how the DM reference does it.
	filters += filter(type="wave", x = 0, y = 16, size = 0, offset = 0, flags = WAVE_SIDEWAYS)
	animate(filters[our_filter], offset = 1, size = 8, time = length, flags = ANIMATION_PARALLEL)

	//Wait for animations to finish
	sleep(length+5)

	//Remove those
	filters -= filter(type="wave", x = 0, y = 16, size = 8, offset = 1, flags = WAVE_SIDEWAYS)

	//Back to original alpha
	alpha = initial_alpha

/atom/movable/proc/uncloak_animation(var/length = 1 SECOND)
	//Save these
	var/initial_alpha = alpha

	//Put us back to normal, but no alpha
	alpha = 0

	//Animate alpha fade up
	animate(src, alpha = initial_alpha, time = length)

	//Animate a cloaking effect
	var/our_filter = filters.len+1 //Filters don't appear to have a type that can be stored in a var and accessed. This is how the DM reference does it.
	filters += filter(type="wave", x=0, y = 16, size = 8, offset = 1, flags = WAVE_SIDEWAYS)
	animate(filters[our_filter], offset = 0, size = 0, time = length, flags = ANIMATION_PARALLEL)

	//Wait for animations to finish
	sleep(length+5)

	//Remove those
	filters -= filter(type="wave", x=0, y = 16, size = 0, offset = 0, flags = WAVE_SIDEWAYS)


// So cloaked things can see themselves, if necessary
/atom/movable/proc/get_cloaked_selfimage()
	var/icon/selficon = icon(icon, icon_state)
	selficon.MapColors(0,0,0, 0,0,0, 0,0,0, 1,1,1) //White
	var/image/selfimage = image(selficon)
	selfimage.color = "#0000FF"
	selfimage.alpha = 100
	selfimage.layer = initial(layer)
	selfimage.plane = initial(plane)
	selfimage.loc = src

	return selfimage

/atom/movable/proc/get_cell()
	return

/atom/movable/proc/emblocker_gc(var/datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_QDELETING)
	cut_overlay(source)
	if(em_block == source)
		em_block = null

// Helper procs called on entering/exiting a belly. Does nothing by default, override on children for special behavior.
/atom/movable/proc/enter_belly(obj/belly/B)
	return

/atom/movable/proc/exit_belly(obj/belly/B)
	return

/atom/movable/proc/set_listening(var/set_to)
	if (listening_recursive && !set_to)
		LAZYREMOVE(recursive_listeners, src)
		if (!LAZYLEN(recursive_listeners))
			for (var/atom/movable/location as anything in get_nested_locs(src))
				LAZYREMOVE(location.recursive_listeners, src)
	if (!listening_recursive && set_to)
		LAZYOR(recursive_listeners, src)
		for (var/atom/movable/location as anything in get_nested_locs(src))
			LAZYOR(location.recursive_listeners, src)
	listening_recursive = set_to

///Returns a list of all locations (except the area) the movable is within.
/proc/get_nested_locs(atom/movable/atom_on_location, include_turf = FALSE)
	. = list()
	var/atom/location = atom_on_location.loc
	var/turf/our_turf = get_turf(atom_on_location)
	while(location && location != our_turf)
		. += location
		location = location.loc
	if(our_turf && include_turf) //At this point, only the turf is left, provided it exists.
		. += our_turf

/atom/movable/Exited(atom/movable/gone, atom/new_loc)
	. = ..()

	if (!LAZYLEN(gone.recursive_listeners))
		return
	for (var/atom/movable/location as anything in get_nested_locs(src)|src)
		LAZYREMOVE(location.recursive_listeners, gone.recursive_listeners)

/atom/movable/Entered(atom/movable/arrived, atom/old_loc)
	. = ..()

	if (!LAZYLEN(arrived.recursive_listeners))
		return
	for (var/atom/movable/location as anything in get_nested_locs(src)|src)
		LAZYOR(location.recursive_listeners, arrived.recursive_listeners)

///propogates ourselves through our nested contents, similar to other important_recursive_contents procs
///main difference is that client contents need to possibly duplicate recursive contents for the clients mob AND its eye
/mob/proc/enable_client_mobs_in_contents()
	return // We do not have SSspatial yet.
	/*
	for(var/atom/movable/movable_loc as anything in get_nested_locs(src) + src)
		LAZYINITLIST(movable_loc.important_recursive_contents)
		var/list/recursive_contents = movable_loc.important_recursive_contents // blue hedgehog velocity
		if(!length(recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS]))
			SSspatial_grid.add_grid_awareness(movable_loc, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)
		LAZYINITLIST(recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS])
		recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS] |= src

	var/turf/our_turf = get_turf(src)
	/// We got our awareness updated by the important recursive contents stuff, now we add our membership
	SSspatial_grid.add_grid_membership(src, our_turf, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)
	*/

///Clears the clients channel of this mob
/mob/proc/clear_important_client_contents()
	return // We do not have SSspatial yet.
/*
	var/turf/our_turf = get_turf(src)
	SSspatial_grid.remove_grid_membership(src, our_turf, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)

	for(var/atom/movable/movable_loc as anything in get_nested_locs(src) + src)
		LAZYINITLIST(movable_loc.important_recursive_contents)
		var/list/recursive_contents = movable_loc.important_recursive_contents // blue hedgehog velocity
		LAZYINITLIST(recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS])
		recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS] -= src
		if(!length(recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS]))
			SSspatial_grid.remove_grid_awareness(movable_loc, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)
		ASSOC_UNSETEMPTY(recursive_contents, RECURSIVE_CONTENTS_CLIENT_MOBS)
		UNSETEMPTY(movable_loc.important_recursive_contents)
*/

/atom/movable/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	return

/atom/movable/proc/can_be_pulled(user, force)
	if(src == user || !isturf(loc))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_ATOM_CAN_BE_PULLED, user) & COMSIG_ATOM_CANT_PULL)
		return FALSE
	if(anchored || throwing)
		return FALSE
	if(force < (move_resist * MOVE_FORCE_PULL_RATIO))
		return FALSE
	return TRUE

/**
 * Updates the grab state of the movable
 *
 * This exists to act as a hook for behaviour
 */
/atom/movable/proc/setGrabState(newstate)
	if(newstate == grab_state)
		return
	SEND_SIGNAL(src, COMSIG_MOVABLE_SET_GRAB_STATE, newstate)
	. = grab_state
	grab_state = newstate
	switch(grab_state) // Current state.
		if(GRAB_PASSIVE)
			pulling.remove_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), CHOKEHOLD_TRAIT)
			if(. >= GRAB_NECK) // Previous state was a a neck-grab or higher.
				REMOVE_TRAIT(pulling, TRAIT_FLOORED, CHOKEHOLD_TRAIT)
		if(GRAB_AGGRESSIVE)
			if(. >= GRAB_NECK) // Grab got downgraded.
				REMOVE_TRAIT(pulling, TRAIT_FLOORED, CHOKEHOLD_TRAIT)
			else // Grab got upgraded from a passive one.
				pulling.add_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), CHOKEHOLD_TRAIT)
		if(GRAB_NECK, GRAB_KILL)
			if(. <= GRAB_AGGRESSIVE)
				ADD_TRAIT(pulling, TRAIT_FLOORED, CHOKEHOLD_TRAIT)

/atom/movable/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---------")
	//VV_DROPDOWN_OPTION(VV_HK_OBSERVE_FOLLOW, "Observe Follow")
	VV_DROPDOWN_OPTION(VV_HK_GET_MOVABLE, "Get Movable")
	VV_DROPDOWN_OPTION(VV_HK_EDIT_PARTICLES, "Edit Particles")
	//VV_DROPDOWN_OPTION(VV_HK_DEADCHAT_PLAYS, "Start/Stop Deadchat Plays")
	//VV_DROPDOWN_OPTION(VV_HK_ADD_FANTASY_AFFIX, "Add Fantasy Affix")

/atom/movable/vv_do_topic(list/href_list)
	. = ..()

	if(!.)
		return

	//if(href_list[VV_HK_OBSERVE_FOLLOW])
	//	if(!check_rights(R_ADMIN))
	//		return
	//	usr.client?.admin_follow(src)

	if(href_list[VV_HK_GET_MOVABLE])
		if(!check_rights(R_ADMIN))
			return
		if(QDELETED(src))
			return
		if(ismob(src)) // incase there was a client inside an object being yoinked
			var/mob/M = src
			M.reset_perspective(src) // Force reset to self before teleport
		forceMove(get_turf(usr))

	if(href_list[VV_HK_EDIT_PARTICLES] && check_rights(R_VAREDIT))
		var/client/C = usr.client
		C?.open_particle_editor(src)

	//if(href_list[VV_HK_DEADCHAT_PLAYS] && check_rights(R_FUN))
	//	if(tgui_alert(usr, "Allow deadchat to control [src] via chat commands?", "Deadchat Plays [src]", list("Allow", "Cancel")) != "Allow")
	//		return
	//	// Alert is async, so quick sanity check to make sure we should still be doing this.
	//	if(QDELETED(src))
	//		return
	//	// This should never happen, but if it does it should not be silent.
	//	if(deadchat_plays() == COMPONENT_INCOMPATIBLE)
	//		to_chat(usr, span_warning("Deadchat control not compatible with [src]."))
	//		CRASH("deadchat_control component incompatible with object of type: [type]")
	//	to_chat(usr, span_notice("Deadchat now control [src]."))
	//	log_admin("[key_name(usr)] has added deadchat control to [src]")
	//	message_admins(span_notice("[key_name(usr)] has added deadchat control to [src]"))

/**
* A wrapper for setDir that should only be able to fail by living mobs.
*
* Called from [/atom/movable/proc/keyLoop], this exists to be overwritten by living mobs with a check to see if we're actually alive enough to change directions
*/
/atom/movable/proc/keybind_face_direction(direction)
	setDir(direction)
