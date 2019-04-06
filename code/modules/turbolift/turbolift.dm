// Lift master datum. One per turbolift.
/datum/turbolift
	var/datum/turbolift_floor/target_floor              // Where are we going?
	var/datum/turbolift_floor/current_floor             // Where is the lift currently?
	var/list/doors = list()                             // Doors inside the lift structure.
	var/list/queued_floors = list()                     // Where are we moving to next?
	var/list/floors = list()                            // All floors in this system.
	var/move_delay = 30                                 // Time between floor changes.
	var/floor_wait_delay = 85                           // Time to wait at floor stops.
	var/obj/structure/lift/panel/control_panel_interior // Lift control panel.
	var/doors_closing = 0								// Whether doors are in the process of closing
	var/list/music = null								// Elevator music to set on areas
	var/priority_mode = FALSE							// Flag to block buttons from calling the elevator if in priority mode.
	var/fire_mode = FALSE								// Flag to indicate firefighter mode is active.

	var/tmp/moving_upwards
	var/tmp/busy

/datum/turbolift/proc/emergency_stop()
	cancel_pending_floors()
	target_floor = null
	if(!fire_mode)
		open_doors()

// Enter priority mode, blocking all calls for awhile
/datum/turbolift/proc/priority_mode(var/time = 30 SECONDS)
	priority_mode = TRUE
	cancel_pending_floors()
	update_ext_panel_icons()
	control_panel_interior.audible_message("<span class='info'>This turbolift is responding to a priority call.  Please exit the lift when it stops and make way.</span>")
	spawn(time)
		priority_mode = FALSE
		update_ext_panel_icons()

/datum/turbolift/proc/update_fire_mode(var/new_fire_mode)
	if(fire_mode == new_fire_mode)
		return
	fire_mode = new_fire_mode
	if(new_fire_mode)
		cancel_pending_floors()

	// Turn the lights red and kill the music
	for(var/datum/turbolift_floor/F in floors)
		var/area/turbolift/A = locate(F.area_ref)
		if(new_fire_mode)
			if(A.forced_ambience)
				A.forced_ambience.Cut()
			A.fire_alert()
		else
			if(music)
				A.forced_ambience = music.Copy()
			A.fire_reset()
		for(var/mob/living/M in mobs_in_area(A))
			if(M.mind)
				A.play_ambience(M)
		// Disable safeties on the doors during firemode, reset when done
		for(var/obj/machinery/door/airlock/door in F.doors)
			door.safe = new_fire_mode ? FALSE : initial(door.safe)

	// Disable safeties on the doors during firemode, reset when done
	for(var/obj/machinery/door/airlock/door in doors)
		door.safe = new_fire_mode ? FALSE : initial(door.safe)
	update_ext_panel_icons()
	control_panel_interior.update_icon()

// Cancel all pending calls
/datum/turbolift/proc/cancel_pending_floors()
	for(var/datum/turbolift_floor/floor in queued_floors)
		if(floor.ext_panel)
			floor.ext_panel.reset()
	queued_floors.Cut()
	control_panel_interior.updateDialog()

// Update the icons of all exterior panels (after we change modes etc)
/datum/turbolift/proc/update_ext_panel_icons()
	for(var/datum/turbolift_floor/floor in floors)
		if(floor.ext_panel)
			floor.ext_panel.update_icon()

/datum/turbolift/proc/doors_are_open(var/datum/turbolift_floor/use_floor = current_floor)
	for(var/obj/machinery/door/airlock/door in (use_floor ? (doors + use_floor.doors) : doors))
		if(!door.density)
			return 1
	return 0

/datum/turbolift/proc/open_doors(var/datum/turbolift_floor/use_floor = current_floor)
	for(var/obj/machinery/door/airlock/door in (use_floor ? (doors + use_floor.doors) : doors))
		//door.command("open")
		spawn(0)
			door.open()
	return

/datum/turbolift/proc/close_doors(var/datum/turbolift_floor/use_floor = current_floor)
	for(var/obj/machinery/door/airlock/door in (use_floor ? (doors + use_floor.doors) : doors))
		//door.command("close")
		spawn(0)
			door.close()
	return

/datum/turbolift/proc/do_move()

	var/current_floor_index = floors.Find(current_floor)

	if(!target_floor)
		if(!queued_floors || !queued_floors.len)
			return 0
		target_floor = queued_floors[1]
		queued_floors -= target_floor
		if(current_floor_index < floors.Find(target_floor))
			moving_upwards = 1
		else
			moving_upwards = 0
		control_panel_interior.updateDialog()

	if(doors_are_open())
		if(!doors_closing)
			close_doors()
			doors_closing = 1
			return 1
		else // We failed to close the doors - probably, someone is blocking them; stop trying to move
			doors_closing = 0
			if(!fire_mode)
				open_doors()
			control_panel_interior.audible_message("\The [current_floor.ext_panel] buzzes loudly.")
			playsound(control_panel_interior.loc, "sound/machines/buzz-two.ogg", 50, 1)
			return 0

	doors_closing = 0 // The doors weren't open, so they are done closing

	var/area/turbolift/origin = locate(current_floor.area_ref)

	if(target_floor == current_floor)

		playsound(control_panel_interior.loc, origin.arrival_sound, 50, 1)
		target_floor.arrived(src)
		target_floor = null

		sleep(15)
		control_panel_interior.visible_message("<b>The elevator</b> announces, \"[origin.lift_announce_str]\"")
		sleep(floor_wait_delay)

		return 1

	// Work out where we're headed.
	var/datum/turbolift_floor/next_floor
	if(moving_upwards)
		next_floor = floors[current_floor_index+1]
	else
		next_floor = floors[current_floor_index-1]

	var/area/turbolift/destination = locate(next_floor.area_ref)

	if(!istype(origin) || !istype(destination) || (origin == destination))
		return 0

	for(var/turf/T in destination)
		for(var/atom/movable/AM in T)
			if(istype(AM, /mob/living))
				var/mob/living/M = AM
				M.gib()
			else if(istype(AM, /mob/zshadow))
				AM.Destroy()		//prevent deleting shadow without deleting shadow's shadows
			else if(AM.simulated && !(istype(AM, /mob/observer)))
				qdel(AM)

	origin.move_contents_to(destination)

	if((locate(/obj/machinery/power) in destination) || (locate(/obj/structure/cable) in destination))
		SSmachines.makepowernets()

	current_floor = next_floor
	control_panel_interior.visible_message("The elevator [moving_upwards ? "rises" : "descends"] smoothly.")

	return (next_floor.delay_time || move_delay || 30)

/datum/turbolift/proc/queue_move_to(var/datum/turbolift_floor/floor)
	if(!floor || !(floor in floors) || (floor in queued_floors))
		return // STOP PRESSING THE BUTTON.
	floor.pending_move(src)
	queued_floors |= floor
	turbolift_controller.lift_is_moving(src)

// TODO: dummy machine ('lift mechanism') in powered area for functionality/blackout checks.
/datum/turbolift/proc/is_functional()
	return 1
