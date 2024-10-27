// Compile in the map for CI testing if we're testing compileability of all the maps
#ifdef MAP_TEST
#include "salamander_trader.dmm"
#endif

// The shuttle's area(s)
/area/shuttle/salamander_trader
	name = "\improper Salamander Trader Cabin"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "gray"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_trader_engineering
	name = "\improper Salamander Trader Engineering"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "yellow"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_trader_cockpit
	name = "\improper Salamander Trader Cockpit"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "blue"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_trader_q1
	name = "\improper Salamander Trader Quarters 1"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "gray-p"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_trader_q2
	name = "\improper Salamander Trader Quarters 2"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "gray-s"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_trader_galley
	name = "\improper Salamander Trader Galley"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "dark-s"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_trader_head
	name = "\improper Salamander Trader Head"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "dark-p"
	requires_power = 1
	has_gravity = 0

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/salamander_trader
	name = "short jump console"
	shuttle_tag = "Salamander Trader"
	req_one_access = list()

// The 'shuttle'
/datum/shuttle/autodock/overmap/salamander_trader
	name = "Salamander Trader"
	current_location = "omship_spawn_salamander_trader"
	docking_controller_tag = "salamander_trader_docking"
	shuttle_area = list(/area/shuttle/salamander_trader,/area/shuttle/salamander_trader_cockpit,/area/shuttle/salamander_trader_engineering,/area/shuttle/salamander_trader_q1,/area/shuttle/salamander_trader_q2,/area/shuttle/salamander_trader_galley,/area/shuttle/salamander_trader_head)
	defer_initialisation = TRUE //We're not loaded until an admin does it
	fuel_consumption = 5
	ceiling_type = /turf/simulated/floor/reinforced/airless

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/salamander_trader
	name = "ITV Freedom"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_salamander_trader"
	shuttle_type = /datum/shuttle/autodock/overmap/salamander_trader

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/salamander_trader
	name = "Salamander-class Corvette"
	scanner_desc = @{"[i]Registration[/i]: ITV Freedom
[i]Class[/i]: Corvette
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Multirole independent vessel"}
	vessel_mass = 4500
	vessel_size = SHIP_SIZE_LARGE
	fore_dir = EAST
	shuttle = "Salamander Trader"
