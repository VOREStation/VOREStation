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
#define Z_LEVEL_SURFACE_WILD			10

/datum/map/southern_cross
	name = "Southern Cross"
	full_name = "Southern Cross"
	path = "southern_cross"

	lobby_icon = 'icons/misc/title.dmi'
	lobby_screens = list("mockingjay00") // New lobby screen if possible.

	holomap_smoosh = list(list(
		Z_LEVEL_STATION_ONE,
		Z_LEVEL_STATION_TWO,
		Z_LEVEL_STATION_THREE))

	zlevel_datum_type = /datum/map_z_level/southern_cross

	station_name  = "NLS Southern Cross"
	station_short = "Southern Cross"
	dock_name     = "NCS Northern Star" // Now we're the centcom!
	boss_name     = "Central Command"
	boss_short    = "Centcom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Vir"

	shuttle_docked_message = "The scheduled shuttle to the %dock_name% has docked with the station at docks one and two. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Crew Transfer Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	shuttle_called_message = "A crew transfer to %dock_name% has been scheduled. The shuttle has been called. Those leaving should proceed to docks one and two in approximately %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Shuttle has docked with the station at docks one and two. You have approximately %ETD% to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive at docks one and two in approximately %ETA%."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."

	// Networks that will show up as options in the camera monitor program
	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIRCUITS,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_ENGINEERING_OUTPOST,
							NETWORK_FIRST_DECK,
							NETWORK_SECOND_DECK,
							NETWORK_THIRD_DECK,
							NETWORK_MAIN_OUTPOST,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_PRISON,
							NETWORK_SECURITY,
							NETWORK_TELECOM
							)
	// Camera networks that exist, but don't show on regular camera monitors.
	secondary_networks = list(
							NETWORK_ERT,
							NETWORK_MERCENARY,
							NETWORK_THUNDER,
							NETWORK_COMMUNICATORS,
							NETWORK_ALARM_ATMOS,
							NETWORK_ALARM_POWER,
							NETWORK_ALARM_FIRE,
							NETWORK_SUPPLY
							)
	usable_email_tlds = list("freemail.nt")
	allowed_spawns = list("Arrivals Shuttle","Gateway", "Cryogenic Storage", "Cyborg Storage")
	unit_test_exempt_areas = list(/area/ninja_dojo, /area/ninja_dojo/firstdeck, /area/ninja_dojo/arrivals_dock)

	unit_test_exempt_from_atmos = list(/area/tcomm/chamber)

	planet_datums_to_make = list(/datum/planet/sif)


// Short range computers see only the six main levels, others can see the surrounding surface levels.
/datum/map/southern_cross/get_map_levels(var/srcz, var/long_range = TRUE)
	if (long_range && (srcz in map_levels))
		return map_levels
	else if (srcz == Z_LEVEL_TRANSIT)
		return list() // Nothing on these z-levels- sensors won't show, and GPSes won't see each other.
	else if (srcz >= Z_LEVEL_STATION_ONE && srcz <= Z_LEVEL_STATION_THREE) // Station can see other decks.
		return list(
			Z_LEVEL_STATION_ONE,
			Z_LEVEL_STATION_TWO,
			Z_LEVEL_STATION_THREE,
			Z_LEVEL_SURFACE,
			Z_LEVEL_SURFACE_MINE,
			Z_LEVEL_SURFACE_WILD)
	else if(srcz in list(Z_LEVEL_SURFACE, Z_LEVEL_SURFACE_MINE, Z_LEVEL_SURFACE_WILD)) // Being on the surface lets you see other surface Zs.
		return list(
			Z_LEVEL_SURFACE,
			Z_LEVEL_SURFACE_MINE,
			Z_LEVEL_SURFACE_WILD)
	else
		return list(srcz) //prevents runtimes when using CMC. any Z-level not defined above will be 'isolated' and only show to GPSes/CMCs on that same Z (e.g. CentCom).

/datum/map/southern_cross/perform_map_generation()
	// First, place a bunch of submaps. This comes before tunnel/forest generation as to not interfere with the submap.

	// Cave submaps are first.
	seed_submaps(list(Z_LEVEL_SURFACE_MINE), 75, /area/surface/cave/unexplored/normal, /datum/map_template/surface/mountains/normal)
	seed_submaps(list(Z_LEVEL_SURFACE_MINE), 75, /area/surface/cave/unexplored/deep, /datum/map_template/surface/mountains/deep)
	// Plains to make them less plain.
	seed_submaps(list(Z_LEVEL_SURFACE), 100, /area/surface/outside/plains/normal, /datum/map_template/surface/plains) // Center area is WIP until map editing settles down.
	// Wilderness is next.
	seed_submaps(list(Z_LEVEL_SURFACE_WILD), 75, /area/surface/outside/wilderness/normal, /datum/map_template/surface/wilderness/normal)
	seed_submaps(list(Z_LEVEL_SURFACE_WILD), 75, /area/surface/outside/wilderness/deep, /datum/map_template/surface/wilderness/deep)
	// If Space submaps are made, add a line to make them here as well.

	// Now for the tunnels.
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SURFACE_MINE, 64, 64)         // Create the mining ore distribution map.
	// Todo: Forest generation.
	return 1

