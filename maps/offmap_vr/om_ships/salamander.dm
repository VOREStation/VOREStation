// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "salamander.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/salamander
	name = "OM Ship - Salamander Corvette"
	desc = "A medium multirole spacecraft."
	mappath = 'salamander.dmm'
	annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/salamander	
	name = "\improper Salamander Cabin"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "gray"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_engineering
	name = "\improper Salamander Engineering"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "yellow"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_cockpit
	name = "\improper Salamander Cockpit"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "blue"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_q1	
	name = "\improper Salamander Quarters 1"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "gray-p"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_q2	
	name = "\improper Salamander Quarters 2"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "gray-p"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_galley	
	name = "\improper Salamander Galley"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "dark-s"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_head	
	name = "\improper Salamander Head"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "dark-p"
	requires_power = 1
	has_gravity = 0

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/salamander
	name = "short jump console"
	shuttle_tag = "Salamander"
	req_one_access = list()

// The 'shuttle'
/datum/shuttle/autodock/overmap/salamander
	name = "Salamander"
	current_location = "omship_spawn_salamander"
	docking_controller_tag = "salamander_docking"
	shuttle_area = list(/area/shuttle/salamander,/area/shuttle/salamander_cockpit,/area/shuttle/salamander_engineering,/area/shuttle/salamander_q1,/area/shuttle/salamander_q2,/area/shuttle/salamander_galley,/area/shuttle/salamander_head)
	defer_initialisation = TRUE //We're not loaded until an admin does it
	fuel_consumption = 5
	ceiling_type = /turf/simulated/floor/reinforced/airless

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/salamander
	name = "ITV Salamander"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_salamander"
	shuttle_type = /datum/shuttle/autodock/overmap/salamander

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/salamander
	scanner_name = "Salamander-class Corvette"
	scanner_desc = @{"[i]Registration[/i]: ITV Independence
[i]Class[/i]: Corvette
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Multirole independent vessel"}
	color = "#00AA00" //green, because money
	vessel_mass = 4500
	vessel_size = SHIP_SIZE_LARGE
	fore_dir = EAST
	shuttle = "Salamander"