/datum/event/grub_infestation
	announceWhen	= 90
	var/spawncount = 1


/datum/event/grub_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 60)
	spawncount = rand(4 * severity, 6 * severity)	//grub larva only have a 50% chance to grow big and strong
	sent_spiders_to_station = 0

/datum/event/grub_infestation/announce()
	command_announcement.Announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", new_sound = 'sound/AI/aliens.ogg')


/datum/event/grub_infestation/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in world)
		if(!temp_vent.welded && temp_vent.network && temp_vent.loc.z in using_map.station_levels)
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent

	while((spawncount >= 1) && vents.len)
		var/obj/vent = pick(vents)
		new /obj/effect/spider/spiderling/grub(vent.loc)
		vents -= vent
		spawncount--
