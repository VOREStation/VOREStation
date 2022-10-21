// Subtype of shuttle that handles docking with docking controllers
// Consists of code pulled down from the old /datum/shuttle and up from /datum/shuttle/ferry
// Note: Since all known shuttles extend this type, this really could just be built into /datum/shuttle
// Why isn't it you ask? Eh, baystation did it this way and its convenient to keep the files smaller I guess.
/datum/shuttle/autodock
	var/in_use = null	// Tells the controller whether this shuttle needs processing, also attempts to prevent double-use
	var/last_dock_attempt_time = 0

	var/docking_controller_tag = null // ID of the controller on the shuttle (If multiple, this is the default one)
	var/datum/embedded_program/docking/shuttle_docking_controller // Controller on the shuttle (the one in use)
	var/docking_codes

	var/tmp/obj/effect/shuttle_landmark/next_location  //This is only used internally.
	var/datum/embedded_program/docking/active_docking_controller // Controller we are docked with (or trying to)

	var/obj/effect/shuttle_landmark/landmark_transition  //This variable is type-abused initially: specify the landmark_tag, not the actual landmark.
	var/move_time = 240		//the time spent in the transition area

	category = /datum/shuttle/autodock
	flags = SHUTTLE_FLAGS_PROCESS | SHUTTLE_FLAGS_ZERO_G

/datum/shuttle/autodock/New(var/_name, var/obj/effect/shuttle_landmark/start_waypoint)
	..(_name, start_waypoint)

	//Initial dock
	active_docking_controller = current_location.docking_controller
	update_docking_target(current_location)
	if(active_docking_controller)
		set_docking_codes(active_docking_controller.docking_codes)
	else if(global.using_map.use_overmap)
		var/obj/effect/overmap/visitable/location = get_overmap_sector(get_z(current_location))
		if(location && location.docking_codes)
			set_docking_codes(location.docking_codes)
	dock()

	//Optional transition area
	if(landmark_transition)
		landmark_transition = SSshuttles.get_landmark(landmark_transition)

/datum/shuttle/autodock/Destroy()
	in_use = null
	next_location = null
	active_docking_controller = null
	landmark_transition = null

	return ..()

/datum/shuttle/autodock/proc/set_docking_codes(var/code)
	docking_codes = code
	if(shuttle_docking_controller)
		shuttle_docking_controller.docking_codes = code

/datum/shuttle/autodock/perform_shuttle_move()
	force_undock() //bye!
	..()

// Despite the name this actually updates the SHUTTLE docking conroller, not the active.
/datum/shuttle/autodock/proc/update_docking_target(var/obj/effect/shuttle_landmark/location)
	var/current_dock_target
	if(location && location.special_dock_targets && location.special_dock_targets[name])
		current_dock_target = location.special_dock_targets[name]
	else
		current_dock_target = docking_controller_tag
	shuttle_docking_controller = SSshuttles.docking_registry[current_dock_target]
	if(current_dock_target && !shuttle_docking_controller)
		log_shuttle("<span class='danger'>warning: shuttle [src] can't find its controller with tag [current_dock_target]!</span>") // No toggle because this is an error message that needs to be seen
/*
	Docking stuff
*/
/datum/shuttle/autodock/dock()
	if(active_docking_controller && shuttle_docking_controller)
		shuttle_docking_controller.initiate_docking(active_docking_controller.id_tag)
		last_dock_attempt_time = world.time

/datum/shuttle/autodock/undock()
	if(shuttle_docking_controller)
		shuttle_docking_controller.initiate_undocking()

/datum/shuttle/autodock/force_undock()
	if(shuttle_docking_controller)
		shuttle_docking_controller.force_undock()

/datum/shuttle/autodock/check_docked()
	if(shuttle_docking_controller)
		return shuttle_docking_controller.docked()
	return TRUE

/datum/shuttle/autodock/check_undocked()
	if(shuttle_docking_controller)
		return shuttle_docking_controller.can_launch()
	return TRUE

// You also could just directly reference active_docking_controller
/datum/shuttle/autodock/proc/current_dock_target()
	if(active_docking_controller)
		return active_docking_controller.id_tag
	return null

