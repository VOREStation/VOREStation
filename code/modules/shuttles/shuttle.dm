//shuttle moving state defines are in setup.dm

/datum/shuttle
	var/name = ""
	var/warmup_time = 0
	var/moving_status = SHUTTLE_IDLE

	var/list/shuttle_area // Initial value can be either a single area type or a list of area types
	var/obj/effect/shuttle_landmark/current_location //This variable is type-abused initially: specify the landmark_tag, not the actual landmark.

	var/tmp/arrive_time = 0	//the time at which the shuttle arrives when long jumping
	var/flags = SHUTTLE_FLAGS_NONE
	var/process_state = IDLE_STATE // Used with SHUTTLE_FLAGS_PROCESS, as well as to store current state.
	var/category = /datum/shuttle
	var/multiz = 0	//how many multiz levels, starts at 0  TODO Leshana - Are we porting this?

	var/ceiling_type // Type path of turf to roof over the shuttle when at multi-z landmarks.  Ignored if null.

	var/sound_takeoff = 'sound/effects/shuttles/shuttle_takeoff.ogg'
	var/sound_landing = 'sound/effects/shuttles/shuttle_landing.ogg'

	var/knockdown = 1 //whether shuttle downs non-buckled people when it moves

	var/defer_initialisation = FALSE //If this this shuttle should be initialised automatically.
	                                 //If set to true, you are responsible for initialzing the shuttle manually.
	                                 //Useful for shuttles that are initialized by map_template loading, or shuttles that are created in-game or not used.

	var/mothershuttle //tag of mothershuttle
	var/motherdock    //tag of mothershuttle landmark, defaults to starting location

	var/tmp/depart_time = 0 //Similar to above, set when the shuttle leaves when long jumping. Used for progress bars.

	var/debug_logging = FALSE // If set to true, the shuttle will start broadcasting its debug messages to admins

	// Future Thoughts: Baystation put "docking" stuff in a subtype, leaving base type pure and free of docking stuff. Is this best?

/datum/shuttle/New(_name, var/obj/effect/shuttle_landmark/initial_location)
	..()
	if(_name)
		src.name = _name

	var/list/areas = list()
	if(!islist(shuttle_area))
		shuttle_area = list(shuttle_area)
	for(var/T in shuttle_area)
		var/area/A = locate(T)
		if(!istype(A))
			CRASH("Shuttle \"[name]\" couldn't locate area [T].")
		areas += A
	shuttle_area = areas

	if(initial_location)
		current_location = initial_location
	else
		current_location = SSshuttles.get_landmark(current_location)
	if(!istype(current_location))
		if(debug_logging)
			log_shuttle("UM whoops, no initial? [src]")
		CRASH("Shuttle '[name]' could not find its starting location landmark [current_location].")

	if(src.name in SSshuttles.shuttles)
		CRASH("A shuttle with the name '[name]' is already defined.")
	SSshuttles.shuttles[src.name] = src
	if(flags & SHUTTLE_FLAGS_PROCESS)
		SSshuttles.process_shuttles += src
	if(flags & SHUTTLE_FLAGS_SUPPLY)
		if(SSsupply.shuttle)
			CRASH("A supply shuttle is already defined.")
		SSsupply.shuttle = src

/datum/shuttle/Destroy()
	current_location = null
	SSshuttles.shuttles -= src.name
	SSshuttles.process_shuttles -= src
	SSshuttles.shuttle_logs -= src
	if(SSsupply.shuttle == src)
		SSsupply.shuttle = null
	. = ..()

// This is called after all shuttles have been initialized by SSshuttles, but before sectors have been initialized.
// Importantly for subtypes, all shuttles will have been initialized and mothershuttles hooked up by the time this is called.
/datum/shuttle/proc/populate_shuttle_objects()
	// Scan for shuttle consoles on them needing auto-config.
	for(var/area/A in find_childfree_areas()) // Let sub-shuttles handle their areas, only do our own.
		for(var/obj/machinery/computer/shuttle_control/SC in A)
			if(!SC.shuttle_tag)
				SC.set_shuttle_tag(src.name)
	return

// This creates a graphical warning to where the shuttle is about to land, in approximately five seconds.
/datum/shuttle/proc/create_warning_effect(var/obj/effect/shuttle_landmark/destination)
	destination.create_warning_effect(src)

// Return false to abort a jump, before the 'warmup' phase.
/datum/shuttle/proc/pre_warmup_checks()
	return TRUE

// Ditto, but for afterwards.
/datum/shuttle/proc/post_warmup_checks()
	return TRUE

