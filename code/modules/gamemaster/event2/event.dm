// This object holds the code that is needed to execute an event.
// Code for judging whether doing that event is a good idea or not belongs inside its meta event object.


/*

Important: DO NOT `sleep()` in any of the procs here, or the GM will get stuck. Use callbacks insead.
Also please don't use spawn(), but use callbacks instead.

Note that there is an important distinction between an event being ended, and an event being finished.
- Ended is for when the actual event is over, regardless of whether an announcement happened or not.
- Finished is for when both the event itself is over, and it was announced. The event will stop being
processed after it is finished.

For an event to finish, it must have done two things:
- Go through its entire cycle, of start() -> end(), and
- Have the event be announced.
If an event has ended, but the announcement didn't happen, the event will not be finished.
This allows for events that have their announcement happen after the end itself.

*/

//
/datum/event2/event
	var/announced = FALSE	// Is set to TRUE when `announce()` is called by `process()`.
	var/started = FALSE		// Is set to TRUE when `start()` is called by `process()`.
	var/ended = FALSE		// Is set to TRUE when `end()` is called by `process()`.
	var/finished = FALSE	// Is set to TRUE when `ended` and `announced` are TRUE.

	// `world.time`s when this event started, and finished, for bookkeeping.
	var/time_started = null
	var/time_finished = null

	// If these are set, the announcement will be delayed by a random time between the lower and upper bounds.
	// If the upper bound is not defined, then it will use the lower bound instead.
	// Note that this is independant of the event itself, so you can have the announcement happen long after the event ended.
	// This may not work if should_announce() is overrided.
	var/announce_delay_lower_bound = null
	var/announce_delay_upper_bound = null

	// If these are set, the event will be delayed by a random time between the lower and upper bounds.
	// If the upper bound is not defined, then it will use the lower bound instead.
	// This may not work if should_start() is overrided.
	var/start_delay_lower_bound = null
	var/start_delay_upper_bound = null

	// If these are set, the event will automatically end at a random time between the lower and upper bounds.
	// If the upper bound is not defined, then it will use the lower bound instead.
	// This may not work if should_end() is overrided.
	var/length_lower_bound = null
	var/length_upper_bound = null

	// Set automatically, don't touch.
	var/time_to_start = null
	var/time_to_announce = null
	var/time_to_end = null

	// These are also set automatically, and are provided for events to know what RNG decided for the various durations.
	var/start_delay = null
	var/announce_delay = null
	var/length = null

// Returns the name of where the event is taking place.
// In the future this might be handy for off-station events.
/datum/event2/event/proc/location_name()
	return station_name()

// Returns the z-levels that are involved with the event.
// In the future this might be handy for off-station events.
/datum/event2/event/proc/get_location_z_levels(space_only = FALSE)
	. = using_map.station_levels.Copy()
	if(space_only)
		for(var/z_level in .)
			if(is_planet_z_level(z_level))
				. -= z_level


/datum/event2/event/proc/is_planet_z_level(z_level)
	var/datum/planet/P = LAZYACCESS(SSplanets.z_to_planet, z_level)
	if(!istype(P))
		return FALSE
	return TRUE

// Returns a list of empty turfs in the same area.
/datum/event2/event/proc/find_random_turfs(minimum_free_space = 5, list/specific_areas = list(), ignore_occupancy = FALSE)
	var/list/area/grand_list_of_areas = find_random_areas(specific_areas)

	if(!LAZYLEN(grand_list_of_areas))
		return list()

	for(var/list/A as anything in grand_list_of_areas)
		var/list/turfs = list()
		for(var/turf/T in A)
			if(!T.check_density())
				turfs += T

		if(turfs.len < minimum_free_space)
			continue // Not enough free space.
		return turfs

	return list()

/datum/event2/event/proc/find_random_areas(list/specific_areas = list(), ignore_occupancy = FALSE)
	if(!LAZYLEN(specific_areas))
		specific_areas = global.the_station_areas.Copy()

	var/list/area/grand_list_of_areas = get_all_existing_areas_of_types(specific_areas)
	. = list()
	for(var/area/A as anything in shuffle(grand_list_of_areas))
		if(A.flag_check(AREA_FORBID_EVENTS))
			continue
		if(!(A.z in get_location_z_levels()))
			continue
		if(!ignore_occupancy && is_area_occupied(A))
			continue // Occupied.
		. += A


