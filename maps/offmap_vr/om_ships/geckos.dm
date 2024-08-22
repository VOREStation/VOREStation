// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "gecko_sh.dmm"
#include "gecko_cr.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/gecko_stationhopper
	name = "OM Ship - Gecko Stationhopper (new Z)"
	desc = "A medium personnel transport shuttle."
	mappath = 'gecko_sh.dmm'
	annihilate = TRUE

/datum/map_template/om_ships/gecko_cargohauler
	name = "OM Ship - Gecko Cargo Hauler (new Z)"
	desc = "A medium supply transport shuttle."
	mappath = 'gecko_cr.dmm'
	annihilate = TRUE

/datum/map_template/om_ships/gecko_cargohauler_wreck
	name = "OM Ship - Wrecked Gecko Cargo Hauler (new Z)"
	desc = "A wrecked medium supply transport shuttle."
	mappath = 'gecko_cr_wreck.dmm'
	annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/gecko_sh
	name = "\improper Gecko Stationhopper"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0

/area/shuttle/gecko_sh_engineering
	name = "\improper Gecko Stationhopper Engineering"
	icon_state = "yellow"
	requires_power = 1
	has_gravity = 0

/area/shuttle/gecko_sh_cockpit
	name = "\improper Gecko Stationhopper Cockpit"
	icon_state = "purple"
	requires_power = 1
	has_gravity = 0

/area/shuttle/gecko_cr
	name = "\improper Gecko Cargo Hauler Bay"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0

/area/shuttle/gecko_cr_engineering
	name = "\improper Gecko Cargo Hauler Aft"
	icon_state = "yellow"
	requires_power = 1
	has_gravity = 0

/area/shuttle/gecko_cr_cockpit
	name = "\improper Gecko Cargo Hauler Fore"
	icon_state = "purple"
	requires_power = 1
	has_gravity = 0

/area/shuttle/gecko_cr_wreck
	name = "\improper Wrecked Gecko Cargo Hauler Bay"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0

/area/shuttle/gecko_cr_engineering_wreck
	name = "\improper Wrecked Gecko Cargo Hauler Aft"
	icon_state = "yellow"
	requires_power = 1
	has_gravity = 0

/area/shuttle/gecko_cr_cockpit_wreck
	name = "\improper Wrecked Gecko Cargo Hauler Fore"
	icon_state = "purple"
	requires_power = 1
	has_gravity = 0

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/gecko_sh
	name = "short jump console"
	shuttle_tag = "Gecko Stationhopper"
	req_one_access = list()

/obj/machinery/computer/shuttle_control/explore/gecko_cr
	name = "short jump console"
	shuttle_tag = "Gecko Cargo Hauler"
	req_one_access = list()

/obj/machinery/computer/shuttle_control/explore/gecko_cr_wreck
	name = "short jump console"
	shuttle_tag = "Wrecked Gecko Cargo Hauler"
	req_one_access = list()

// The 'shuttle'
/datum/shuttle/autodock/overmap/gecko_sh
	name = "Gecko Stationhopper"
	current_location = "omship_spawn_gecko_sh"
	docking_controller_tag = "geck_sh_docking"
	shuttle_area = list(/area/shuttle/gecko_sh,/area/shuttle/gecko_sh_cockpit,/area/shuttle/gecko_sh_engineering)
	defer_initialisation = TRUE //We're not loaded until an admin does it
	fuel_consumption = 7.5
	ceiling_type = /turf/simulated/floor/reinforced/airless

/datum/shuttle/autodock/overmap/gecko_cr
	name = "Gecko Cargo Hauler"
	current_location = "omship_spawn_gecko_cr"
	docking_controller_tag = "geck_cr_docking"
	shuttle_area = list(/area/shuttle/gecko_cr,/area/shuttle/gecko_cr_cockpit,/area/shuttle/gecko_cr_engineering)
	defer_initialisation = TRUE //We're not loaded until an admin does it
	fuel_consumption = 7.5
	ceiling_type = /turf/simulated/floor/reinforced/airless

/datum/shuttle/autodock/overmap/gecko_cr_wreck
	name = "Wrecked Gecko Cargo Hauler"
	current_location = "omship_spawn_gecko_cr_wreck"
	docking_controller_tag = "geck_cr_wreck_docking"
	shuttle_area = list(/area/shuttle/gecko_cr_wreck,/area/shuttle/gecko_cr_cockpit_wreck,/area/shuttle/gecko_cr_engineering_wreck)
	defer_initialisation = TRUE //We're not loaded until an admin does it
	fuel_consumption = 7.5
	ceiling_type = /turf/simulated/floor/reinforced/airless

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/gecko_sh
	name = "ITV Gecko I"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_gecko_sh"
	shuttle_type = /datum/shuttle/autodock/overmap/gecko_sh

/obj/effect/shuttle_landmark/shuttle_initializer/gecko_cr
	name = "ITV Gecko II"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_gecko_cr"
	shuttle_type = /datum/shuttle/autodock/overmap/gecko_cr

/obj/effect/shuttle_landmark/shuttle_initializer/gecko_cr_wreck
	name = "ITV Gecko III"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_gecko_cr_wreck"
	shuttle_type = /datum/shuttle/autodock/overmap/gecko_cr_wreck

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/gecko_sh
	name = "Gecko-class Transport"
	scanner_desc = @{"[i]Registration[/i]: ITV Sticky Fingers
[i]Class[/i]: Medium Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Medium personnel transport vessel"}
	vessel_mass = 6500
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "Gecko Stationhopper"

/obj/effect/overmap/visitable/ship/landable/gecko_cr
	name = "Gecko-class Transport"
	scanner_desc = @{"[i]Registration[/i]: ITV Sticky Business
[i]Class[/i]: Medium Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Medium cargo transport vessel"}
	vessel_mass = 6500
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "Gecko Cargo Hauler"

/obj/effect/overmap/visitable/ship/landable/gecko_cr_wreck
	name = "Wrecked Gecko-class Transport"
	scanner_desc = @{"[i]Registration[/i]: ITV Sticky Situation
[i]Class[/i]: Medium Shuttle
[i]Transponder[/i]: Weakly transmitting (CIV), non-hostile
[b]Notice[/b]: Medium cargo transport vessel, significant damage inflicted"}
	vessel_mass = 6500
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "Wrecked Gecko Cargo Hauler"
	known = FALSE
