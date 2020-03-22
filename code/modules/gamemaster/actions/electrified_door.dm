/datum/gm_action/electrified_door
	name = "airlock short-circuit"
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL)
	chaotic = 10
	var/obj/machinery/door/airlock/chosen_door
	var/area/target_area
	var/list/area/excluded = list(
		/area/submap,
		/area/shuttle,
		/area/crew_quarters
	)

/datum/gm_action/electrified_door/set_up()
	var/list/area/grand_list_of_areas = get_station_areas(excluded)

	severity = pickweight(EVENT_LEVEL_MUNDANE = 10,
		EVENT_LEVEL_MODERATE = 5,
		EVENT_LEVEL_MAJOR = 1
		)

	//try 10 times
	for(var/i in 1 to 10)
		target_area = pick(grand_list_of_areas)
		var/list/obj/machinery/door/airlock/target_doors = list()
		for(var/obj/machinery/door/airlock/target_door in target_area.contents)
			target_doors += target_door
		target_doors = shuffle(target_doors)

		for(var/obj/machinery/door/airlock/target_door in target_doors)
			if(!target_door.isElectrified() && target_door.arePowerSystemsOn() && target_door.maxhealth == target_door.health)
				chosen_door = target_door
				return

/datum/gm_action/electrified_door/start()
	..()
	if(!chosen_door)
		return
	command_announcement.Announce("An electrical issue has been detected in your area, please repair potential electronic overloads.", "Electrical Alert")
	chosen_door.visible_message("<span class='danger'>\The [chosen_door]'s panel sparks!</span>")
	chosen_door.set_safeties(0)
	playsound(get_turf(chosen_door), 'sound/machines/buzz-sigh.ogg', 50, 1)
	if(severity >= EVENT_LEVEL_MODERATE)
		chosen_door.electrify(-1)
		spawn(rand(10 SECONDS, 2 MINUTES))
			if(chosen_door && chosen_door.arePowerSystemsOn() && prob(25 + 25 * severity))
				command_announcement.Announce("Overload has been localized to \the [target_area].", "Electrical Alert")

	if(severity >= EVENT_LEVEL_MAJOR)	// New Major effect. Hydraulic boom.
		spawn()
			chosen_door.visible_message("<span class='warning'>\The [chosen_door] buzzes.</span>")
			playsound(get_turf(chosen_door), 'sound/machines/buzz-sigh.ogg', 50, 1)
			sleep(rand(10 SECONDS, 3 MINUTES))
			if(!chosen_door || !chosen_door.arePowerSystemsOn())
				return
			chosen_door.visible_message("<span class='warning'>\The [chosen_door]'s hydraulics creak.</span>")
			playsound(get_turf(chosen_door), 'sound/machines/airlock_creaking.ogg', 50, 1)
			sleep(rand(30 SECONDS, 10 MINUTES))
			if(!chosen_door || !chosen_door.arePowerSystemsOn())
				return
			chosen_door.visible_message("<span class='danger'>\The [chosen_door] emits a hydraulic shriek!</span>")
			playsound(get_turf(chosen_door), 'sound/machines/airlock.ogg', 80, 1)
			spawn(rand(5 SECONDS, 30 SECONDS))
			if(!chosen_door || !chosen_door.arePowerSystemsOn())
				return
			chosen_door.visible_message("<span class='critical'>\The [chosen_door]'s hydraulics detonate!</span>")
			chosen_door.fragmentate(get_turf(chosen_door), rand(5, 10), rand(3, 5), list(/obj/item/projectile/bullet/pellet/fragment/tank/small))
			explosion(get_turf(chosen_door),-1,-1,2,3)

	chosen_door.lock()
	chosen_door.health = chosen_door.maxhealth / 6
	chosen_door.aiControlDisabled = 1
	chosen_door.update_icon()

/datum/gm_action/electrified_door/get_weight()
	return 10 + (metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 5 + metric.count_people_in_department(DEPARTMENT_MEDICAL) * 10)
