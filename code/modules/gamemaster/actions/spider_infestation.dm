/datum/gm_action/spider_infestation
	name = "spider infestation"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_MEDICAL, DEPARTMENT_EVERYONE)
	chaotic = 30

	severity = 1

	var/spawncount = 1

	var/spawntype = /obj/effect/spider/spiderling

/datum/gm_action/spider_infestation/set_up()
	severity = pickweight(EVENT_LEVEL_MUNDANE = max(1,(12 - (3 * metric.count_people_in_department(DEPARTMENT_SECURITY)))),
	EVENT_LEVEL_MODERATE = (7 + (2 * metric.count_people_in_department(DEPARTMENT_SECURITY))),
	EVENT_LEVEL_MAJOR = (1 + (2 * metric.count_people_in_department(DEPARTMENT_SECURITY)))
	)

	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			spawntype = /obj/effect/spider/spiderling/stunted
		if(EVENT_LEVEL_MODERATE)
			spawntype = /obj/effect/spider/spiderling
		if(EVENT_LEVEL_MAJOR)
			spawntype = /obj/effect/spider/spiderling

	spawncount = rand(4 * severity, 6 * severity)

/datum/gm_action/spider_infestation/announce()
	command_announcement.Announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", new_sound = 'sound/AI/aliens.ogg')

	if(severity >= EVENT_LEVEL_MAJOR)
		spawn(rand(600, 3000))
			command_announcement.Announce("Unidentified lifesigns previously detected coming aboard [station_name()] have been classified as a swarm of arachnids. Extreme caution is advised.", "Arachnid Alert")

/datum/gm_action/spider_infestation/start()
	..()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in machines)
		if(!temp_vent.welded && temp_vent.network && temp_vent.loc.z in using_map.station_levels)
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent

	while((spawncount >= 1) && vents.len)
		var/obj/vent = pick(vents)
		new /obj/effect/spider/spiderling(vent.loc)
		vents -= vent
		spawncount--

/datum/gm_action/spider_infestation/get_weight()
	var/security = metric.count_people_in_department(DEPARTMENT_SECURITY)
	var/medical = metric.count_people_in_department(DEPARTMENT_MEDICAL)
	var/engineering = metric.count_people_in_department(DEPARTMENT_ENGINEERING)

	var/assigned_staff = security + round(medical / 2) + round(engineering / 2)

	return 10 + (assigned_staff * 15)
