/datum/anomaly_placer
	var/static/list/allowed_areas
	var/list/excluded = list(
		/area/crew_quarters,
		/area/shuttle,
		/area/space,
		/area/solar,
		/area/engineering/engine_room,
		/area/maintenance,
		/area/holodeck,
		/area/ai
	)

/datum/anomaly_placer/proc/find_valid_area()
	var/list/possible_areas = get_station_areas(excluded)
	if(!length(possible_areas))
		CRASH("No valid areas for anomaly found.")

	var/area/landing_area = pick(possible_areas)
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
