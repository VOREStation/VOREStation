//Normal map defs
#define Z_LEVEL_SURFACE_LOW					1
#define Z_LEVEL_SURFACE_MID					2
#define Z_LEVEL_SURFACE_HIGH				3
#define Z_LEVEL_TRANSIT						4
#define Z_LEVEL_SPACE_LOW					5
#define Z_LEVEL_SPACE_MID					6
#define Z_LEVEL_SPACE_HIGH					7
#define Z_LEVEL_SURFACE_MINE				8
#define Z_LEVEL_SOLARS						9
#define Z_LEVEL_CENTCOM						10
#define Z_LEVEL_MISC						11
#define Z_LEVEL_SHIPS						12
#define Z_LEVEL_UNDERDARK					13
#define Z_LEVEL_PLAINS						14
#define Z_LEVEL_ALIENSHIP					15
#define Z_LEVEL_BEACH						16
#define Z_LEVEL_BEACH_CAVE					17
#define Z_LEVEL_AEROSTAT					18
#define Z_LEVEL_AEROSTAT_SURFACE			19
#define Z_LEVEL_DEBRISFIELD					20
#define Z_LEVEL_GATEWAY						21

//Camera networks
#define NETWORK_TETHER "Tether"
#define NETWORK_TCOMMS "Telecommunications" //Using different from Polaris one for better name
#define NETWORK_OUTSIDE "Outside"
#define NETWORK_EXPLORATION "Exploration"
#define NETWORK_XENOBIO "Xenobiology"

/datum/map/tether
	name = "Virgo"
	full_name = "NSB Adephagia"
	path = "tether"

	zlevel_datum_type = /datum/map_z_level/tether

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("tether")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'

	holomap_smoosh = list(list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_SPACE_LOW,
		Z_LEVEL_SPACE_MID,
		Z_LEVEL_SPACE_HIGH))

	station_name  = "NSB Adephagia"
	station_short = "Tether"
	dock_name     = "Virgo-3B Colony"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Virgo-Erigone"

	shuttle_docked_message = "The scheduled Orange Line tram to the %dock_name% has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Orange Line tram has left the station. Estimate %ETA% until the tram arrives at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The tram will be arriving shortly. Those departing should proceed to the Orange Line tram station within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The evacuation tram has arrived at the tram station. You have approximately %ETD% to board the tram."
	emergency_shuttle_leaving_dock = "The emergency tram has left the station. Estimate %ETA% until the shuttle arrives at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule tram has been called. It will arrive at the tram station in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation tram has been recalled."

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIRCUITS,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_EXPLORATION,
							//NETWORK_DEFAULT,  //Is this even used for anything? Robots show up here, but they show up in ROBOTS network too,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_OUTSIDE,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_SECURITY,
							NETWORK_TCOMMS,
							NETWORK_TETHER
							)
	secondary_networks = list(
							NETWORK_ERT,
							NETWORK_MERCENARY,
							NETWORK_THUNDER,
							NETWORK_COMMUNICATORS,
							NETWORK_ALARM_ATMOS,
							NETWORK_ALARM_POWER,
							NETWORK_ALARM_FIRE
							)

	bot_patrolling = FALSE

	allowed_spawns = list("Tram Station","Gateway","Cryogenic Storage","Cyborg Storage")
	spawnpoint_died = /datum/spawnpoint/tram
	spawnpoint_left = /datum/spawnpoint/tram
	spawnpoint_stayed = /datum/spawnpoint/cryo

	meteor_strike_areas = list(/area/tether/surfacebase/outside/outside3)
	drop_pod_allowed_z = list(Z_LEVEL_SURFACE_HIGH)


	unit_test_exempt_areas = list(
		/area/tether/surfacebase/outside/outside1,
		/area/tether/elevator,
		/area/vacant/vacant_site,
		/area/vacant/vacant_site/east,
		/area/crew_quarters/sleep/Dorm_1/holo,
		/area/crew_quarters/sleep/Dorm_3/holo,
		/area/crew_quarters/sleep/Dorm_5/holo,
		/area/crew_quarters/sleep/Dorm_7/holo,
		/area/rnd/miscellaneous_lab)	//TFF 31/8/19 - exempt new construction site from unit tests
	//TFF 11/12/19 - Minor refactor, makes mice spawn only in Atmos.
	unit_test_exempt_from_atmos = list(
		/area/engineering/atmos_intake, // Outside,
		/area/rnd/external, //  Outside,
		/area/tether/surfacebase/mining_main/external, // Outside,
		/area/tether/surfacebase/mining_main/airlock, //  Its an airlock,
		/area/tether/surfacebase/emergency_storage/rnd,
		/area/tether/surfacebase/emergency_storage/atrium)

	lateload_z_levels = list(
		list("Tether - Misc","Tether - Ships","Tether - Underdark","Tether - Plains"), //Stock Tether lateload maps
		list("Alien Ship - Z1 Ship"),
		list("Desert Planet - Z1 Beach","Desert Planet - Z2 Cave"),
		list("Remmi Aerostat - Z1 Aerostat","Remmi Aerostat - Z2 Surface"),
		list("Debris Field - Z1 Space")
		)

	lateload_single_pick = list(
		//list("Snow Outpost"),		// Unplayable mapgen,
		//list("Zoo"),				// Too big. way, way too big
		list("Carp Farm"),
		list("Snow Field"),
		list("Listening Post")
		)

	ai_shell_restricted = TRUE
	ai_shell_allowed_levels = list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_TRANSIT,
		Z_LEVEL_SPACE_LOW,
		Z_LEVEL_SPACE_MID,
		Z_LEVEL_SPACE_HIGH,
		Z_LEVEL_SURFACE_MINE,
		Z_LEVEL_SOLARS,
		Z_LEVEL_CENTCOM,
		Z_LEVEL_MISC,
		Z_LEVEL_SHIPS,
		Z_LEVEL_BEACH
		)

	lateload_single_pick = null //Nothing right now.

