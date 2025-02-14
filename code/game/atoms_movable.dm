/atom/movable
	layer = OBJ_LAYER
	appearance_flags = TILE_BOUND|PIXEL_SCALE|KEEP_TOGETHER|LONG_GLIDE
	glide_size = 8
	var/last_move = null //The direction the atom last moved
	var/anchored = FALSE
	// var/elevation = 2    - not used anywhere
	var/moving_diagonally
	var/move_speed = 10
	var/l_move_time = 1
	var/throwing = 0
	var/thrower
	var/turf/throw_source = null
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = 0
	var/mob/pulledby = null
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
	var/movement_type = NONE

	var/cloaked = FALSE //If we're cloaked or not
	var/image/cloaked_selfimage //The image we use for our client to let them see where we are

/atom/movable/Initialize(mapload)
	. = ..()
	switch(blocks_emissive)
		if(EMISSIVE_BLOCK_GENERIC)
			var/mutable_appearance/gen_emissive_blocker = mutable_appearance(icon, icon_state, plane = PLANE_EMISSIVE, alpha = src.alpha)
			gen_emissive_blocker.color = GLOB.em_block_color
			gen_emissive_blocker.dir = dir
			gen_emissive_blocker.appearance_flags |= appearance_flags
			add_overlay(list(gen_emissive_blocker), TRUE)
		if(EMISSIVE_BLOCK_UNIQUE)
			render_target = ref(src)
			em_block = new(src, render_target)
			add_overlay(list(em_block), TRUE)
			RegisterSignal(em_block, COMSIG_PARENT_QDELETING, PROC_REF(emblocker_gc))
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

/atom/movable/Destroy()
	if(em_block)
		cut_overlay(em_block)
		UnregisterSignal(em_block, COMSIG_PARENT_QDELETING)
		QDEL_NULL(em_block)
	. = ..()

	unbuckle_all_mobs()

	for(var/atom/movable/AM in contents)
		qdel(AM)

	if(opacity)
		RemoveElement(/datum/element/light_blocking)

	moveToNullspace()

	vis_contents.Cut()
	for(var/atom/movable/A as anything in vis_locs)
		A.vis_contents -= src

	if(pulledby)
		pulledby.stop_pulling()

	if(orbiting)
		stop_orbit()
	QDEL_NULL(riding_datum) //VOREStation Add

/atom/movable/vv_edit_var(var_name, var_value)
	if(var_name in GLOB.VVpixelmovement)			//Pixel movement is not yet implemented, changing this will break everything irreversibly.
		return FALSE
	return ..()

