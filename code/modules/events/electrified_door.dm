/datum/event/electrified_door
	var/obj/machinery/door/airlock/chosen_door
	var/list/area/excluded = list(
		/area/shuttle,
		/area/crew_quarters
	)

/datum/event/electrified_door/setup()
	var/list/area/grand_list_of_areas = get_station_areas(excluded)
	//try 10 times
	for(var/i in 1 to 10)
		var/area/A = pick(grand_list_of_areas)
		var/list/obj/machinery/door/airlock/target_doors = list()
		for(var/obj/machinery/door/airlock/target_door in A.contents)
			target_doors += target_door
		target_doors = shuffle(target_doors)

		for(var/obj/machinery/door/airlock/target_door in target_doors)
			if(!target_door.isElectrified() && target_door.arePowerSystemsOn() && target_door.maxhealth == target_door.health)
				chosen_door = target_door
				return

/datum/event/electrified_door/start()

	if(!chosen_door)
		return
	chosen_door.set_safeties(0)
	if(severity >= EVENT_LEVEL_MODERATE)
		chosen_door.electrify(-1)
	chosen_door.lock()
	chosen_door.health = chosen_door.maxhealth / 6
	chosen_door.aiControlDisabled = 1
	chosen_door.update_icon()
