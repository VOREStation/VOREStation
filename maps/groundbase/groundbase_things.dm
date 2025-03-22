/obj/effect/step_trigger/teleporter/to_mining/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = y ++
	teleport_z = GLOB.map_templates_loaded[Z_NAME_GB_MINING]

/obj/effect/step_trigger/teleporter/from_mining/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = y --
	teleport_z = Z_LEVEL_GB_BOTTOM

/turf/simulated/floor/maglev/Initialize(mapload)
	. = ..()
	shock_area = /area/centcom/terminal/tramfluff

// Shelter Capsule extra restrictions
/datum/map_template/shelter/New()
	..()
	banned_areas += list(/area/groundbase/level3/escapepad)
