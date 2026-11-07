/proc/get_station_areas(list/area/excluded_areas)
	var/list/area/grand_list_of_areas = list()
	// Assemble areas that all exists (See DM reference if you are confused about loop labels)
	looping_station_areas:
		for(var/parentpath in GLOB.the_station_areas)
			// Check its not excluded
			for(var/excluded_path in excluded_areas)
				if(ispath(parentpath, excluded_path))
					continue looping_station_areas
			// Otherwise add it and all subtypes that exist on the map to our grand list
			for(var/areapath in typesof(parentpath))
				var/area/A = locate(areapath) // Check if it actually exists
				if(istype(A) && (A.z in using_map.station_levels))
					grand_list_of_areas += A
	return grand_list_of_areas

/** Checks if any living humans are in a given area! */
/proc/is_area_occupied(area/myarea)
	// Testing suggests looping over GLOB.human_mob_list is quicker than looping over area contents
	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if(H.stat >= DEAD) //Conditions for exclusion here, like if disconnected people start blocking it.
			continue
		var/area/A = get_area(H)
		if(A == myarea) //The loc of a turf is the area it is in.
			return 1
	return 0

// Returns a list of area instances, or a subtypes of them, that are mapped in somewhere.
// Avoid feeding it `/area`, as it will likely cause a lot of lag as it evaluates every single area coded in.
/proc/get_all_existing_areas_of_types(list/area_types)
	. = list()
	for(var/area_type in area_types)
		var/list/types = typesof(area_type)
		for(var/T in types)
			// Test for existance.
			var/area/A = locate(T)
			if(!istype(A) || !A.contents.len) // Empty contents list means it's not on the map.
				continue
			. += A

/proc/request_decoration_colors(atom/thing_to_color, pattern)
	switch(pattern)
		if(PATTERN_RANDOM)
			return "#[random_short_color()]"
		if(PATTERN_RAINBOW)
			return get_decoration_color_from_pattern(thing_to_color, PATTERN_DEFAULT, PRIDE_FLAG_COLORS)

	for(var/holiday_key in GLOB.holidays)
		var/datum/holiday/holiday_real = GLOB.holidays[holiday_key]
		if(!holiday_real.holiday_colors)
			continue
		return holiday_real.get_holiday_colors(thing_to_color, pattern)

/// Proc to return colors for recoloring atoms based on a pattern and the position of the atom. Primarily used by holidays
/proc/get_decoration_color_from_pattern(atom/thing_to_color, pattern = PATTERN_DEFAULT, list/colors)
	if(!length(colors))
		return
	switch(pattern)
		if(PATTERN_DEFAULT)
			return colors[(thing_to_color.y % colors.len) + 1]
		if(PATTERN_VERTICAL_STRIPE)
			return colors[(thing_to_color.x % colors.len) + 1]
