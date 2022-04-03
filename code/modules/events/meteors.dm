/datum/event/meteor_wave
	startWhen		= 30	// About one minute early warning
	endWhen 		= 60	// Adjusted automatically in tick()
	has_skybox_image = TRUE
	var/alarmWhen   = 30
	var/next_meteor = 40
	var/waves = 1
	var/start_side
	var/next_meteor_lower = 10
	var/next_meteor_upper = 20

/datum/event/meteor_wave/get_skybox_image()
	var/image/res = image('icons/skybox/rockbox.dmi', "rockbox")
	res.color = COLOR_ASTEROID_ROCK
	res.appearance_flags = RESET_COLOR
	return res

/datum/event/meteor_wave/setup()
	waves = (2 + rand(1, severity)) * severity
	start_side = pick(cardinal)
	endWhen = worst_case_end()

/datum/event/meteor_wave/start()
	affecting_z -= global.using_map.underground_levels	// Surface or space levels only, please.
	..()

/datum/event/meteor_wave/announce()
	if(!victim)
		switch(severity)
			if(EVENT_LEVEL_MAJOR)
				command_announcement.Announce("Meteors have been detected on collision course with \the [location_name()].", "Meteor Alert", new_sound = 'sound/AI/meteors.ogg')
			else
				command_announcement.Announce("\The [location_name()] is now in a meteor shower.", "Meteor Alert")

/datum/event/meteor_wave/tick()
	// Begin sending the alarm signals to shield diffusers so the field is already regenerated (if it exists) by the time actual meteors start flying around.
	if(activeFor >= alarmWhen)
		for(var/obj/machinery/shield_diffuser/SD in global.machines)
			if(SD.z in affecting_z)
				SD.meteor_alarm(10)

	if(waves && activeFor >= next_meteor)
		send_wave()

/datum/event/meteor_wave/proc/send_wave()
	var/pick_side = prob(80) ? start_side : (prob(50) ? turn(start_side, 90) : turn(start_side, -90))

	spawn() spawn_meteors(get_wave_size(), get_meteors(), pick_side, pick(affecting_z))
	next_meteor += rand(next_meteor_lower, next_meteor_upper) / severity
	waves--
	endWhen = worst_case_end()

/datum/event/meteor_wave/proc/get_wave_size()
	return severity * rand(2, 3)

/datum/event/meteor_wave/proc/worst_case_end()
	return activeFor + ((30 / severity) * waves) + 10

/datum/event/meteor_wave/end()
	..()
	if(!victim)
		switch(severity)
			if(EVENT_LEVEL_MAJOR)
				command_announcement.Announce("\The [location_name()] has cleared the meteor storm.", "Meteor Alert")
			else
				command_announcement.Announce("\The [location_name()] has cleared the meteor shower", "Meteor Alert")

/datum/event/meteor_wave/proc/get_meteors()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			return meteors_major
		if(EVENT_LEVEL_MODERATE)
			return meteors_moderate
		else
			return meteors_minor

/var/list/meteors_minor = list(
	/obj/effect/meteor/medium     = 80,
	/obj/effect/meteor/dust       = 30,
	/obj/effect/meteor/irradiated = 30,
	/obj/effect/meteor/big        = 30,
	/obj/effect/meteor/flaming    = 10,
	///obj/effect/meteor/golden     = 10,
	///obj/effect/meteor/silver     = 10,
)

/var/list/meteors_moderate = list(
	/obj/effect/meteor/medium     = 80,
	/obj/effect/meteor/big        = 30,
	/obj/effect/meteor/dust       = 30,
	/obj/effect/meteor/irradiated = 30,
	/obj/effect/meteor/flaming    = 10,
	///obj/effect/meteor/golden     = 10,
	///obj/effect/meteor/silver     = 10,
	/obj/effect/meteor/emp        = 10,
)

/var/list/meteors_major = list(
	/obj/effect/meteor/medium     = 80,
	/obj/effect/meteor/big        = 30,
	/obj/effect/meteor/dust       = 30,
	/obj/effect/meteor/irradiated = 30,
	/obj/effect/meteor/emp        = 30,
	/obj/effect/meteor/flaming    = 10,
	///obj/effect/meteor/golden     = 10,
	///obj/effect/meteor/silver     = 10,
	/obj/effect/meteor/tunguska   = 1,
)

// Overmap version
/datum/event/meteor_wave/overmap
	next_meteor_lower = 5
	next_meteor_upper = 10
	next_meteor = 0
	alarmWhen = 0

/datum/event/meteor_wave/overmap/tick()
	if(victim && !victim.is_still() && prob(90)) // Meteors mostly fly in your face
		start_side = victim.fore_dir
	else //Unless you're standing still
		start_side = pick(GLOB.cardinal)
	..()

/datum/event/meteor_wave/overmap/get_wave_size()
	. = ..()
	if(!victim)
		return
	var/skill = victim.get_helm_skill()
	var/speed = victim.get_speed()
	if(skill >= SKILL_PROF)
		. = round(. * 0.5)
	if(victim.is_still()) //Standing still means less shit flies your way
		. = round(. * 0.1)
	if(speed < SHIP_SPEED_SLOW) //Slow and steady
		. = round(. * 0.5)
	if(speed > SHIP_SPEED_FAST) //Sanic stahp
		. *= 2
	
	//Smol ship evasion
	if(victim.vessel_size < SHIP_SIZE_LARGE && speed < SHIP_SPEED_FAST)
		var/skill_needed = SKILL_PROF
		if(speed < SHIP_SPEED_SLOW)
			skill_needed = SKILL_ADEPT
		if(victim.vessel_size < SHIP_SIZE_SMALL)
			skill_needed = skill_needed - 1
		if(skill >= max(skill_needed, victim.skill_needed))
			. = round(. * 0.5)
