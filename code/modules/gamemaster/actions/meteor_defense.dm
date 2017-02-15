// This event gives the station an advance warning about meteors, so that they can prepare in various ways.

/datum/gm_action/meteor_defense
	name = "meteor defense"
	departments = list(ROLE_ENGINEERING)
	chaotic = 50
	var/direction = null
	var/dir_text = null
	var/waves = 0

/datum/gm_action/meteor_defense/get_weight()
	var/engineers = metric.count_people_in_department(ROLE_ENGINEERING)
	var/weight = (max(engineers - 1, 0) * 25) // If only one engineer exists, no meteors for now.
	return weight

/datum/gm_action/meteor_defense/set_up()
	direction = pick(cardinal) // alldirs doesn't work with current meteor code unfortunately.
	waves = rand(5, 8)
	switch(direction)
		if(NORTH)
			dir_text = "aft" // For some reason this is needed.
		if(SOUTH)
			dir_text = "fore"
		if(EAST)
			dir_text = "port"
		if(WEST)
			dir_text = "starboard"

/datum/gm_action/meteor_defense/announce()
	var/announcement = "Alert!  Two other asteroids have collided near [station_name()].  Chunks of it are expected to approach from the [dir_text] side.  ETA to arrival is \
	approximately 10 minutes."
	command_announcement.Announce(announcement, "Meteor Alert", new_sound = 'sound/AI/meteors.ogg')

/datum/gm_action/meteor_defense/start()
	..()
	spawn(0)
	//	sleep(5 MINUTES)
		var/announcement = "The incoming debris are expected to approach from the [dir_text] side.  ETA to arrival is approximately 5 minutes."
		command_announcement.Announce(announcement, "Meteor Alert - Update")
	//	sleep(5 MINUTES)
		announcement = "Incoming debris approaches from the [dir_text] side!"
		command_announcement.Announce(announcement, "Meteor Alert - Update")
		while(waves)
			message_admins("[waves] more wave\s of meteors remain.")
			spawn(1) // Dir is reversed because the direction describes where meteors are going, not what side it's gonna hit.
				spawn_meteors(rand(8, 12), meteors_threatening, reverse_dir[direction])
			waves--
			sleep(30 SECONDS)
		announcement = "The colony has cleared the incoming debris."
		command_announcement.Announce(announcement, "Meteor Alert - Update")
		message_admins("Meteor defense event has ended.")