////////////////////////////////////////
/atom/movable/Move(atom/newloc, direct = 0, movetime)
	// Didn't pass enough info
	if(!loc || !newloc)
		return FALSE

	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, newloc, direct, movetime) & COMPONENT_MOVABLE_BLOCK_PRE_MOVE)
		return FALSE

	// Store this early before we might move, it's used several places
	var/atom/oldloc = loc

	// If we're not moving to the same spot (why? does that even happen?)
	if(loc != newloc)
		if(!direct)
			direct = get_dir(oldloc, newloc)
		if (IS_CARDINAL(direct)) //Cardinal move
			// Track our failure if any in this value
			. = TRUE

			// Face the direction of movement
			set_dir(direct)

			// Check to make sure we can leave
			if(!loc.Exit(src, newloc))
				. = FALSE

			// Check to make sure we can enter, if we haven't already failed
			if(. && !newloc.Enter(src, src.loc))
				. = FALSE

			// Check to make sure if we're multi-tile we can move, if we haven't already failed
			if(. && !check_multi_tile_move_density_dir(direct, locs))
				. = FALSE

			// Definitely moving if you enter this, no failures so far
			if(. && locs.len <= 1)	// We're not a multi-tile object.
				var/area/oldarea = get_area(oldloc)
				var/area/newarea = get_area(newloc)
				var/old_z = get_z(oldloc)
				var/dest_z = get_z(newloc)

				// Do The Move
				if(movetime)
					glide_for(movetime) // First attempt, lets let the diag do it.
				loc = newloc
				. = TRUE

				// So objects can be informed of z-level changes
				if (old_z != dest_z)
					onTransitZ(old_z, dest_z)

				// We don't call parent so we are calling this for byond
				oldloc.Exited(src, newloc)
				if(oldarea != newarea)
					oldarea.Exited(src, newloc)

				// Multi-tile objects can't reach here, otherwise you'd need to avoid uncrossing yourself
				for(var/atom/movable/thing as anything in oldloc)
					// We don't call parent so we are calling this for byond
					thing.Uncrossed(src)

				// We don't call parent so we are calling this for byond
				newloc.Entered(src, oldloc)
				if(oldarea != newarea)
					newarea.Entered(src, oldloc)

				// Multi-tile objects can't reach here, otherwise you'd need to avoid uncrossing yourself
				for(var/atom/movable/thing as anything in loc)
					// We don't call parent so we are calling this for byond
					thing.Crossed(src, oldloc)

			// We're a multi-tile object (multiple locs)
			else if(. && newloc)
				. = doMove(newloc)

		//Diagonal move, split it into cardinal moves
		else
			moving_diagonally = FIRST_DIAG_STEP
			var/first_step_dir
			// The `&& moving_diagonally` checks are so that a forceMove taking
			// place due to a Crossed, Bumped, etc. call will interrupt
			// the second half of the diagonal movement, or the second attempt
			// at a first half if step() fails because we hit something.
			glide_for(movetime * 2)
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
			// If we failed, turn to face the direction of the first step at least
			if(!. && moving_diagonally == SECOND_DIAG_STEP)
				set_dir(first_step_dir)
			// Done, regardless!
			moving_diagonally = 0
			// We return because step above will call Move() and we don't want to do shenanigans back in here again
			return

	else if(!loc || (loc == oldloc))
		last_move = 0
		return

	// If we moved, call Moved() on ourselves
	if(.)
		Moved(oldloc, direct, FALSE, movetime ? movetime : MOVE_GLIDE_CALC(glide_size, moving_diagonally) )

	// Update timers/cooldown stuff
	move_speed = world.time - l_move_time
	l_move_time = world.time
	last_move = direct // The direction you last moved
	// set_dir(direct) //Don't think this is necessary

//Called after a successful Move(). By this point, we've already moved
/atom/movable/proc/Moved(atom/old_loc, direction, forced = FALSE, movetime)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old_loc, direction, forced, movetime)
	// Handle any buckled mobs on this movable
	if(has_buckled_mobs())
		handle_buckled_mob_movement(old_loc, direction, movetime)
	if(riding_datum)
		riding_datum.handle_vehicle_layer()
		riding_datum.handle_vehicle_offsets()
	for (var/datum/light_source/light as anything in light_sources) // Cycle through the light sources on this atom and tell them to update.
		light.source_atom.update_light()

	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old_loc, direction)

	return TRUE

/atom/movable/set_dir(newdir)
	. = ..(newdir)
	if(riding_datum)
		riding_datum.handle_vehicle_offsets()

/atom/movable/relaymove(mob/user, direction)
	. = ..()
	if(riding_datum)
		riding_datum.handle_ride(user, direction)

// Make sure you know what you're doing if you call this, this is intended to only be called by byond directly.
// You probably want CanPass()
/atom/movable/Cross(atom/movable/AM)
	return CanPass(AM, loc)

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

/atom/movable/proc/forceMove(atom/destination, direction, movetime)
	. = FALSE
	if(destination)
		. = doMove(destination, direction, movetime)
	else
		CRASH("No valid destination passed into forceMove")

/atom/movable/proc/moveToNullspace()
	return doMove(null)

