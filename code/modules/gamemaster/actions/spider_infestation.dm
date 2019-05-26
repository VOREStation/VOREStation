/datum/gm_action/spider_infestation
	name = "spider infestation"
	departments = list(ROLE_SECURITY, ROLE_MEDICAL, ROLE_EVERYONE)
	chaotic = 30

	var/severity = 1

	var/spawncount = 1

/datum/gm_action/spider_infestation/set_up()
	spawn(rand(600, 6000))
		announce()

	if(prob(40))
		severity = rand(2,3)
	else
		severity = 1

	spawncount = rand(4 * severity, 6 * severity)

/datum/gm_action/spider_infestation/announce()
	command_announcement.Announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", new_sound = 'sound/AI/aliens.ogg')

	if(severity >= 3)
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
	var/security = metric.count_people_in_department(ROLE_SECURITY)
	var/medical = metric.count_people_in_department(ROLE_MEDICAL)
	var/engineering = metric.count_people_in_department(ROLE_ENGINEERING)

	var/assigned_staff = security + round(medical / 2) + round(engineering / 2)

	return 10 + (assigned_staff * 15)
