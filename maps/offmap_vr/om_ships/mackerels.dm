// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "mackerel_sh.dmm"
#include "mackerel_lc.dmm"
#include "mackerel_lc_wreck.dmm"
#include "mackerel_hc.dmm"
#include "mackerel_hc_skel.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/mackerel_stationhopper
	name = "OM Ship - Mackerel Stationhopper (new Z)"
	desc = "A small personnel transport shuttle."
	mappath = 'mackerel_sh.dmm'
	annihilate = TRUE

/datum/map_template/om_ships/mackerel_lightcargo
	name = "OM Ship - Mackerel Light Cargo (new Z)"
	desc = "A small light cargo transport shuttle."
	mappath = 'mackerel_lc.dmm'
	annihilate = TRUE

/datum/map_template/om_ships/mackerel_heavycargo
	name = "OM Ship - Mackerel Heavy Cargo (new Z)"
	desc = "A small secure cargo transport shuttle."
	mappath = 'mackerel_hc.dmm'
	annihilate = TRUE

/datum/map_template/om_ships/mackerel_heavycargo_skel
	name = "OM Ship - Mackerel Heavy Cargo Spartanized (new Z)"
	desc = "A small heavy cargo transport shuttle."
	mappath = 'mackerel_hc_skel.dmm'
	annihilate = TRUE

/datum/map_template/om_ships/mackerel_lightcargo_wreck
	name = "OM Ship - Mackerel Light Cargo Wreck (new Z)"
	desc = "A small light cargo transport shuttle, struck by... something. Ouch."
	mappath = 'mackerel_lc_wreck.dmm'
	annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/mackerel_sh	
	name = "\improper Mackerel Stationhopper"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0
	
/area/shuttle/mackerel_lc	
	name = "\improper Mackerel Light Cargo"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0
	
/area/shuttle/mackerel_hc	
	name = "\improper Mackerel Heavy Cargo"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0
	
/area/shuttle/mackerel_hc_skel	
	name = "\improper Mackerel Heavy Cargo Spartan"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0
	
/area/shuttle/mackerel_hc_skel_cockpit
	name = "\improper Mackerel Heavy Cargo Cockpit"
	icon_state = "purple"
	requires_power = 1
	has_gravity = 0
	
/area/shuttle/mackerel_hc_skel_eng
	name = "\improper Mackerel Heavy Cargo Engineering"
	icon_state = "yellow"
	requires_power = 1
	has_gravity = 0
	
/area/shuttle/mackerel_lc_wreck	
	name = "\improper Wrecked Mackerel Light Cargo"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/mackerel_sh
	name = "short jump console"
	shuttle_tag = "Mackerel Stationhopper"
	req_one_access = list()

/obj/machinery/computer/shuttle_control/explore/mackerel_lc
	name = "short jump console"
	shuttle_tag = "Mackerel Light Cargo"
	req_one_access = list()

/obj/machinery/computer/shuttle_control/explore/mackerel_lc_wreck
	name = "short jump console"
	shuttle_tag = "Mackerel Light Cargo II"
	req_one_access = list()

/obj/machinery/computer/shuttle_control/explore/mackerel_hc
	name = "short jump console"
	shuttle_tag = "Mackerel Heavy Cargo"
	req_one_access = list()

/obj/machinery/computer/shuttle_control/explore/mackerel_hc_skel
	name = "short jump console"
	shuttle_tag = "Mackerel Heavy Cargo Spartan"
	req_one_access = list()

// The 'shuttle'
/datum/shuttle/autodock/overmap/mackerel_sh
	name = "Mackerel Stationhopper"
	current_location = "omship_spawn_mackerel_sh"
	docking_controller_tag = "mackerel_sh_docking"
	shuttle_area = list(/area/shuttle/mackerel_sh)
	defer_initialisation = TRUE
	fuel_consumption = 1
	ceiling_type = /turf/simulated/floor/reinforced/airless

