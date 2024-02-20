// This event causes a random window near space to become damaged.
// If that window is not fixed in a certain amount of time,
// that window and nearby windows will shatter, causing a breach.

/datum/event2/meta/window_break
	name = "window break"
	departments = list(DEPARTMENT_ENGINEERING)
	chaos = 10
	reusable = TRUE
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/window_break

/datum/event2/meta/window_break/get_weight()
	return (metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 20) / (times_ran + 1)



/datum/event2/event/window_break
	announce_delay_lower_bound = 10 SECONDS
	announce_delay_upper_bound = 20 SECONDS
	length_lower_bound = 8 MINUTES
	length_upper_bound = 12 MINUTES
	var/turf/chosen_turf_with_windows = null
	var/obj/structure/window/chosen_window = null
	var/list/collateral_windows = list()

/datum/event2/event/window_break/set_up()
	var/list/areas = find_random_areas()
	if(!LAZYLEN(areas))
		log_debug("Window Break event could not find any areas. Aborting.")
		abort()
		return

	while(areas.len)
		var/area/area = pick(areas)
		areas -= area

		for(var/obj/structure/window/W in area.contents)
			if(!is_window_to_space(W))
				continue
			chosen_turf_with_windows = get_turf(W)
			collateral_windows = gather_collateral_windows(W)
			break // Break out of the inner loop.

		if(chosen_turf_with_windows)
			log_debug("Window Break event has chosen turf '[chosen_turf_with_windows.name]' in [chosen_turf_with_windows.loc].")
			break // Then the outer loop.

	if(!chosen_turf_with_windows)
		log_debug("Window Break event could not find a turf with valid windows to break. Aborting.")
		abort()
		return

/datum/event2/event/window_break/announce()
	if(chosen_window)
		command_announcement.Announce("Structural integrity of space-facing windows at \the [get_area(chosen_turf_with_windows)] are failing. \
		Repair of the damaged window is advised. Personnel without EVA suits in the area should leave until repairs are complete.", "Structural Alert")

/datum/event2/event/window_break/start()
	if(!chosen_turf_with_windows)
		return

	for(var/obj/structure/window/W in chosen_turf_with_windows.contents)
		if(W.is_fulltile()) // Full tile windows are simple and can always be used.
			chosen_window = W
			break
		else // Otherwise we only want the window that is on the inside side of the station.
			var/turf/T = get_step(W, W.dir)
			if(T.is_space())
				continue
			if(T.check_density())
				continue
			chosen_window = W
			break

	if(!chosen_window)
		return

	chosen_window.take_damage(chosen_window.maxhealth * 0.8)
	playsound(chosen_window, 'sound/effects/Glasshit.ogg', 100, 1)
	chosen_window.visible_message(span("danger", "\The [chosen_window] suddenly begins to crack!"))

/datum/event2/event/window_break/should_end()
	. = ..()
	if(!.) // If the timer didn't expire, we can still end it early if someone messes up.
		if(!chosen_window || !chosen_window.anchored || chosen_window.health == chosen_window.maxhealth)
			// If the window got deconstructed/moved/etc, immediately end and make the breach happen.
			// Also end early if it was repaired.
			return TRUE

/datum/event2/event/window_break/end()
	// If someone fixed the window, then everything is fine.
	if(chosen_window && chosen_window.anchored && chosen_window.health == chosen_window.maxhealth)
		log_debug("Window Break event ended with window repaired.")
		return

	// Otherwise a bunch of windows shatter.
	chosen_window?.shatter()

	var/windows_to_shatter = min(rand(4, 10), collateral_windows.len)
	for(var/i = 1 to windows_to_shatter)
		var/obj/structure/window/W = collateral_windows[i]
		W?.shatter()

	log_debug("Window Break event ended with [windows_to_shatter] shattered windows and a breach.")

// Checks if a window is adjacent to a space tile, and also that the opposite direction is open.
// This is done to avoid getting caught in corner parts of windows.
/datum/event2/event/window_break/proc/is_window_to_space(obj/structure/window/W)
	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(W, direction)
		if(T.is_space())
			var/turf/opposite_T = get_step(W, GLOB.reverse_dir[direction])
			if(!opposite_T.check_density())
				return TRUE
	return FALSE

//TL;DR: breadth first search for all connected turfs with windows
/datum/event2/event/window_break/proc/gather_collateral_windows(var/obj/structure/window/target_window)
	var/list/turf/frontier_set = list(target_window.loc)
	var/list/obj/structure/window/result_set = list()
	var/list/turf/explored_set = list()

	while(frontier_set.len > 0)
		var/turf/current = frontier_set[1]
		frontier_set -= current
		explored_set += current

		var/contains_windows = 0
		for(var/obj/structure/window/to_add in current.contents)
			contains_windows = 1
			result_set += to_add

		if(contains_windows)
			//add adjacent turfs to be checked for windows as well
			var/turf/neighbor = locate(current.x + 1, current.y, current.z)
			if(!(neighbor in frontier_set) && !(neighbor in explored_set))
				frontier_set += neighbor
			neighbor = locate(current.x - 1, current.y, current.z)
			if(!(neighbor in frontier_set) && !(neighbor in explored_set))
				frontier_set += neighbor
			neighbor = locate(current.x, current.y + 1, current.z)
			if(!(neighbor in frontier_set) && !(neighbor in explored_set))
				frontier_set += neighbor
			neighbor = locate(current.x, current.y - 1, current.z)
			if(!(neighbor in frontier_set) && !(neighbor in explored_set))
				frontier_set += neighbor
	return result_set
