/datum/event/hostile_runtime
	var/area/picked_area
	var/list/obj/machinery/door/airlock/target_airlocks = list()
	var/obj/machinery/power/apc/apc

	var/list/excluded = list()

	var/electrify = FALSE
	var/releaseWhen

/datum/event/hostile_runtime/setup()
	var/list/area/affected_areas = get_station_areas(excluded)

	picked_area = pick(affected_areas)
	for(var/obj/machinery/door/airlock/airlock in picked_area)
		if(airlock.isElectrified() && !airlock.arePowerSystemsOn())
			continue
		target_airlocks.Add(airlock)

	if(!picked_area)
		log_game("Hostile Runtime event: No areas was chosen!")
		kill()
		return
	else
		log_game("Hostile Runtime event: [picked_area] as chosen. Locking down.")
		log_and_message_admins("Hostile Runtime event: [picked_area] was picked. Bolting airlocks.")

	announceWhen = rand(75, 105) SECONDS
	releaseWhen = rand(60, 90) SECONDS

	endWhen = releaseWhen+2

/datum/event/hostile_runtime/announce()
	GLOB.global_announcer.autosay("[pick("Gr3y.T1d3 virus","Malignant trojan")] detected in [picked_area]. [severity == EVENT_LEVEL_MODERATE ? "Damage partially mitigated." : ""]", "Firewall Subroutines", DEPARTMENT_ENGINEERING)

/datum/event/hostile_runtime/start()
	switch(severity)
		if(EVENT_LEVEL_MODERATE)
			for(var/obj/machinery/door/airlock/door in target_airlocks)
				if(prob(50))
					door.lock()
					door.aiControlDisabled = TRUE
					if(prob(75))
						door.electrify(-1)
		if(EVENT_LEVEL_MAJOR)
			for(var/obj/machinery/door/airlock/door in target_airlocks)
				door.lock()
				door.aiControlDisabled = TRUE
				door.electrify(-1)

/datum/event/hostile_runtime/tick()
	if(activeFor == releaseWhen)
		if(apc && apc.operating)
			for(var/obj/machinery/light/light in picked_area)
				light.flicker(10)
