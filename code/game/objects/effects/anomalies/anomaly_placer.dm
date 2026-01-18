/datum/anomaly_placer
	var/static/list/allowed_areas

/datum/anomaly_placer/proc/find_valid_area()
	if(!allowed_areas)
		generate_allowed_areas()

	if(!length(allowed_areas))
		CRASH("No valid areas for anomaly found.")

	var/area/landing_area = pick(allowed_areas)
	var/list/turf_test = get_area_turfs(landing_area)
	if(!turf_test.len)
		CRASH("Anomaly : No valid turfs found for [landing_area] - [landing_area.type]")

	return landing_area

/datum/anomaly_placer/proc/find_valid_turf(area/target_area)
	var/list/valid_turfs = list()
	for(var/turf/try_turf as anything in get_area_turfs(target_area))
		if(!is_valid_destination(try_turf))
			continue
		valid_turfs += try_turf

	if(!valid_turfs.len)
		CRASH("Dimensional anomaly attempted to reach invalid locaton [target_area]")

	return pick(valid_turfs)

/datum/anomaly_placer/proc/is_valid_destination(turf/tested)
	if(isspace(tested))
		return FALSE
	if(tested.density)
		return FALSE
	if(isopenspace(tested))
		return FALSE
	return TRUE

/datum/anomaly_placer/proc/generate_allowed_areas()
	var/static/list/safe_area_types = list(
		/area/crew_quarters,
		/area/shuttle,
		/area/space,
		/area/solar,
		/area/engineering/engine_room,
		/area/maintenance,
		/area/holodeck,
		/area/ai,
		/area/ai_core_foyer,
		/area/ai_upload_foyer,
		/area/ai_server_room,
		/area/tcommsat
	)

	allowed_areas = get_station_areas(safe_area_types)

	for(var/area/check_area in allowed_areas)
		if(!(check_area.z in using_map.station_levels) || check_area.flag_check(AREA_FORBID_EVENTS))
			allowed_areas.Remove(check_area)
