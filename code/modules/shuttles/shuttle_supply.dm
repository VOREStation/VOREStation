// Formerly /datum/shuttle/ferry/supply
/datum/shuttle/autodock/ferry/supply
	var/away_location = FERRY_LOCATION_OFFSITE	//the location to hide at while pretending to be in-transit
	var/late_chance = 80
	var/max_late_time = 300
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY
	category = /datum/shuttle/autodock/ferry/supply

/datum/shuttle/autodock/ferry/supply/short_jump(var/obj/effect/shuttle_landmark/destination)
	if(moving_status != SHUTTLE_IDLE)
		return

	if(isnull(location))
		return

	// Set the supply shuttle displays to read out the ETA
	var/datum/signal/S = new()
	S.source = src
	S.data = list("command" = "supply")
	var/datum/radio_frequency/F = radio_controller.return_frequency(1435)
	F.post_signal(src, S)

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)

		make_sounds(HYPERSPACE_WARMUP)
		sleep(5 SECONDS) // so the sound finishes.

		if (moving_status == SHUTTLE_IDLE)
			make_sounds(HYPERSPACE_END)
			return	//someone cancelled the launch

		if (at_station() && forbidden_atoms_check())
			//cancel the launch because of forbidden atoms. announce over supply channel?
			moving_status = SHUTTLE_IDLE
			make_sounds(HYPERSPACE_END)
			return

		if (!at_station())	//at centcom
			SSsupply.buy()

		//We pretend it's a long_jump by making the shuttle stay at centcom for the "in-transit" period.
		var/obj/effect/shuttle_landmark/away_waypoint = get_location_waypoint(away_location)
		moving_status = SHUTTLE_INTRANSIT

		//If we are at the away_landmark then we are just pretending to move, otherwise actually do the move
		if (next_location == away_waypoint)
			attempt_move(away_waypoint)

		//wait ETA here.
		arrive_time = world.time + SSsupply.movetime
		while (world.time <= arrive_time)
			sleep(5)

		if (next_location != away_waypoint)
			//late
			if (prob(late_chance))
				sleep(rand(0,max_late_time))

			attempt_move(destination)

		moving_status = SHUTTLE_IDLE
		make_sounds(HYPERSPACE_END)

		if (!at_station())	//at centcom
			SSsupply.sell()

// returns 1 if the supply shuttle should be prevented from moving because it contains forbidden atoms
/datum/shuttle/autodock/ferry/supply/proc/forbidden_atoms_check()
	if (!at_station())
		return 0	//if badmins want to send mobs or a nuke on the supply shuttle from centcom we don't care

	for(var/area/A in shuttle_area)
		if(SSsupply.forbidden_atoms_check(A))
			return 1

/datum/shuttle/autodock/ferry/supply/proc/at_station()
	return (!location)

//returns 1 if the shuttle is idle and we can still mess with the cargo shopping list
/datum/shuttle/autodock/ferry/supply/proc/idle()
	return (moving_status == SHUTTLE_IDLE)

//returns the ETA in minutes
/datum/shuttle/autodock/ferry/supply/proc/eta_minutes()
	return round((arrive_time - world.time) / (1 MINUTE)) // Floor, so it's an actual timer

// returns the ETA in seconds
/datum/shuttle/autodock/ferry/supply/proc/eta_seconds()
	return round((arrive_time - world.time) / (1 SECOND)) // Floor, so it's an actual timer

//returns the ETA in deciseconds
/datum/shuttle/autodock/ferry/supply/proc/eta_deciseconds()
	return round(arrive_time - world.time)
	