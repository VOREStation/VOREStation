/area
	var/enter_message
	var/exit_message
	var/limit_mob_size = TRUE //If mob size is limited in the area.
	var/block_suit_sensors = FALSE //If mob size is limited in the area.
	var/turf/ceiling_type

	// Size of the area in open turfs, only calculated for indoors areas.
	var/areasize = 0

	var/no_comms = FALSE	//When true, blocks radios from working in the area

/area/Entered(var/atom/movable/AM, oldLoc)
	. = ..()
	if(enter_message && isliving(AM))
		to_chat(AM, enter_message)

/area/Exited(var/atom/movable/AM, newLoc)
	. = ..()
	if(exit_message && isliving(AM))
		to_chat(AM, exit_message)

/area/Initialize(mapload)
	apply_ceiling()
	. = ..()

/area/proc/apply_ceiling()
	if(!ceiling_type)
		return
	for(var/turf/T in contents)
		if(T.outdoors >= 0)
			continue
		if(HasAbove(T.z))
			var/turf/TA = GetAbove(T)
			if(isopenspace(TA))
				TA.ChangeTurf(ceiling_type, TRUE, TRUE, TRUE)

/**
 * Setup an area (with the given name)
 *
 * Sets the area name, sets all status var's to false and adds the area to the sorted area list
 * //NOTE: Virgo does not have a sorted area list.
 */
/area/proc/setup(a_name)
	name = a_name
	power_equip = FALSE
	power_light = FALSE
	power_environ = FALSE
	always_unpowered = FALSE
	update_areasize()

/area/proc/update_areasize()
	if(outdoors)
		return FALSE
	areasize = 0
	for(var/turf/simulated/floor/T in contents)
		areasize++

/proc/rename_area(a, new_name)
	var/area/A = get_area(a)
	var/prevname = "[A.name]"
	set_area_machinery(A, new_name, prevname)
	A.name = new_name
	A.update_areasize()
	return TRUE

/area/proc/power_check()
	if(!requires_power || !apc)
		power_light = 0
		power_equip = 0
		power_environ = 0
	power_change()		// all machines set to current power level, also updates lighting icon
	if(no_spoilers)
		set_spoiler_obfuscation(TRUE)
