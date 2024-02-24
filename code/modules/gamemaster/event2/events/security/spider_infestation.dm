/datum/event2/meta/spider_infestation
	name = "spider infestation"
	event_class = "spiders"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_MEDICAL, DEPARTMENT_EVERYONE)
	chaos = 30
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/spider_infestation

/datum/event2/meta/spider_infestation/weak
	name = "weak spider infestation"
	chaos = 20
	event_type = /datum/event2/event/spider_infestation/weak


/datum/event2/meta/spider_infestation/get_weight()
	. = 10
	. += metric.count_people_in_department(DEPARTMENT_SECURITY) * 20
	. += metric.count_people_in_department(DEPARTMENT_MEDICAL) * 10


// This isn't a /mob_spawning subtype since spiderlings aren't actually mobs.

/datum/event2/event/spider_infestation
	var/spiders_to_spawn = 8
	var/spiderling_to_spawn = /obj/effect/spider/spiderling

/datum/event2/event/spider_infestation/weak
	spiders_to_spawn = 5
	spiderling_to_spawn = /obj/effect/spider/spiderling/stunted



/datum/event2/event/spider_infestation/announce()
	command_announcement.Announce("Unidentified lifesigns detected coming aboard \the [location_name()]. \
	Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", new_sound = 'sound/AI/aliens.ogg')

/datum/event2/event/spider_infestation/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in machines)
		if(!temp_vent.welded && temp_vent.network && (temp_vent.loc.z in get_location_z_levels()))
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent

	while((spiders_to_spawn >= 1) && vents.len)
		var/obj/vent = pick(vents)
		new spiderling_to_spawn(vent.loc)
		log_debug("Spider infestation event spawned a spiderling at [get_area(vent)].")
		vents -= vent
		spiders_to_spawn--
