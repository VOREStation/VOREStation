// This event gives the station an advance warning about meteors, so that they can prepare in various ways.

/datum/event2/meta/meteor_defense/planetary
	name = "meteor defense, planetary"
	event_class = "meteor defense"
	event_type = /datum/event2/event/meteor_defense/planetary
	regions = list(EVENT_REGION_PLANETSURFACE)

/datum/event2/event/meteor_defense/planetary/set_up()
	direction = pick(cardinal)
	waves = rand(3, 6)
	switch(direction)
		if(NORTH)
			dir_text = "south"
		if(SOUTH)
			dir_text = "north"
		if(EAST)
			dir_text = "west"
		if(WEST)
			dir_text = "east"
	set_meteor_types()

/datum/event2/event/meteor_defense/planetary/proc/get_personnel()
	// Engineers count as 20.
	var/engineers = metric.count_people_in_department(DEPARTMENT_ENGINEERING)
	if(engineers < 3) // There -must- be at least three engineers for this to be possible.
		return 0

	. = engineers * 20

	// Cargo and AI/borgs count as 10.
	var/cargo = metric.count_people_with_job(/datum/job/cargo_tech) + metric.count_people_with_job(/datum/job/qm)
	var/bots = metric.count_people_in_department(DEPARTMENT_SYNTHETIC)

	. += (cargo + bots) * 10

/datum/event2/event/meteor_defense/planetary/set_meteor_types()
	var/defense_value = get_personnel()
	if(defense_value >= 120)
		meteor_types = meteors_catastrophic.Copy()
	else if(defense_value >= 80)
		meteor_types = meteors_threatening.Copy()
	else
		meteor_types = meteors_normal.Copy()

/datum/event2/event/meteor_defense/planetary/event_tick()
	if(world.time > last_wave_time + wave_delay)
		last_wave_time = world.time
		waves--
		message_admins("[waves] more wave\s of meteors remain.")
		// Dir is reversed because the direction describes where meteors are going, not what side it's gonna hit.
		spawn_meteors(rand(wave_upper_bound, wave_lower_bound), meteor_types, reverse_dir[direction], pick(2, 3))

/datum/event2/event/meteor_defense/planetary/end()
	command_announcement.Announce("The meteor shower over \the [location_name()] will end momentarily.", "Meteor Alert - Update")
