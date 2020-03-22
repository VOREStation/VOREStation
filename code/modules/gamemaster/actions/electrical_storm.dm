/datum/gm_action/electrical_storm
	name = "electrical storm"
	departments = list(DEPARTMENT_EVERYONE)
	reusable = TRUE
	var/lightsoutAmount	= 1
	var/lightsoutRange	= 25

/datum/gm_action/electrical_storm/announce()
	command_announcement.Announce("An electrical issue has been detected in your area, please repair potential electronic overloads.", "Electrical Alert")

/datum/gm_action/electrical_storm/start()
	..()
	var/list/epicentreList = list()

	for(var/i=1, i <= lightsoutAmount, i++)
		var/list/possibleEpicentres = list()
		for(var/obj/effect/landmark/newEpicentre in landmarks_list)
			if(newEpicentre.name == "lightsout" && !(newEpicentre in epicentreList))
				possibleEpicentres += newEpicentre
		if(possibleEpicentres.len)
			epicentreList += pick(possibleEpicentres)
		else
			break

	if(!epicentreList.len)
		return

	for(var/obj/effect/landmark/epicentre in epicentreList)
		for(var/obj/machinery/power/apc/apc in range(epicentre,lightsoutRange))
			apc.overload_lighting()

/datum/gm_action/electrical_storm/get_weight()
	return 30 + (metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 15) + (metric.count_people_in_department(DEPARTMENT_EVERYONE) * 5)
