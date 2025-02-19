/obj/effect/step_trigger/teleporter/to_mining/Initialize()
	. = ..()
	teleport_x = src.x
	teleport_y = 2
	teleport_z = Z_LEVEL_SURFACE_MINE

/obj/effect/step_trigger/teleporter/from_mining/Initialize()
	. = ..()
	teleport_x = src.x
	teleport_y = world.maxy - 1
	teleport_z = Z_LEVEL_SURFACE_LOW

/obj/effect/step_trigger/teleporter/to_solars/Initialize()
	. = ..()
	teleport_x = world.maxx - 1
	teleport_y = src.y
	teleport_z = Z_LEVEL_SOLARS

/obj/effect/step_trigger/teleporter/from_solars/Initialize()
	. = ..()
	teleport_x = 2
	teleport_y = src.y
	teleport_z = Z_LEVEL_SURFACE_LOW

/obj/effect/step_trigger/teleporter/wild/Initialize()
	. = ..()

	//If starting on east/west edges.
	if (src.x == 1)
		teleport_x = world.maxx - 1
	else if (src.x == world.maxx)
		teleport_x = 2
	else
		teleport_x = src.x
	//If starting on north/south edges.
	if (src.y == 1)
		teleport_y = world.maxy - 1
	else if (src.y == world.maxy)
		teleport_y = 2
	else
		teleport_y = src.y

/obj/effect/step_trigger/teleporter/to_underdark/Initialize()
	. = ..()
	teleport_x = x
	teleport_y = y
	for(var/z_num in using_map.zlevels)
		var/datum/map_z_level/Z = using_map.zlevels[z_num]
		if(Z.name == "Underdark")
			teleport_z = Z.z

/obj/effect/step_trigger/teleporter/from_underdark/Initialize()
	. = ..()
	teleport_x = x
	teleport_y = y
	for(var/z_num in using_map.zlevels)
		var/datum/map_z_level/Z = using_map.zlevels[z_num]
		if(Z.name == "Mining Outpost")
			teleport_z = Z.z

/obj/effect/step_trigger/teleporter/to_plains/Initialize()
	. = ..()
	teleport_x = src.x
	teleport_y = world.maxy - 1
	teleport_z = Z_LEVEL_PLAINS

/obj/effect/step_trigger/teleporter/from_plains/Initialize()
	. = ..()
	teleport_x = src.x
	teleport_y = 2
	teleport_z = Z_LEVEL_SURFACE_LOW

/obj/effect/step_trigger/teleporter/planetary_fall/virgo3b/find_planet()
	planet = planet_virgo3b

// Our map is small, if the supermatter is ejected lets not have it just blow up somewhere else
/obj/machinery/power/supermatter/touch_map_edge()
	qdel(src)

// Shelter Capsule extra restrictions
/datum/map_template/shelter/New()
	..()
	banned_areas += list(/area/tether/surfacebase/fish_farm, /area/tether/surfacebase/public_garden, /area/tether/surfacebase/tram)
