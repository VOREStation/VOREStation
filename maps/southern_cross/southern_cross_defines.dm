// To be filled out when more progress on the new map occurs.

#define Z_LEVEL_STATION_ONE				1
#define Z_LEVEL_STATION_TWO				2
#define Z_LEVEL_STATION_THREE			3
#define Z_LEVEL_EMPTY_SPACE				4
#define Z_LEVEL_SURFACE					5
#define Z_LEVEL_SURFACE_MINE			6
#define Z_LEVEL_MISC					7
#define Z_LEVEL_CENTCOM					8
#define Z_LEVEL_TRANSIT					9

/datum/map/southern_cross
	name = "Southern Cross"
	full_name = "Southern Cross"
	path = "southern_cross"

	lobby_icon = 'icons/misc/title.dmi'
	lobby_screens = list("mockingjay00") // New lobby screen if possible.

	zlevel_datum_type = /datum/map_z_level/southern_cross

	station_name  = "Southern Cross"
	station_short = "Southern Cross"
	dock_name     = "NCS Northern Star" // Now we're the centcom!
	boss_name     = "Central Command"
	boss_short    = "Centcom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Vir"

	shuttle_docked_message = "The scheduled shuttle to the %dock_name% has docked with the station at docks one and two. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Crew Transfer Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	shuttle_called_message = "A crew transfer to %Dock_name% has been scheduled. The shuttle has been called. Those leaving should procede to docks one and two in approximately %ETA%"
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Shuttle has docked with the station at docks one and two. You have approximately %ETD% to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive at docks one and two in approximately %ETA%"
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."

	station_networks = list()

	allowed_spawns = list("Arrivals Shuttle","Gateway", "Cryogenic Storage", "Cyborg Storage")

// Short range computers see only the six main levels, others can see the surrounding surface levels.
/datum/map/southern_cross/get_map_levels(var/srcz, var/long_range = TRUE)
	if (long_range && (srcz in map_levels))
		return map_levels
	else if (srcz == Z_LEVEL_TRANSIT)
		return list() // Nothing on transit!
	else if (srcz >= Z_LEVEL_STATION_ONE && srcz <= Z_LEVEL_STATION_THREE)
		return list(
			Z_LEVEL_STATION_ONE,
			Z_LEVEL_STATION_TWO,
			Z_LEVEL_STATION_THREE)
	else
		return ..()

/datum/map/northern_star/perform_map_generation()
	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SURFACE_MINE, 64, 64)         // Create the mining ore distribution map.
	return 1

/datum/map_z_level/southern_cross/station
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES

/datum/map_z_level/southern_cross/station/station_one
	z = Z_LEVEL_STATION_ONE
	name = "Deck 1"
	base_turf = /turf/space
	transit_chance = 6

/datum/map_z_level/southern_cross/station/station_two
	z = Z_LEVEL_STATION_TWO
	name = "Deck 2"
	base_turf = /turf/simulated/open
	transit_chance = 6

/datum/map_z_level/southern_cross/station/station_three
	z = Z_LEVEL_STATION_THREE
	name = "Deck 3"
	base_turf = /turf/simulated/open
	transit_chance = 6

/datum/map_z_level/southern_cross/empty_space
	z = Z_LEVEL_EMPTY_SPACE
	name = "Empty"
	flags = MAP_LEVEL_PLAYER
	transit_chance = 76

/datum/map_z_level/southern_cross/surface
	z = Z_LEVEL_SURFACE
	name = "Planet"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/floor/outdoors/rocks

/datum/map_z_level/southern_cross/surface_mine
	z = Z_LEVEL_SURFACE_MINE
	name = "Planet"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/floor/outdoors/rocks

/datum/map_z_level/southern_cross/misc
	z = Z_LEVEL_MISC
	name = "Misc"
	flags = MAP_LEVEL_PLAYER
	transit_chance = 6

/datum/map_z_level/southern_cross/centcom
	z = Z_LEVEL_CENTCOM
	name = "Centcom"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT

/datum/map_z_level/southern_cross/transit
	z = Z_LEVEL_TRANSIT
	name = "Transit"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT

//Teleport to Mine

/obj/effect/step_trigger/teleporter/to_mining/New()
	..()
	teleport_x = src.x
	teleport_y = 2
	teleport_z = Z_LEVEL_SURFACE_MINE

/obj/effect/step_trigger/teleporter/from_mining/New()
	..()
	teleport_x = src.x
	teleport_y = world.maxy - 1
	teleport_z = Z_LEVEL_SURFACE