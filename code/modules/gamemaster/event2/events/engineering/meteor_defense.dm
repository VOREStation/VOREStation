// This event gives the station an advance warning about meteors, so that they can prepare in various ways.

/datum/event2/meta/meteor_defense
	name = "meteor defense"
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_CARGO)
	chaos = 50
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_HIGH_IMPACT
	event_class = "meteor defense"
	event_type = /datum/event2/event/meteor_defense

/datum/event2/meta/meteor_defense/get_weight()
	// Engineers count as 20.
	var/engineers = metric.count_people_in_department(DEPARTMENT_ENGINEERING)
	if(engineers < 3) // There -must- be at least three engineers for this to be possible.
		return 0

	. = engineers * 20

	// Cargo and AI/borgs count as 10.
	var/cargo = metric.count_people_with_job(/datum/job/cargo_tech) + metric.count_people_with_job(/datum/job/qm)
	var/bots = metric.count_people_in_department(DEPARTMENT_SYNTHETIC)

	. += (cargo + bots) * 10


/datum/event2/event/meteor_defense
	start_delay_lower_bound = 10 MINUTES
	start_delay_upper_bound = 15 MINUTES
	var/soon_announced = FALSE
	var/direction = null // Actual dir used for which side the meteors come from.
	var/dir_text = null // Direction shown in the announcement.
	var/list/meteor_types = null
	var/waves = null // How many times to send meteors.
	var/last_wave_time = null // world.time of latest wave.
	var/wave_delay = 10 SECONDS
	var/wave_upper_bound = 8 // Max amount of meteors per wave.
	var/wave_lower_bound = 4 // Min amount.

/datum/event2/event/meteor_defense/proc/set_meteor_types()
	meteor_types = meteors_threatening.Copy()

/datum/event2/event/meteor_defense/set_up()
	direction = pick(cardinal) // alldirs doesn't work with current meteor code unfortunately.
	waves = rand(3, 6)
	switch(direction)
		if(NORTH)
			dir_text = "aft" // For some reason this is needed.
		if(SOUTH)
			dir_text = "fore"
		if(EAST)
			dir_text = "port"
		if(WEST)
			dir_text = "starboard"
	set_meteor_types()

/datum/event2/event/meteor_defense/announce()
	var/announcement = "Meteors are expected to approach from the [dir_text] side, in approximately [DisplayTimeText(time_to_start - world.time, 60)]."
	command_announcement.Announce(announcement, "Meteor Alert", new_sound = 'sound/AI/meteors.ogg')

/datum/event2/event/meteor_defense/wait_tick()
	if(!soon_announced)
		if((time_to_start - world.time) <= 5 MINUTES)
			soon_announced = TRUE
			var/announcement = "The incoming meteors are expected to approach from the [dir_text] side.  \
			ETA to arrival is approximately [DisplayTimeText(time_to_start - world.time, 60)]."
			command_announcement.Announce(announcement, "Meteor Alert - Update")

/datum/event2/event/meteor_defense/start()
	command_announcement.Announce("Incoming meteors approach from \the [dir_text] side!", "Meteor Alert - Update")

/datum/event2/event/meteor_defense/event_tick()
	if(world.time > last_wave_time + wave_delay)
		last_wave_time = world.time
		waves--
		message_admins("[waves] more wave\s of meteors remain.")
		// Dir is reversed because the direction describes where meteors are going, not what side it's gonna hit.
		spawn_meteors(rand(wave_upper_bound, wave_lower_bound), meteor_types, reverse_dir[direction])

/datum/event2/event/meteor_defense/should_end()
	return waves <= 0

/datum/event2/event/meteor_defense/end()
	command_announcement.Announce("\The [location_name()] will clear the incoming meteors in a moment.", "Meteor Alert - Update")