// If you need an event to occur when the shuttle jumps in short or long jump, override this.
// Keep in mind that destination is the intended destination, the shuttle may or may not actually reach it.s
/datum/shuttle/proc/on_shuttle_departure(var/obj/effect/shuttle_landmark/origin, var/obj/effect/shuttle_landmark/destination)
	return

// Similar to above, but when it finishes moving to the target.  Short jump generally makes this occur immediately after the above proc.
// Keep in mind we might not actually have gotten to destination.  Check current_location to be sure where we ended up.
/datum/shuttle/proc/on_shuttle_arrival(var/obj/effect/shuttle_landmark/origin, var/obj/effect/shuttle_landmark/destination)
	return

/datum/shuttle/proc/short_jump(var/obj/effect/shuttle_landmark/destination)
	if(moving_status != SHUTTLE_IDLE)
		return

	if(!pre_warmup_checks())
		return

	var/obj/effect/shuttle_landmark/start_location = current_location
	// TODO - Figure out exactly when to play sounds.  Before warmup_time delay? Should there be a sleep for waiting for sounds? or no?
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)

		make_sounds(HYPERSPACE_WARMUP)
		create_warning_effect(destination)
		sleep(5 SECONDS) // so the sound finishes.

		if(!post_warmup_checks())
			cancel_launch(null)

		if(!fuel_check()) //fuel error (probably out of fuel) occured, so cancel the launch
			cancel_launch(null)

		if (moving_status == SHUTTLE_IDLE)
			make_sounds(HYPERSPACE_END)
			return	//someone cancelled the launch

		moving_status = SHUTTLE_INTRANSIT //shouldn't matter but just to be safe
		on_shuttle_departure(start_location, destination)

		attempt_move(destination)

		moving_status = SHUTTLE_IDLE
		on_shuttle_arrival(start_location, destination)

		make_sounds(HYPERSPACE_END)

// TODO - Far Future - Would be great if this was driven by process too.
/datum/shuttle/proc/long_jump(var/obj/effect/shuttle_landmark/destination, var/obj/effect/shuttle_landmark/interim, var/travel_time)
	//to_world("shuttle/long_jump: current_location=[current_location], destination=[destination], interim=[interim], travel_time=[travel_time]")
	if(moving_status != SHUTTLE_IDLE)
		return

	if(!pre_warmup_checks())
		return

	var/obj/effect/shuttle_landmark/start_location = current_location
	// TODO - Figure out exactly when to play sounds.  Before warmup_time delay? Should there be a sleep for waiting for sounds? or no?
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)

		make_sounds(HYPERSPACE_WARMUP)
		create_warning_effect(interim) // Really doubt someone is gonna get crushed in the interim area but for completeness's sake we'll make the warning.
		sleep(5 SECONDS) // so the sound finishes.

		if(!post_warmup_checks())
			cancel_launch(null)

		if (moving_status == SHUTTLE_IDLE)
			make_sounds(HYPERSPACE_END)
			return	//someone cancelled the launch

		arrive_time = world.time + travel_time*10
		depart_time = world.time

		moving_status = SHUTTLE_INTRANSIT
		on_shuttle_departure(start_location, destination)

		if(attempt_move(interim, TRUE))
			interim.shuttle_arrived()

			if(process_longjump(current_location, destination)) //VOREStation Edit - To hook custom shuttle code in
				return //VOREStation Edit - It handled it for us (shuttle crash or such)

			var/last_progress_sound = 0
			var/made_warning = FALSE
			while (world.time < arrive_time)
				// Make the shuttle make sounds every four seconds, since the sound file is five seconds.
				if(last_progress_sound + 4 SECONDS < world.time)
					make_sounds(HYPERSPACE_PROGRESS)
					last_progress_sound = world.time

				if(arrive_time - world.time <= 5 SECONDS && !made_warning)
					made_warning = TRUE
					create_warning_effect(destination)
				sleep(5)

			if(!attempt_move(destination))
				attempt_move(start_location) //try to go back to where we started. If that fails, I guess we're stuck in the interim location

		moving_status = SHUTTLE_IDLE
		on_shuttle_arrival(start_location, destination)
		make_sounds(HYPERSPACE_END)


//////////////////////////////
// Forward declarations of public procs.  They do nothing because this is not auto-dock.

/datum/shuttle/proc/fuel_check()
	return 1 //fuel check should always pass in non-overmap shuttles (they have magic engines)

/datum/shuttle/proc/cancel_launch(var/user)
	// If we are past warming up its too late to cancel.
	if (moving_status == SHUTTLE_WARMUP)
		moving_status = SHUTTLE_IDLE