// For making the 6-in-1 holomap, we calculate some offsets
#define SOUTHERN_CROSS_MAP_SIZE 160 // Width and height of compiled in Southern Cross z levels.
#define SOUTHERN_CROSS_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define SOUTHERN_CROSS_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*SOUTHERN_CROSS_MAP_SIZE) - SOUTHERN_CROSS_HOLOMAP_CENTER_GUTTER) / 2) // 100
#define SOUTHERN_CROSS_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*SOUTHERN_CROSS_MAP_SIZE)) / 2) // 60

/datum/map_z_level/southern_cross/station
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_z_level/southern_cross/station/station_one
	z = Z_LEVEL_STATION_ONE
	name = "Deck 1"
	base_turf = /turf/space
	transit_chance = 6
	holomap_offset_x = SOUTHERN_CROSS_HOLOMAP_MARGIN_X - 40
	holomap_offset_y = SOUTHERN_CROSS_HOLOMAP_MARGIN_Y + SOUTHERN_CROSS_MAP_SIZE*0

/datum/map_z_level/southern_cross/station/station_two
	z = Z_LEVEL_STATION_TWO
	name = "Deck 2"
	base_turf = /turf/simulated/open
	transit_chance = 6
	holomap_offset_x = SOUTHERN_CROSS_HOLOMAP_MARGIN_X - 40
	holomap_offset_y = SOUTHERN_CROSS_HOLOMAP_MARGIN_Y + SOUTHERN_CROSS_MAP_SIZE*1

/datum/map_z_level/southern_cross/station/station_three
	z = Z_LEVEL_STATION_THREE
	name = "Deck 3"
	base_turf = /turf/simulated/open
	transit_chance = 6
	holomap_offset_x = HOLOMAP_ICON_SIZE - SOUTHERN_CROSS_HOLOMAP_MARGIN_X - SOUTHERN_CROSS_MAP_SIZE - 40
	holomap_offset_y = SOUTHERN_CROSS_HOLOMAP_MARGIN_Y + SOUTHERN_CROSS_MAP_SIZE*1

/datum/map_z_level/southern_cross/empty_space
	z = Z_LEVEL_EMPTY_SPACE
	name = "Empty"
	flags = MAP_LEVEL_PLAYER
	transit_chance = 76

/datum/map_z_level/southern_cross/surface
	z = Z_LEVEL_SURFACE
	name = "Plains"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/floor/outdoors/rocks

/datum/map_z_level/southern_cross/surface_mine
	z = Z_LEVEL_SURFACE_MINE
	name = "Mountains"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/floor/outdoors/rocks

/datum/map_z_level/southern_cross/surface_wild
	z = Z_LEVEL_SURFACE_WILD
	name = "Wilderness"
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
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

/obj/effect/step_trigger/teleporter/mine/to_mining/New()
	..()
	teleport_x = src.x
	teleport_y = 2
	teleport_z = Z_LEVEL_SURFACE_MINE

/obj/effect/step_trigger/teleporter/mine/from_mining/New()
	..()
	teleport_x = src.x
	teleport_y = world.maxy - 1
	teleport_z = Z_LEVEL_SURFACE

//Teleport to Wild

/obj/effect/step_trigger/teleporter/wild/to_wild/New()
	..()
	teleport_x = src.x
	teleport_y = 2
	teleport_z = Z_LEVEL_SURFACE_WILD

/obj/effect/step_trigger/teleporter/wild/from_wild/New()
	..()
	teleport_x = src.x
	teleport_y = world.maxy - 1
	teleport_z = Z_LEVEL_SURFACE_MINE

/datum/planet/sif
	expected_z_levels = list(
		Z_LEVEL_SURFACE,
		Z_LEVEL_SURFACE_MINE,
		Z_LEVEL_SURFACE_WILD,
		Z_LEVEL_TRANSIT
	)

/obj/effect/step_trigger/teleporter/bridge/east_to_west/Initialize()
	teleport_x = src.x - 4
	teleport_y = src.y
	teleport_z = src.z
	return ..()

/obj/effect/step_trigger/teleporter/bridge/east_to_west/small/Initialize()
	teleport_x = src.x - 3
	teleport_y = src.y
	teleport_z = src.z
	return ..()

/obj/effect/step_trigger/teleporter/bridge/west_to_east/Initialize()
	teleport_x = src.x + 4
	teleport_y = src.y
	teleport_z = src.z
	return ..()

/obj/effect/step_trigger/teleporter/bridge/west_to_east/small/Initialize()
	teleport_x = src.x + 3
	teleport_y = src.y
	teleport_z = src.z
	return ..()

/obj/effect/step_trigger/teleporter/bridge/north_to_south/Initialize()
	teleport_x = src.x
	teleport_y = src.y - 4
	teleport_z = src.z
	return ..()

/obj/effect/step_trigger/teleporter/bridge/south_to_north/Initialize()
	teleport_x = src.x
	teleport_y = src.y + 4
	teleport_z = src.z
	return ..()

/datum/planet/sif
	expected_z_levels = list(
		Z_LEVEL_SURFACE,
		Z_LEVEL_SURFACE_MINE,
		Z_LEVEL_SURFACE_WILD
	)

//Suit Storage Units

/obj/machinery/suit_cycler/exploration
	name = "Explorer suit cycler"
	model_text = "Exploration"
	req_one_access = list(access_pilot,access_explorer)

/obj/machinery/suit_cycler/pilot
	name = "Pilot suit cycler"
	model_text = "Pilot"
	req_access = null
	req_one_access = list(access_pilot,access_explorer)