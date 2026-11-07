GLOBAL_DATUM_INIT(crew_repository, /datum/repository/crew, new)

/datum/repository/crew
	var/list/cache_data

/datum/repository/crew/New()
	cache_data = list()
	..()

/datum/repository/crew/proc/health_data(zLevel)
	var/list/crewmembers = list()
	if(!zLevel)
		return crewmembers

	var/z_level = "[zLevel]"
	var/datum/cache_entry/cache_entry = cache_data[z_level]
	if(!cache_entry)
		cache_entry = new/datum/cache_entry
		cache_data[z_level] = cache_entry

	if(world.time < cache_entry.timestamp)
		return cache_entry.data

	for(var/mob/living/carbon/C in GLOB.mob_list)
		var/turf/pos = get_turf(C)
		var/area/B = pos?.loc //No sensor in Dorm
		if(pos?.z != zLevel || B.flag_check(AREA_BLOCK_SUIT_SENSORS) || is_jammed(C) || is_vore_jammed(C))
			continue

		if(isanimal(C.loc))
			var/mob/living/simple_mob/tf_holder = C.loc
			if(tf_holder.tf_mob_holder == C) //Exclude characters that are TFd into other mobs.
				continue

		var/sensor_level = C.get_sensor_level()
		if(sensor_level <= SUIT_SENSOR_OFF)
			continue

		var/list/crewmemberData = list("dead"=0, "oxy"=-1, "tox"=-1, "fire"=-1, "brute"=-1, "area"="", "x"=-1, "y"=-1, "realZ"=-1, "z"="", "ref" = "\ref[C]")

		crewmemberData["sensor_type"] = sensor_level
		if(ishuman(C))
			var/mob/living/carbon/human/H_mob = C
			crewmemberData["name"] = H_mob.get_authentification_name(if_no_id="Unknown")
			crewmemberData["rank"] = H_mob.get_authentification_rank(if_no_id="Unknown", if_no_job="No Job")
			crewmemberData["assignment"] = H_mob.get_assignment(if_no_id="Unknown", if_no_job="No Job")
		else //non-human carbons just always show up as unknown
			crewmemberData["name"] = "Unknown"
			crewmemberData["rank"] = "No Job"
			crewmemberData["assignment"] = "No Job"

		if(sensor_level >= SUIT_SENSOR_BINARY)
			crewmemberData["dead"] = C.stat == DEAD

		if(sensor_level >= SUIT_SENSOR_VITAL)
			crewmemberData["stat"] = C.stat
			crewmemberData["oxy"] = round(C.getOxyLoss(), 1)
			crewmemberData["tox"] = round(C.getToxLoss(), 1)
			crewmemberData["fire"] = round(C.getFireLoss(), 1)
			crewmemberData["brute"] = round(C.getBruteLoss(), 1)

		if(sensor_level >= SUIT_SENSOR_TRACKING)
			var/area/A = get_area(C)
			crewmemberData["area"] = sanitize(A.get_name())
			crewmemberData["x"] = pos.x
			crewmemberData["y"] = pos.y
			crewmemberData["realZ"] = pos.z
			crewmemberData["z"] = using_map.get_zlevel_name(pos.z)

		crewmembers[++crewmembers.len] = crewmemberData

	crewmembers = sortByKey(crewmembers, "name")
	cache_entry.timestamp = world.time + 5 SECONDS
	cache_entry.data = crewmembers

	return crewmembers