// Starts the event.
/datum/event2/event/proc/execute()
	time_started = world.time

	if(announce_delay_lower_bound)
		announce_delay = rand(announce_delay_lower_bound, announce_delay_upper_bound ? announce_delay_upper_bound : announce_delay_lower_bound)
		time_to_announce = world.time + announce_delay

	if(start_delay_lower_bound)
		start_delay = rand(start_delay_lower_bound, start_delay_upper_bound ? start_delay_upper_bound : start_delay_lower_bound)
		time_to_start = world.time + start_delay

	if(length_lower_bound)
		var/starting_point = time_to_start ? time_to_start : world.time
		length = rand(length_lower_bound, length_upper_bound ? length_upper_bound : length_lower_bound)
		time_to_end = starting_point + length

	set_up()

// Called at the very end of the event's lifecycle, or when aborted.
// Don't override this, use `end()` for cleanup instead.
/datum/event2/event/proc/finish()
	finished = TRUE
	time_finished = world.time

// Called by admins wanting to stop an event immediately.
/datum/event2/event/proc/abort()
	if(!announced)
		announce()
	if(!ended) // `end()` generally has cleanup procs, so call that.
		end()
	finish()

// Called by the GM processer.
/datum/event2/event/process()
	// Handle announcement track.
	if(!announced && should_announce())
		announced = TRUE
		announce()

	// Handle event track.
	if(!started)
		if(should_start())
			started = TRUE
			start()
		else
			wait_tick()

	if(started && !ended)
		if(should_end())
			ended = TRUE
			end()
		else
			event_tick()

	// In order to be finished, the event needs to end, and be announced.
	if(ended && announced)
		finish()

/datum/event2/event/Topic(href, href_list)
	if(..())
		return

	if(!check_rights(R_ADMIN|R_EVENT|R_DEBUG))
		message_admins("[usr] has attempted to manipulate an event without sufficent privilages.")
		return

	if(href_list["abort"])
		abort()
		message_admins("Event '[type]' was aborted by [usr.key].")

	// SSgame_master.interact(usr) // To refresh the UI. // VOREStation Edit - We don't use SSgame_master yet.

/*
 * Procs to Override
 */

// Override this for code to be ran before the event is started.
/datum/event2/event/proc/set_up()

// Called every tick from the GM system, and determines if the announcement should happen.
// Override this for special logic on when it should be announced, e.g. after `ended` is set to TRUE,
// however be aware that the event cannot finish until this returns TRUE at some point.
/datum/event2/event/proc/should_announce()
	if(!time_to_announce)
		return TRUE
	return time_to_announce <= world.time

// Override this for code that alerts the crew that the event is happening in some form, e.g. a centcom announcement or some other message.
// If you want them to not know, you can just not override it.
/datum/event2/event/proc/announce()

// Override for code that runs every few seconds, while the event is waiting for `should_start()` to return TRUE.
// Note that events that have `should_start()` return TRUE at the start will never have this proc called.
/datum/event2/event/proc/wait_tick()

// Called every tick from the GM system, and determines if the event should offically start.
// Override this for special logic on when it should start.
/datum/event2/event/proc/should_start()
	if(!time_to_start)
		return TRUE
	return time_to_start <= world.time

// Override this for code to do the actual event.
/datum/event2/event/proc/start()


// Override for code that runs every few seconds, while the event is waiting for `should_end()` to return TRUE.
// Note that events that have `should_end()` return TRUE at the start will never have this proc called.
/datum/event2/event/proc/event_tick()


// Called every tick from the GM system, and determines if the event should end.
// If this returns TRUE at the very start, then the event ends instantly and `tick()` will never be called.
// Override this for special logic on when it should end, e.g. blob core has to die before event ends.
/datum/event2/event/proc/should_end()
	if(!time_to_end)
		return TRUE
	return time_to_end <= world.time

// Override this for code to run when the event is over, e.g. cleanup.
/datum/event2/event/proc/end()
