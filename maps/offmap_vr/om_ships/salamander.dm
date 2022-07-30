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

// Map template for spawning the shuttle
/datum/map_template/om_ships/salamander_wreck
	name = "OM Ship - Salamander Corvette Wreckage"
	desc = "A medium multirole spacecraft, or at least what's left of it."
	mappath = 'salamander_wreck.dmm'
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
	icon_state = "gray-s"
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

/area/shuttle/salamander_wreck
	name = "\improper Wrecked Salamander Cabin"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "gray"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_wreck_engineering
	name = "\improper Wrecked Salamander Engineering"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "yellow"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_wreck_cockpit
	name = "\improper Wrecked Salamander Cockpit"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "blue"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_wreck_q1
	name = "\improper Wrecked Salamander Quarters 1"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "gray-p"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_wreck_q2
	name = "\improper Wrecked Salamander Quarters 2"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "gray-s"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_wreck_galley
	name = "\improper Wrecked Salamander Galley"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "dark-s"
	requires_power = 1
	has_gravity = 0

/area/shuttle/salamander_wreck_head
	name = "\improper Wrecked Salamander Head"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "dark-p"
	requires_power = 1
	has_gravity = 0

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/salamander
	name = "short jump console"
	shuttle_tag = "Salamander"
	req_one_access = list()

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/salamander_wreck
	name = "short jump console"
	shuttle_tag = "Salamander Wreckage"
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
	name = "Salamander-class Corvette"
	scanner_desc = @{"[i]Registration[/i]: ITV Independence
[i]Class[/i]: Corvette
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Multirole independent vessel"}
	vessel_mass = 4500
	vessel_size = SHIP_SIZE_LARGE
	fore_dir = EAST
	shuttle = "Salamander"

// The 'shuttle'
/datum/shuttle/autodock/overmap/salamander_wreck
	name = "Salamander Wreckage"
	current_location = "omship_spawn_salamander_wreck"
	docking_controller_tag = "salamander_docking_wreck"
	shuttle_area = list(/area/shuttle/salamander_wreck,/area/shuttle/salamander_wreck_cockpit,/area/shuttle/salamander_wreck_engineering,/area/shuttle/salamander_wreck_q1,/area/shuttle/salamander_wreck_q2,/area/shuttle/salamander_wreck_galley,/area/shuttle/salamander_wreck_head)
	defer_initialisation = TRUE //We're not loaded until an admin does it
	fuel_consumption = 5
	ceiling_type = /turf/simulated/floor/reinforced/airless

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/salamander_wreck
	name = "ITV Unity"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_salamander_wreck"
	shuttle_type = /datum/shuttle/autodock/overmap/salamander_wreck

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/salamander_wreck
	name = "Wrecked Salamander-class Corvette"
	scanner_desc = @{"[i]Registration[/i]: ITV Unity
[i]Class[/i]: Corvette
[i]Transponder[/i]: Not Transmitting
[b]Notice[/b]: Damage to hull is consistent with intentional scuttling procedures, no distress call logged"}
	vessel_mass = 4500
	vessel_size = SHIP_SIZE_LARGE
	fore_dir = EAST
	shuttle = "Salamander Wreckage"

/obj/item/paper/unity_notice
	name = "hastily-scrawled missive"
	info = {"<i>The writing on this scrap of paper is barely legible. Whoever wrote it was clearly in a hurry.</i><br>\
<br>\
to who(m)ever finds this,<br>\
whatever they tell (told?) you, this kinda job is never worth the pay<br>\
i swear they packed some bullshit amongst the rest of the cargo when we werent looking<br>\
like they wanted us to get caught by port authorities or something!<br>\
so we are bailing on the whole contract, captains orders<br>\
dont bother looking for that 'bullshit' i mentioned, we made sure nobody is gonna find it<br>\
sent it out into the black<br>\
or maybe the sun<br>\
one of the two<br>\
<br>\
stay safe out there and always double check who you sign with<br>\
<br>\
rest of the cargo is covered by insurance anyway, so help yourself/ves i guess<br>\
<br>\
-M"}