/*
	Docking stuff
*/
/datum/shuttle/proc/dock()
	return

/datum/shuttle/proc/undock()
	return

/datum/shuttle/proc/force_undock()
	return

// Check if we are docked (or never dock) and thus have properly arrived.
/datum/shuttle/proc/check_docked()
	return TRUE

// Check if we are undocked and thus probably ready to depart.
/datum/shuttle/proc/check_undocked()
	return TRUE

/*****************
* Shuttle Moved Handling * (Observer Pattern Implementation: Shuttle Moved)
* Shuttle Pre Move Handling * (Observer Pattern Implementation: Shuttle Pre Move)
*****************/

// Move the shuttle to destination if possible.
// Returns TRUE if we actually moved, otherwise FALSE.
/datum/shuttle/proc/attempt_move(var/obj/effect/shuttle_landmark/destination, var/interim = FALSE)
	if(current_location == destination)
		if(debug_logging)
			log_shuttle("Shuttle [src] attempted to move to [destination] but is already there!")
		return FALSE

	if(!destination.is_valid(src))
		if(debug_logging)
			log_shuttle("Shuttle [src] aborting attempt_move() because destination=[destination] is not valid")
		return FALSE
	if(current_location.cannot_depart(src))
		if(debug_logging)
			log_shuttle("Shuttle [src] aborting attempt_move() because current_location=[current_location] refuses.")
		return FALSE

	// Observer pattern pre-move
	var/old_location = current_location
	GLOB.shuttle_pre_move_event.raise_event(src, old_location, destination)
	current_location.shuttle_departed(src)

	if(debug_logging)
		log_shuttle("[src] moving to [destination]. Areas are [english_list(shuttle_area)]")
	var/list/translation = list()
	for(var/area/A in shuttle_area)
		if(debug_logging)
			log_shuttle("Translating [A]")
		translation += get_turf_translation(get_turf(current_location), get_turf(destination), A.contents)

	// Actually do it! (This never fails)
	perform_shuttle_move(destination, translation)

	// Observer pattern post-move
	destination.shuttle_arrived(src)
	GLOB.shuttle_moved_event.raise_event(src, old_location, destination)

	return TRUE


