// Compile in the map for CI testing if we're testing compileability of all the maps
#ifdef MAP_TEST
#include "sdf_corvette.dmm"
#include "sdf_corvette_wreck.dmm"
#include "sdf_cutter.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/sdf_corvette
	name = "OM Ship - SDF Corvette (new Z)"
	desc = "A small SDF patrol corvette."
	mappath = "maps/offmap_vr/om_ships/sdf_corvette.dmm"
	annihilate = TRUE

/datum/map_template/om_ships/sdf_corvette_wreck
	name = "OM Ship - SDF Corvette Wreck (new Z)"
	desc = "A small SD patrol corvette. It seems to have had a bad day."
	mappath = "maps/offmap_vr/om_ships/sdf_corvette_wreck.dmm"
	annihilate = TRUE

/datum/map_template/om_ships/sdf_corvette
	name = "OM Ship - SDF Cutter (new Z)"
	desc = "A small SDF cutter, outfitted with an ORB/OFD."
	mappath = "maps/offmap_vr/om_ships/sdf_cutter.dmm"
	annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/sdf_corvette
	name = "\improper SDF Corvette"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0

/area/shuttle/sdf_corvette_wreck
	name = "\improper SDF Corvette Wreck"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0

/area/shuttle/sdf_cutter
	name = "\improper SDF Cutter"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/sdf_corvette
	name = "short jump console"
	shuttle_tag = "SDF Corvette"
	req_one_access = list()

/obj/machinery/computer/shuttle_control/explore/sdf_corvette_wreck
	name = "short jump console"
	shuttle_tag = "SDF Corvette Wreck"
	req_one_access = list()

/obj/machinery/computer/shuttle_control/explore/sdf_cutter
	name = "short jump console"
	shuttle_tag = "SDF Cutter"
	req_one_access = list()

// The 'shuttle'
/datum/shuttle/autodock/overmap/sdf_corvette
	name = "SDF Corvette"
	current_location = "omship_spawn_sdf_corvette"
	docking_controller_tag = "sdfc_dock_con"
	shuttle_area = list(/area/shuttle/sdf_corvette)
	defer_initialisation = TRUE
	fuel_consumption = 1
	ceiling_type = /turf/simulated/floor/reinforced/airless

/datum/shuttle/autodock/overmap/sdf_corvette_wreck
	name = "SDF Corvette Wreck"
	current_location = "omship_spawn_sdf_corvette_wreck"
	docking_controller_tag = "sdfc_wreck_dock_con"
	shuttle_area = list(/area/shuttle/sdf_corvette_wreck)
	defer_initialisation = TRUE
	fuel_consumption = 1
	ceiling_type = /turf/simulated/floor/reinforced/airless

/datum/shuttle/autodock/overmap/sdf_cutter
	name = "SDF Cutter"
	current_location = "omship_spawn_sdf_cutter"
	docking_controller_tag = "sdf_cutter_docking"
	shuttle_area = list(/area/shuttle/sdf_corvette)
	defer_initialisation = TRUE
	fuel_consumption = 1
	ceiling_type = /turf/simulated/floor/reinforced/airless

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/sdf_corvette
	name = "SDF Corvette"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_sdf_corvette"
	shuttle_type = /datum/shuttle/autodock/overmap/sdf_corvette

/obj/effect/shuttle_landmark/shuttle_initializer/sdf_corvette_wreck
	name = "SDF Corvette Wreck"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_sdf_corvette_wreck"
	shuttle_type = /datum/shuttle/autodock/overmap/sdf_corvette_wreck

/obj/effect/shuttle_landmark/shuttle_initializer/sdf_cutter
	name = "SDF Cutter"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_sdf_cutter"
	shuttle_type = /datum/shuttle/autodock/overmap/sdf_cutter

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/sdf_corvette
	name = "SDF Corvette"
	scanner_desc = @{"[i]Registration[/i]: SDV Naginata
[i]Class[/i]: Corvette
[i]Transponder[/i]: Transmitting (SDF), non-hostile
[b]Notice[/b]: System Defense Force Vessel, observe minimum distance"}
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "SDF Corvette"

/obj/effect/overmap/visitable/ship/landable/sdf_corvette_wreck
	name = "Wrecked SDF Corvette"
	scanner_desc = @{"[i]Registration[/i]: SDV Bec de Corbin
[i]Class[/i]: Corvette
[i]Transponder[/i]: Not Transmitting
[b]Notice[/b]: Critical Damage Sustained"}
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "SDF Corvette Wreck"
	known = FALSE

/obj/effect/overmap/visitable/ship/landable/sdf_cutter
	name = "SDF Cutter"
	scanner_desc = @{"[i]Registration[/i]: SDV Pike
[i]Class[/i]: Cutter
[i]Transponder[/i]: Transmitting (SDF), non-hostile
[b]Notice[/b]: System Defense Force Vessel, observe minimum distance"}
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "SDF Cutter"
