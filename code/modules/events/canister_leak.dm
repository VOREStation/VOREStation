//
// This event chooses a random canister on player levels and breaks it, releasing its contents!
// On severity EVENT_LEVEL_MUNDANE or below it checks to make sure nobody is in the area, otherwise... good luck.
//

/datum/event/canister_leak/start()
	// List of all non-destroyed canisters on station levels
	var/list/all_canisters = list()
	for(var/obj/machinery/portable_atmospherics/canister/C in GLOB.machines)
		if(!C.destroyed && (C.z in using_map.station_levels) && C.air_contents.total_moles >= MOLES_CELLSTANDARD)
			all_canisters += C

	for(var/i in 1 to 10)
		var/obj/machinery/portable_atmospherics/canister/C = pick(all_canisters)
		if(severity <= EVENT_LEVEL_MUNDANE && area_is_occupied(get_area(C)))
			log_debug("canister_leak event: Rejecting canister [C] ([C.x],[C.y],[C.z]) because area is occupied")
			continue
		// Okay lets break it
		break_canister(C)
		return

	// If we got to here we failed to find it
	log_debug("canister_leak event: Giving up after too many failures to pick target canister")
	kill()
	return

/datum/event/canister_leak/proc/break_canister(var/obj/machinery/portable_atmospherics/canister/C)
	log_debug("canister_leak event: Canister [C] ([C.x],[C.y],[C.z]) destroyed.")
	C.health = 0
	C.healthcheck()