/atom/movable/proc/doMove(atom/destination, direction, movetime)
	var/atom/oldloc = loc
	var/area/old_area = get_area(oldloc)
	var/same_loc = oldloc == destination

	if(destination)
		var/area/destarea = get_area(destination)

		// Do The Move
		glide_for(movetime)
		last_move = isnull(direction) ? 0 : direction
		loc = destination

		// Unset this in case it was set in some other proc. We're no longer moving diagonally for sure.
		moving_diagonally = 0

		// We are moving to a different loc
		if(!same_loc)
			// Not moving out of nullspace
			if(oldloc)
				oldloc.Exited(src, destination)
				// If it's not the same area, Exited() it
				if(old_area && old_area != destarea)
					old_area.Exited(src, destination)

			// Uncross everything where we left
			for(var/atom/movable/AM as anything in oldloc)
				if(AM == src)
					continue
				AM.Uncrossed(src)
				if(loc != destination) // Uncrossed() triggered a separate movement
					return

			// Information about turf and z-levels for source and dest collected
			var/turf/oldturf = get_turf(oldloc)
			var/turf/destturf = get_turf(destination)
			var/old_z = (oldturf ? oldturf.z : null)
			var/dest_z = (destturf ? destturf.z : null)

			// So objects can be informed of z-level changes
			if (old_z != dest_z)
				onTransitZ(old_z, dest_z)

			// Destination atom Entered
			destination.Entered(src, oldloc)

			// Entered() the new area if it's not the same area
			if(destarea && old_area != destarea)
				destarea.Entered(src, oldloc)

			// We ignore ourselves because if we're multi-tile we might be in both old and new locs
			for(var/atom/movable/AM as anything in destination)
				if(AM == src)
					continue
				AM.Crossed(src, oldloc)
				if(loc != destination) // Crossed triggered a separate movement
					return

			// Call our thingy to inform everyone we moved
			Moved(oldloc, NONE, TRUE)

		// Break pulling if we are too far to pull now.
		if(pulledby && (pulledby.z != src.z || get_dist(pulledby, src) > 1))
			pulledby.stop_pulling()

		// We moved
		return TRUE

	//If no destination, move the atom into nullspace (don't do this unless you know what you're doing)
	else if(oldloc)
		loc = null

		// Uncross everything where we left (no multitile safety like above because we are definitely not still there)
		for(var/atom/movable/AM as anything in oldloc)
			AM.Uncrossed(src)

		// Exited() our loc and area
		oldloc.Exited(src, null)
		if(old_area)
			old_area.Exited(src, null)

		// We moved
		return TRUE

/atom/movable/proc/onTransitZ(old_z,new_z)
	SEND_SIGNAL(src, COMSIG_OBSERVER_Z_MOVED, old_z, new_z)
	SEND_SIGNAL(src, COMSIG_MOVABLE_Z_CHANGED, old_z, new_z)
	for(var/atom/movable/AM as anything in src) // Notify contents of Z-transition. This can be overridden IF we know the items contents do not care.
		AM.onTransitZ(old_z,new_z)

/atom/movable/proc/glide_for(movetime)
	if(movetime)
		glide_size = WORLD_ICON_SIZE/max(DS2TICKS(movetime), 1)
		spawn(movetime)
			glide_size = initial(glide_size)
	else
		glide_size = initial(glide_size)

/////////////////////////////////////////////////////////////////

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
			if(A == src) continue
			if(isliving(A))
				if(A:lying) continue
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

/atom/movable/overlay/New()
	for(var/x in src.verbs)
		src.verbs -= x
	..()

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

		if(ticker && istype(ticker.mode, /datum/game_mode/nuclear)) //only really care if the game mode is nuclear
			var/datum/game_mode/nuclear/G = ticker.mode
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
	UnregisterSignal(source, COMSIG_PARENT_QDELETING)
	cut_overlay(source)
	if(em_block == source)
		em_block = null

/atom/movable/proc/abstract_move(atom/new_loc)
	var/atom/old_loc = loc
	var/direction = get_dir(old_loc, new_loc)
	loc = new_loc
	Moved(old_loc, direction, TRUE)
