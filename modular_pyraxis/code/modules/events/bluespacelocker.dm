/datum/event/bluespace_locker
	var/obj/structure/closet/entry_point
	var/obj/structure/closet/exit_point
	var/list/area/excluded = list(
		/area/shuttle,
		/area/crew_quarters,
		/area/construction,
		/area/rnd/test_area,
		/area/solar
	)
	var/list/area/pickable_areas

/datum/event/bluespace_locker/setup()
	pickable_areas = get_station_areas(excluded)

	for(var/i in 1 to 15)
		if(entry_point)
			continue
		entry_point = pick_locker(pickable_areas)
	for(var/i in 1 to 15)
		if(exit_point)
			continue
		exit_point = pick_locker(pickable_areas, TRUE, TRUE)

	if(entry_point && exit_point)
		announceWhen = rand(10 SECONDS, 2 MINUTES)
		endWhen = announceWhen + 1
		return TRUE

	log_game("Bluespace Locker Event: Giving up after too many failures to pick valid candidates.")
	kill()
	return

/datum/event/bluespace_locker/proc/pick_locker(var/list/areas, var/crates = FALSE, var/sealed = FALSE)
	var/area/picked_area = pick(areas)
	var/list/obj/structure/closet/valid_lockers = list()

	for(var/obj/structure/closet/closet in picked_area)
		if((istype(closet, /obj/structure/closet/crate) && crates) || (istype(closet, /obj/structure/closet/walllocker) && crates))
			continue
		if(!closet.can_open() && sealed)
			continue
		valid_lockers.Add(closet)
		pickable_areas.Remove(picked_area)

	if(!isemptylist(valid_lockers))
		return pick(valid_lockers)
	return FALSE

/datum/event/bluespace_locker/start()
	if(!entry_point || !exit_point)
		return

	entry_point.AddComponent(/datum/component/bluespace_connection, list(exit_point))
	exit_point.AddComponent(/datum/component/bluespace_connection, list(entry_point))

	log_and_message_admins("Bluespace lockers linked. Entry: [get_area(entry_point)] Exit: [get_area(exit_point)]")

/datum/event/bluespace_locker/announce()
	GLOB.command_announcement.Announce("Bluespace anomaly detected near [station_name()]. Possible location, [get_area(pick(entry_point, exit_point))].", "Anomaly Alert")