/datum/map/tether/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SURFACE_MINE, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SOLARS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SOLARS, 64, 64)         // Create the mining ore distribution map.

	return 1

/datum/planet/virgo3b
	expected_z_levels = list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_SURFACE_MINE,
		Z_LEVEL_SOLARS,
		Z_LEVEL_PLAINS
	)

// Short range computers see only the six main levels, others can see the surrounding surface levels.
/datum/map/tether/get_map_levels(var/srcz, var/long_range = TRUE)
	if (long_range && (srcz in map_levels))
		return map_levels
	else if (srcz == Z_LEVEL_MISC || srcz == Z_LEVEL_SHIPS) //technical levels
		return list() // Nothing on these z-levels- sensors won't show, and GPSes won't see each other.
	else if (srcz >= Z_LEVEL_SURFACE_LOW && srcz <= Z_LEVEL_SOLARS) //Zs 1-3, 5-9, Z4 will return same list, but is not included into it
		return list(
			Z_LEVEL_SURFACE_LOW,
			Z_LEVEL_SURFACE_MID,
			Z_LEVEL_SURFACE_HIGH,
			Z_LEVEL_SPACE_LOW,
			Z_LEVEL_SPACE_MID,
			Z_LEVEL_SPACE_HIGH,
			Z_LEVEL_SURFACE_MINE,
			Z_LEVEL_SOLARS)
	else if(srcz >= Z_LEVEL_BEACH && srcz <= Z_LEVEL_BEACH_CAVE) //Zs 16-17
		return list(
			Z_LEVEL_BEACH,
			Z_LEVEL_BEACH_CAVE)
	else if(srcz >= Z_LEVEL_AEROSTAT && srcz <= Z_LEVEL_AEROSTAT_SURFACE) //Zs 18-19
		return list(
			Z_LEVEL_AEROSTAT,
			Z_LEVEL_AEROSTAT_SURFACE)
	else
		return list(srcz) //prevents runtimes when using CMC. any Z-level not defined above will be 'isolated' and only show to GPSes/CMCs on that same Z (e.g. CentCom).

