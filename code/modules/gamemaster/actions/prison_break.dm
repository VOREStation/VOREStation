/datum/gm_action/prison_break
	name = "prison break"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_SYNTHETIC)

	var/start_time = 0
	var/active = FALSE					// Are we doing stuff?
	var/releaseWhen = 60				// The delay for the breakout to occur.
	var/list/area/areas = list()		// List of areas to affect. Filled by start()

	var/eventDept = "Security"			// Department name in announcement
	var/list/areaName = list("Brig")	// Names of areas mentioned in AI and Engineering announcements
	var/list/areaType = list(/area/security/prison, /area/security/brig)	// Area types to include.
	var/list/areaNotType = list()		// Area types to specifically exclude.

/datum/gm_action/prison_break/get_weight()
	var/afflicted_staff = 0
	var/assigned_staff = metric.count_people_in_department(DEPARTMENT_ENGINEERING)
	for(var/department in departments)
		afflicted_staff += round(metric.count_people_in_department(department) / 2)

	var/weight = 20 + (assigned_staff * 10)

	if(assigned_staff)
		weight += afflicted_staff

	return weight

/datum/gm_action/prison_break/virology
	name = "virology breakout"
	departments = list(DEPARTMENT_MEDICAL, DEPARTMENT_SYNTHETIC)
	eventDept = "Medical"
	areaName = list("Virology")
	areaType = list(/area/medical/virology, /area/medical/virologyaccess)

/datum/gm_action/prison_break/xenobiology
	name = "xenobiology breakout"
	departments = list(DEPARTMENT_RESEARCH, DEPARTMENT_SYNTHETIC)
	eventDept = "Science"
	areaName = list("Xenobiology")
	areaType = list(/area/rnd/xenobiology)
	areaNotType = list(/area/rnd/xenobiology/xenoflora, /area/rnd/xenobiology/xenoflora_storage)

/datum/gm_action/prison_break/station
	name = "station-wide breakout"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_MEDICAL, DEPARTMENT_RESEARCH, DEPARTMENT_SYNTHETIC)
	eventDept = "Station"
	areaName = list("Brig","Virology","Xenobiology")
	areaType = list(/area/security/prison, /area/security/brig, /area/medical/virology, /area/medical/virologyaccess, /area/rnd/xenobiology)
	areaNotType = list(/area/rnd/xenobiology/xenoflora, /area/rnd/xenobiology/xenoflora_storage)

/datum/gm_action/prison_break/set_up()
	releaseWhen = rand(60, 90)
	start_time = world.time
	active = TRUE
	length = releaseWhen + 1 SECOND

/datum/gm_action/prison_break/announce()
	if(areas && areas.len > 0)
		command_announcement.Announce("[pick("Gr3y.T1d3 virus","Malignant trojan")] detected in [station_name()] [(eventDept == "Security")? "imprisonment":"containment"] subroutines. Secure any compromised areas immediately. Station AI involvement is recommended.", "[eventDept] Alert")

/datum/gm_action/prison_break/start()
	..()
	for(var/area/A in all_areas)
		if(is_type_in_list(A,areaType) && !is_type_in_list(A,areaNotType))
			areas += A

	if(areas && areas.len > 0)
		var/my_department = "[station_name()] firewall subroutines"
		var/rc_message = "An unknown malicious program has been detected in the [english_list(areaName)] lighting and airlock control systems at [stationtime2text()]. Systems will be fully compromised within approximately three minutes. Direct intervention is required immediately.<br>"
		for(var/obj/machinery/message_server/MS in machines)
			MS.send_rc_message("Engineering", my_department, rc_message, "", "", 2)
		for(var/mob/living/silicon/ai/A in player_list)
			to_chat(A, "<span class='danger'>Malicious program detected in the [english_list(areaName)] lighting and airlock control systems by [my_department].</span>")

	else
		to_world_log("ERROR: Could not initate grey-tide. Unable to find suitable containment area.")

	if(areas && areas.len > 0)
		spawn()
			while(active)
				sleep(1)
				if(world.time >= releaseWhen + start_time)
					var/obj/machinery/power/apc/theAPC = null
					for(var/area/A in areas)
						theAPC = A.get_apc()
						if(theAPC.operating)	//If the apc's off, it's a little hard to overload the lights.
							for(var/obj/machinery/light/L in A)
								L.flicker(10)

/datum/gm_action/prison_break/end()
	active = FALSE
	for(var/area/A in shuffle(areas))
		A.prison_break()
