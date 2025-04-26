// This event sends a few carp after someone hanging around in space, unannounced.

/datum/event2/meta/surprise_carp
	name = "surprise carp"
	departments = list(DEPARTMENT_EVERYONE)
	chaos = 20
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/surprise_carp

/datum/event2/meta/surprise_carp/get_weight()
	return GLOB.metric.count_all_space_mobs() * 50


/datum/event2/event/surprise_carp
	var/mob/living/victim = null

/datum/event2/event/surprise_carp/set_up()
	var/list/potential_victims = list()
	for(var/mob/living/L in player_list)
		if(!(L.z in get_location_z_levels()))
			continue // Not on the right z-level.
		if(L.stat)
			continue // Don't want dead people.
		if(istype(get_turf(L), /turf/space) && istype(get_area(L),/area/space))
			potential_victims += L

	if(potential_victims.len)
		victim = pick(potential_victims)

/datum/event2/event/surprise_carp/start()
	if(!victim)
		log_debug("Failed to find a target for surprise carp attack. Aborting.")
		abort()
		return

	var/number_of_carp = rand(1, 2)
	log_debug("Sending [number_of_carp] carp\s after \the [victim].")
	// Getting off screen tiles is kind of tricky due to potential edge cases that could arise.
	// The method we're gonna do is make a big square around the victim, then
	// subtract a smaller square in the middle for the default vision range.
	var/list/outer_square = get_safe_square(victim, world.view + 3)
	var/list/inner_square = get_safe_square(victim, world.view)

	var/list/donut = outer_square - inner_square
	for(var/T in donut)
		if(!istype(T, /turf/space))
			donut -= T

	for(var/i = 1 to number_of_carp)
		var/turf/spawning_turf = pick(donut)

		if(spawning_turf)
			var/mob/living/simple_mob/animal/space/carp/C = new(spawning_turf)
			// Ask carp to swim onto the victim's screen. The AI will then switch to hostile and try to eat them.
			C.ai_holder?.give_destination(get_turf(victim))
		else
			log_debug("Surprise carp attack failed to find any space turfs offscreen to the victim.")

// Gets suitable spots for carp to spawn, without risk of going off the edge of the map.
// If there is demand for this proc, then it can easily be made independant and moved into one of the helper files.
/datum/event2/event/surprise_carp/proc/get_safe_square(atom/center, radius)
	var/lower_left_x = max(center.x - radius, 1 + TRANSITIONEDGE)
	var/lower_left_y = max(center.y - radius, 1 + TRANSITIONEDGE)

	var/upper_right_x = min(center.x + radius, world.maxx - TRANSITIONEDGE)
	var/upper_right_y = min(center.y + radius, world.maxy - TRANSITIONEDGE)

	var/turf/lower_left = locate(lower_left_x, lower_left_y, victim.z)
	var/turf/upper_right = locate(upper_right_x, upper_right_y, victim.z)

	return block(lower_left, upper_right)
