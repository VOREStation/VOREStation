/datum/event/escaped_slimes
	announceWhen	= 90
	endWhen			= 90 + 15 + 1
	var/spawncount
	var/list/possible_slimes = list(
		/mob/living/simple_mob/slime/purple,
		/mob/living/simple_mob/slime/orange,
		/mob/living/simple_mob/slime/metal,
		/mob/living/simple_mob/slime/yellow,
		/mob/living/simple_mob/slime/dark_purple,
		/mob/living/simple_mob/slime/silver,
		/mob/living/simple_mob/slime/ruby,
		/mob/living/simple_mob/slime/cerulean,
		/mob/living/simple_mob/slime/red,
		/mob/living/simple_mob/slime/green,
		/mob/living/simple_mob/slime/pink,
		/mob/living/simple_mob/slime/gold,
		/mob/living/simple_mob/slime/oil,
		/mob/living/simple_mob/slime/emerald,
	)


/datum/event/escaped_slimes/setup()
	announceWhen = rand(announceWhen, announceWhen + 60)
	spawncount = rand(2 * severity, 4 * severity)	//spiderlings only have a 50% chance to grow big and strong

/datum/event/escaped_slimes/announce()
	command_announcement.Announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", new_sound = 'sound/AI/aliens.ogg')
	sleep(15)
	command_announcement.Announce("The previously unidentified lifesigns have been identified as escaped slimes from Xenobiology. Secure any exterior access, including ducting and ventilation, taking care to return the slimes to their proper confinement.", "Lifesign Alert")


/datum/event/escaped_slimes/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in machines)
		if(temp_vent.network && temp_vent.loc.z in using_map.station_levels && !is_area_occupied(temp_vent.loc.loc)) //borrowed from spiders event, but it works. Distribute the slimes only in rooms with vents
			vents += temp_vent

	while((spawncount > 0) && vents.len)
		var/obj/vent = pick(vents)
		var/slime_type = pick(possible_slimes)
		new slime_type(vent.loc, 1)
		vents -= vent
		spawncount--