//just moves the shuttle from A to B
//A note to anyone overriding move in a subtype. perform_shuttle_move() must absolutely not, under any circumstances, fail to move the shuttle.
//If you want to conditionally cancel shuttle launches, that logic must go in short_jump() or long_jump()
/datum/shuttle/proc/perform_shuttle_move(var/obj/effect/shuttle_landmark/destination, var/list/turf_translation)
	if(debug_logging)
		log_shuttle("perform_shuttle_move() current=[current_location] destination=[destination]")
	//to_world("move_shuttle() called for [name] leaving [origin] en route to [destination].")

	//to_world("area_coming_from: [origin]")
	//to_world("destination: [destination]")
	ASSERT(current_location != destination)

	// If shuttle has no internal gravity, update our gravity with destination gravity
	if((flags & SHUTTLE_FLAGS_ZERO_G))
		var/new_grav = 1
		if(destination.flags & SLANDMARK_FLAG_ZERO_G)
			var/area/new_area = get_area(destination)
			new_grav = new_area.has_gravity
		for(var/area/our_area in shuttle_area)
			if(our_area.has_gravity != new_grav)
				our_area.gravitychange(new_grav)

	// TODO - Old code used to throw stuff out of the way instead of squashing.  Should we?

	// Move, gib, or delete everything in our way!
	for(var/turf/src_turf in turf_translation)
		var/turf/dst_turf = turf_translation[src_turf]
		if(src_turf.is_solid_structure()) // in case someone put a hole in the shuttle and you were lucky enough to be under it
			for(var/atom/movable/AM in dst_turf)
				//if(AM.movable_flags & MOVABLE_FLAG_DEL_SHUTTLE)
				//	qdel(AM)
				//	continue
				if(!AM.simulated)
					continue
				if(isobserver(AM) || isEye(AM))
					continue
				if(isliving(AM))
					var/mob/living/bug = AM
					bug.gib()
				else
					qdel(AM) //it just gets atomized I guess? TODO throw it into space somewhere, prevents people from using shuttles as an atom-smasher

	var/list/powernets = list()
	for(var/area/A in shuttle_area)
		// If there was a zlevel above our origin and we own the ceiling, erase our ceiling now we're leaving
		if(ceiling_type && HasAbove(current_location.z))
			for(var/turf/TO in A.contents)
				var/turf/TA = GetAbove(TO)
				if(istype(TA, ceiling_type))
					TA.ChangeTurf(get_base_turf_by_area(TA), 1, 1)
		if(knockdown)
			for(var/mob/living/M in A)
				spawn(0)
					if(M.buckled)
						to_chat(M, "<font color='red'>Sudden acceleration presses you into \the [M.buckled]!</font>")
						shake_camera(M, 3, 1)
					else
						to_chat(M, "<font color='red'>The floor lurches beneath you!</font>")
						shake_camera(M, 10, 1)
						// TODO - tossing?
						//M.visible_message("<span class='warning'>[M.name] is tossed around by the sudden acceleration!</span>")
						//M.throw_at_random(FALSE, 4, 1)
						if(istype(M, /mob/living/carbon))
							M.Weaken(3)
							//VOREStation Add
							if(move_direction)
								throw_a_mob(M,move_direction)
							//VOREStation Add End
		// We only need to rebuild powernets for our cables.  No need to check machines because they are on top of cables.
		for(var/obj/structure/cable/C in A)
			powernets |= C.powernet

	// Update our base turfs before we move, so that transparent turfs look good.
	var/new_base = destination.base_turf || /turf/space
	for(var/area/A as anything in shuttle_area)
		A.base_turf = new_base

	// Actually do the movement of everything - This replaces origin.move_contents_to(destination)
	translate_turfs(turf_translation, current_location.base_area, current_location.base_turf)
	current_location = destination

	// If there's a zlevel above our destination, paint in a ceiling on it so we retain our air
	if(ceiling_type && HasAbove(current_location.z))
		for(var/area/A in shuttle_area)
			for(var/turf/TD in A.contents)
				var/turf/TA = GetAbove(TD)
				if(istype(TA, get_base_turf_by_area(TA)) || isopenspace(TA))
					if(get_area(TA) in shuttle_area)
						continue
					TA.ChangeTurf(ceiling_type, TRUE, TRUE, TRUE)

	// Power-related checks. If shuttle contains power related machinery, update powernets.
	// Note: Old way was to rebuild ALL powernets: if(powernets.len) SSmachines.makepowernets()
	// New way only rebuilds the powernets we have to
	var/list/cables = list()
	for(var/datum/powernet/P in powernets)
		cables |= P.cables
		qdel(P)
	SSmachines.setup_powernets_for_cables(cables)

	// Adjust areas of mothershuttle so it doesn't try and bring us with it if it jumps while we aren't on it.
	if(mothershuttle)
		var/datum/shuttle/MS = SSshuttles.shuttles[mothershuttle]
		if(MS)
			if(current_location.landmark_tag == motherdock)
				MS.shuttle_area |= shuttle_area // We are now on mothershuttle! Bring us along!
			else
				MS.shuttle_area -= shuttle_area // We have left mothershuttle! Don't bring us along!

	return

//returns 1 if the shuttle has a valid arrive time
/datum/shuttle/proc/has_arrive_time()
	return (moving_status == SHUTTLE_INTRANSIT)

/datum/shuttle/proc/make_sounds(var/sound_type)
	var/sound_to_play = null
	switch(sound_type)
		if(HYPERSPACE_WARMUP)
			sound_to_play = 'sound/effects/shuttles/hyperspace_begin.ogg'
		if(HYPERSPACE_PROGRESS)
			sound_to_play = 'sound/effects/shuttles/hyperspace_progress.ogg'
		if(HYPERSPACE_END)
			sound_to_play = 'sound/effects/shuttles/hyperspace_end.ogg'
	for(var/area/A in shuttle_area)
		for(var/obj/machinery/door/E in A)	//dumb, I know, but playing it on the engines doesn't do it justice
			playsound(E, sound_to_play, 50, FALSE)

/datum/shuttle/proc/message_passengers(var/message)
	for(var/area/A in shuttle_area)
		for(var/mob/M in A)
			M.show_message(message, 2)

/datum/shuttle/proc/find_children()
	. = list()
	for(var/shuttle_name in SSshuttles.shuttles)
		var/datum/shuttle/shuttle = SSshuttles.shuttles[shuttle_name]
		if(shuttle.mothershuttle == name)
			. += shuttle

//Returns the areas in shuttle_area that are not actually child shuttles.
/datum/shuttle/proc/find_childfree_areas()
	. = shuttle_area.Copy()
	for(var/datum/shuttle/child in find_children())
		. -= child.shuttle_area

/datum/shuttle/proc/get_location_name()
	if(moving_status == SHUTTLE_INTRANSIT)
		return "In transit"
	return current_location.name