/datum/shuttle/autodock/overmap/mackerel_lc
	name = "Mackerel Light Cargo"
	current_location = "omship_spawn_mackerel_lc"
	docking_controller_tag = "mackerel_lc_docking"
	shuttle_area = list(/area/shuttle/mackerel_lc)
	defer_initialisation = TRUE
	fuel_consumption = 1
	ceiling_type = /turf/simulated/floor/reinforced/airless

/datum/shuttle/autodock/overmap/mackerel_hc
	name = "Mackerel Heavy Cargo"
	current_location = "omship_spawn_mackerel_hc"
	docking_controller_tag = "mackerel_hc_docking"
	shuttle_area = list(/area/shuttle/mackerel_hc)
	defer_initialisation = TRUE
	fuel_consumption = 1.25 //slightly higher due to the added framework/plating
	ceiling_type = /turf/simulated/floor/reinforced/airless

/datum/shuttle/autodock/overmap/mackerel_hc_skel
	name = "Mackerel Heavy Cargo Spartan"
	current_location = "omship_spawn_mackerel_hc_skel"
	docking_controller_tag = "mackerel_hc_skel_docking"
	shuttle_area = list(/area/shuttle/mackerel_hc_skel,/area/shuttle/mackerel_hc_skel_cockpit,/area/shuttle/mackerel_hc_skel_eng)
	defer_initialisation = TRUE
	fuel_consumption = 1.20 //slightly lower due to the stripped-down internals
	ceiling_type = /turf/simulated/floor/reinforced/airless

/datum/shuttle/autodock/overmap/mackerel_lc_wreck
	name = "Mackerel Light Cargo II"
	current_location = "omship_spawn_mackerel_lc_wreck"
	docking_controller_tag = "mackerel_lc_wreck_docking"
	shuttle_area = list(/area/shuttle/mackerel_lc_wreck)
	defer_initialisation = TRUE
	fuel_consumption = 1
	ceiling_type = /turf/simulated/floor/reinforced/airless

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_sh
	name = "ITV Mackerel I"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_mackerel_sh"
	shuttle_type = /datum/shuttle/autodock/overmap/mackerel_sh

/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_lc
	name = "ITV Mackerel II"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_mackerel_lc"
	shuttle_type = /datum/shuttle/autodock/overmap/mackerel_lc

/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_hc
	name = "ITV Mackerel III"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_mackerel_hc"
	shuttle_type = /datum/shuttle/autodock/overmap/mackerel_hc

/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_hc_skel
	name = "ITV Mackerel IV"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_mackerel_hc_skel"
	shuttle_type = /datum/shuttle/autodock/overmap/mackerel_hc_skel

/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_lc_wreck
	name = "ITV Mackerel II KIA"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_mackerel_lc_wreck"
	shuttle_type = /datum/shuttle/autodock/overmap/mackerel_lc_wreck

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/mackerel_sh
	name = "Mackerel-class Transport"
	scanner_desc = @{"[i]Registration[/i]: ITV Phish Phlake
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"}
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Mackerel Stationhopper"

/obj/effect/overmap/visitable/ship/landable/mackerel_lc
	name = "Mackerel-class Transport"
	scanner_desc = @{"[i]Registration[/i]: ITV Phishy Business
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"}
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Mackerel Light Cargo"

/obj/effect/overmap/visitable/ship/landable/mackerel_hc
	name = "Mackerel-class Transport"
	scanner_desc = @{"[i]Registration[/i]: ITV Phish Pharma
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"}
	vessel_mass = 1500
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Mackerel Heavy Cargo"

/obj/effect/overmap/visitable/ship/landable/mackerel_hc_skel
	name = "Mackerel-class Transport (Spartanized)"
	scanner_desc = @{"[i]Registration[/i]: ITV Phish Pond
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"}
	vessel_mass = 1500
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Mackerel Heavy Cargo Spartan"

/obj/effect/overmap/visitable/ship/landable/mackerel_lc_wreck
	name = "Wrecked Mackerel-class Transport"
	scanner_desc = @{"[i]Registration[/i]: ITV Phish Phood
[i]Class[/i]: Small Shuttle Wreck
[i]Transponder[/i]: Not Transmitting
[b]Notice[/b]: Critical Damage Sustained"}
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Mackerel Light Cargo II"
