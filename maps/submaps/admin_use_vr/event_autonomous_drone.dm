// Compile in the map for CI testing if we're testing compileability of all the maps
#ifdef MAP_TEST
#include "event_autonomous_drone.dmm"
#endif

/datum/map_template/om_ships/event_autonomous_drone
	name = "OM Ship - Cargo Drone"
	desc = "A small cargo hauler"
	mappath = "maps/submaps/admin_use_vr/event_autonomous_drone.dmm"
	annihilate = TRUE

/datum/shuttle/autodock/overmap/event_autonomous_drone
	name = "Autonomous Cargo Drone"
	warmup_time = 0
	current_location = "omship_event_autonomous_drone"
	docking_controller_tag = "event_autonomousdrone_docker"
	shuttle_area = list(/area/submap/event_autonomous_drone/engineering, /area/submap/event_autonomous_drone/cargo,
	/area/submap/event_autonomous_drone/command)
	fuel_consumption = 1 //efficient but slow
	defer_initialisation = TRUE
	move_direction = WEST

/obj/effect/shuttle_landmark/shuttle_initializer/event_autonomous_drone
	name = "Autonomous Cargo Drone"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_event_autonomous_drone"
	shuttle_type = /datum/shuttle/autodock/overmap/event_autonomous_drone

/obj/effect/shuttle_landmark/shuttle_initializer/event_autonomous_drone/Initialize()
	var/obj/effect/overmap/visitable/O = get_overmap_sector(get_z(src)) //make this into general system some other time
	LAZYINITLIST(O.initial_restricted_waypoints)
	O.initial_restricted_waypoints["Autonomous Cargo Drone"] = list(landmark_tag)
	. = ..()

/obj/effect/overmap/visitable/ship/landable/event_autonomous_drone
	name = "TBD"
	scanner_desc = "TBD"
	vessel_mass = 20000 //Slow and bulky cargo boat
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Autonomous Cargo Drone"

/obj/effect/overmap/visitable/ship/landable/event_autonomous_drone/Initialize()
	. = ..()
	var/datum/lore/organization/O = loremaster.organizations[/datum/lore/organization/tsc/nanotrasen]
	var/newname = "NTV [pick(O.ship_names)]"
	name = newname
	scanner_desc = {"\[i\]Registration\[/i\]: [newname]
\[i\]Class\[/i\]: Autonomous Cargo Drone
\[i\]Transponder\[/i\]: Transmitting (CIV), Weak Signal
\[b\]Notice\[/b\]: Reported missing."}
	rename_areas(newname)

/obj/effect/overmap/visitable/ship/landable/event_autonomous_drone/proc/rename_areas(newname)
	if(!SSshuttles.subsystem_initialized)
		spawn(300)
			rename_areas(newname)
		return
	var/datum/shuttle/S = SSshuttles.shuttles[shuttle]
	for(var/area/A in S.shuttle_area)
		A.name = "[newname] [initial(A.name)]"
		if(A.apc)
			A.apc.name = "[A.name] APC"
		A.air_vent_names = list()
		A.air_scrub_names = list()
		A.air_vent_info = list()
		A.air_scrub_info = list()
		for(var/obj/machinery/alarm/AA in A)
			AA.name = "[A.name] Air Alarm"

/obj/machinery/computer/shuttle_control/explore/event_autonomous_drone
	shuttle_tag = "Autonomous Cargo Drone"
	req_one_access = list()

/area/submap/event_autonomous_drone
	secret_name = FALSE

/area/submap/event_autonomous_drone/engineering
	name = "Engine Bay"

/area/submap/event_autonomous_drone/cargo
	name = "Cargo Bay"

/area/submap/event_autonomous_drone/command
	name = "Command Deck"