// These checks are built into the check_docked() and check_undocked() procs
/datum/shuttle/autodock/proc/skip_docking_checks()
	if (!shuttle_docking_controller || !current_dock_target())
		return TRUE	//shuttles without docking controllers or at locations without docking ports act like old-style shuttles
	return FALSE


/*
	Please ensure that long_jump() and short_jump() are only called from here. This applies to subtypes as well.
	Doing so will ensure that multiple jumps cannot be initiated in parallel.
*/
/datum/shuttle/autodock/process()
	switch(process_state)
		if (WAIT_LAUNCH)
			if(check_undocked())
				//*** ready to go
				process_launch()

		if (FORCE_LAUNCH)
			process_launch()

		if (WAIT_ARRIVE)
			if (moving_status == SHUTTLE_IDLE)
				//*** we made it to the destination, update stuff
				process_arrived()
				process_state = WAIT_FINISH

		if (WAIT_FINISH)
			if (world.time > last_dock_attempt_time + DOCK_ATTEMPT_TIMEOUT || check_docked())
				//*** all done here
				process_state = IDLE_STATE
				arrived()

//not to be confused with the arrived() proc
/datum/shuttle/autodock/proc/process_arrived()
	active_docking_controller = next_location.docking_controller
	update_docking_target(next_location)
	dock()

	next_location = null
	in_use = null	//release lock

/datum/shuttle/autodock/proc/get_travel_time()
	return move_time

/datum/shuttle/autodock/proc/process_launch()
	if(!next_location || !next_location.is_valid(src) || current_location.cannot_depart(src))
		process_state = IDLE_STATE
		in_use = null
		return
	if (get_travel_time() && landmark_transition)
		. = long_jump(next_location, landmark_transition, get_travel_time())
	else
		. = short_jump(next_location)
	process_state = WAIT_ARRIVE

/*
	Guards - (These don't take docking status into account, just the state machine and move safety)
*/
/datum/shuttle/autodock/proc/can_launch()
	return (next_location && next_location.is_valid(src) && !current_location.cannot_depart(src) && moving_status == SHUTTLE_IDLE && !in_use)

/datum/shuttle/autodock/proc/can_force()
	return (next_location && next_location.is_valid(src) && !current_location.cannot_depart(src) && moving_status == SHUTTLE_IDLE && process_state == WAIT_LAUNCH)

/datum/shuttle/autodock/proc/can_cancel()
	return (moving_status == SHUTTLE_WARMUP || process_state == WAIT_LAUNCH || process_state == FORCE_LAUNCH)

/*
	"Public" procs
*/
// Queue shuttle for undock and launch by shuttle subsystem.
/datum/shuttle/autodock/proc/launch(var/user)
	if (!can_launch()) return

	in_use = user	//obtain an exclusive lock on the shuttle

	process_state = WAIT_LAUNCH
	undock()

// Queue shuttle for forced undock and launch by shuttle subsystem.
/datum/shuttle/autodock/proc/force_launch(var/user)
	if (!can_force()) return

	in_use = user	//obtain an exclusive lock on the shuttle

	process_state = FORCE_LAUNCH

// Cancel queued launch.
/datum/shuttle/autodock/cancel_launch(var/user)
	if (!can_cancel()) return

	moving_status = SHUTTLE_IDLE
	process_state = WAIT_FINISH
	in_use = null

	//whatever we were doing with docking: stop it, then redock
	force_undock()
	spawn(1 SECOND)
		dock()

//returns 1 if the shuttle is getting ready to move, but is not in transit yet
/datum/shuttle/autodock/proc/is_launching()
	return (moving_status == SHUTTLE_WARMUP || process_state == WAIT_LAUNCH || process_state == FORCE_LAUNCH)

// /datum/shuttle/autodock/get_location_name() defined in shuttle.dm

/datum/shuttle/autodock/proc/get_destination_name()
	if(!next_location)
		return "None"
	return next_location.name

//This gets called when the shuttle finishes arriving at it's destination
//This can be used by subtypes to do things when the shuttle arrives.
//Note that this is called when the shuttle leaves the WAIT_FINISHED state, the proc name is a little misleading
/datum/shuttle/autodock/proc/arrived()
	return	//do nothing for now

/obj/effect/shuttle_landmark/transit
	landmark_flags = LANDMARK_REMOVES_GRAVITY | LANDMARK_CREATES_SAFE_SITE
