// The new arrivals shuttle.
/datum/shuttle/autodock/ferry/arrivals
	category = /datum/shuttle/autodock/ferry/arrivals

	name = "Arrivals"
	location = FERRY_LOCATION_OFFSITE
	warmup_time = 25 // Warmup takes 5 seconds, so 30 total.
	always_process = TRUE
	var/launch_delay = 3

	// Maps must implement their own subtype for their arrivals shuttle, and define at least:
	// shuttle_area
	// landmark_station (Which should define its dock target)
	// landmark_offsite
	// docking_controller_tag

// For debugging.
/obj/machinery/computer/shuttle_control/arrivals
	name = "shuttle control console"
	req_access = list(access_cent_general)
	shuttle_tag = "Arrivals"

// Unlike most shuttles, the arrivals shuttle is completely automated, so we need to put some additional code here.
// Process the arrivals shuttle even when idle.
/obj/machinery/computer/shuttle_control/arrivals/process()
	var/datum/shuttle/autodock/ferry/arrivals/shuttle = SSshuttles.shuttles[shuttle_tag]
	if(shuttle && shuttle.process_state == IDLE_STATE)
		shuttle.process()
	..()

// This proc checks if anyone is on the shuttle.
/datum/shuttle/autodock/ferry/arrivals/proc/check_for_passengers()
	for(var/area/A in shuttle_area)
		for(var/mob/living/L in A)
			return TRUE
	return FALSE

// This is to stop the shuttle if someone tries to stow away when its leaving.
/datum/shuttle/autodock/ferry/arrivals/post_warmup_checks()
	if(!location) // If we're at station.
		if(check_for_passengers())
			return FALSE
	return TRUE

/datum/shuttle/autodock/ferry/arrivals/process()
	if(process_state == IDLE_STATE)

		if(location) // If we're off-station (space).
			if(check_for_passengers()) // No point arriving with an empty shuttle.
				warmup_time = initial(warmup_time)
				launch()
				message_passengers("Arriving at [using_map.station_name] in thirty seconds...")
				spawn(10 SECONDS)
					message_passengers("Arriving at [using_map.station_name] in twenty seconds.")
					spawn(10 SECONDS)
						message_passengers("Arriving at [using_map.station_name] in ten seconds.  Please buckle up.")

		else // We are at the station.
			if(!check_for_passengers()) // Don't leave with anyone.
				if(launch_delay) // Give some time to get on the docks so people don't get trapped inbetween the dock airlocks.
					launch_delay--
				else
					launch_delay = initial(launch_delay)
					warmup_time = 0 // Gotta go fast.
					launch()

	..() // Do everything else

/*
/datum/shuttle/autodock/ferry/arrivals/current_dock_target()
	if(location) // If we're off station.
		return null // Nothing to dock to in space.
	return ..()
*/