// For making the 6-in-1 holomap, we calculate some offsets
#define TETHER_MAP_SIZE 140 // Width and height of compiled in tether z levels.
#define TETHER_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define TETHER_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*TETHER_MAP_SIZE) - TETHER_HOLOMAP_CENTER_GUTTER) / 2) // 100
#define TETHER_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*TETHER_MAP_SIZE)) / 2) // 60

// We have a bunch of stuff common to the station z levels
/datum/map_z_level/tether/station
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_z_level/tether/station/surface_low
	z = Z_LEVEL_SURFACE_LOW
	name = "Surface 1"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0

/datum/map_z_level/tether/station/surface_mid
	z = Z_LEVEL_SURFACE_MID
	name = "Surface 2"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*1

/datum/map_z_level/tether/station/surface_high
	z = Z_LEVEL_SURFACE_HIGH
	name = "Surface 3"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*2

/datum/map_z_level/tether/transit
	z = Z_LEVEL_TRANSIT
	name = "Transit"
	flags = MAP_LEVEL_SEALED|MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_z_level/tether/station/space_low
	z = Z_LEVEL_SPACE_LOW
	name = "Asteroid 1"
	base_turf = /turf/space
	transit_chance = 33
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0

/datum/map_z_level/tether/station/space_mid
	z = Z_LEVEL_SPACE_MID
	name = "Asteroid 2"
	base_turf = /turf/simulated/open
	transit_chance = 33
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*1

/datum/map_z_level/tether/station/space_high
	z = Z_LEVEL_SPACE_HIGH
	name = "Asteroid 3"
	base_turf = /turf/simulated/open
	transit_chance = 33
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*2

/datum/map_z_level/tether/mine
	z = Z_LEVEL_SURFACE_MINE
	name = "Mining Outpost"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b

/datum/map_z_level/tether/solars
	z = Z_LEVEL_SOLARS
	name = "Solar Field"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b

/datum/map_z_level/tether/colony
	z = Z_LEVEL_CENTCOM
	name = "Colony"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_z_level/tether/misc
	z = Z_LEVEL_MISC
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_XENOARCH_EXEMPT

/*
/datum/map_z_level/tether/wilderness
	name = "Wilderness"
	flags = MAP_LEVEL_PLAYER
	var/activated = 0
	var/list/frozen_mobs = list()

/datum/map_z_level/tether/wilderness/proc/activate_mobs()
	if(activated && isemptylist(frozen_mobs))
		return
	activated = 1
	for(var/mob/living/simple_mob/M in frozen_mobs)
		M.life_disabled = 0
		frozen_mobs -= M
	frozen_mobs.Cut()

/datum/map_z_level/tether/wilderness/wild_1
	z = Z_LEVEL_SURFACE_WILDERNESS_1

/datum/map_z_level/tether/wilderness/wild_2
	z = Z_LEVEL_SURFACE_WILDERNESS_2

/datum/map_z_level/tether/wilderness/wild_3
	z = Z_LEVEL_SURFACE_WILDERNESS_3

/datum/map_z_level/tether/wilderness/wild_4
	z = Z_LEVEL_SURFACE_WILDERNESS_4

/datum/map_z_level/tether/wilderness/wild_5
	z = Z_LEVEL_SURFACE_WILDERNESS_5

/datum/map_z_level/tether/wilderness/wild_6
	z = Z_LEVEL_SURFACE_WILDERNESS_6

/datum/map_z_level/tether/wilderness/wild_crash
	z = Z_LEVEL_SURFACE_WILDERNESS_CRASH

/datum/map_z_level/tether/wilderness/wild_ruins
	z = Z_LEVEL_SURFACE_WILDERNESS_RUINS
*/
