
#define Z_LEVEL_MAIN_NORTHERN_STAR					1
#define Z_LEVEL_CENTCOM_NORTHERN_STAR				2
#define Z_LEVEL_TELECOMMS_NORTHERN_STAR				3
#define Z_LEVEL_ABANDONED_ASTEROID_NORTHERN_STAR	4
#define Z_LEVEL_MINING_NORTHERN_STAR				5
#define Z_LEVEL_EMPTY_NORTHERN_STAR					6

/datum/map/northern_star
	name = "Northern Star"
	full_name = "NCS Northern Star"
	path = "northern_star"

	lobby_icon = 'icons/misc/title.dmi'
	lobby_screens = list("mockingjay00")

	station_levels = list(
		Z_LEVEL_MAIN_NORTHERN_STAR,
		Z_LEVEL_MINING_NORTHERN_STAR
		)

	admin_levels = list(Z_LEVEL_CENTCOM_NORTHERN_STAR)
	contact_levels = list(
		Z_LEVEL_MAIN_NORTHERN_STAR,
		Z_LEVEL_CENTCOM_NORTHERN_STAR,
		Z_LEVEL_MINING_NORTHERN_STAR
		)

	player_levels = list(
		Z_LEVEL_MAIN_NORTHERN_STAR,
		Z_LEVEL_TELECOMMS_NORTHERN_STAR,
		Z_LEVEL_ABANDONED_ASTEROID_NORTHERN_STAR,
		Z_LEVEL_MINING_NORTHERN_STAR,
		Z_LEVEL_EMPTY_NORTHERN_STAR
		)

	sealed_levels = list()
	empty_levels = list()
	accessible_z_levels = list("1" = 5, "3" = 10, "4" = 15, "5" = 10, "6" = 60) // The defines can't be used here sadly.
	base_turf_by_z = list(
		"1" = /turf/simulated/mineral/floor,
		"4" = /turf/simulated/mineral/floor,
		"5" = /turf/simulated/mineral/floor
	)

	station_name  = "NCS Northern Star"
	station_short = "Northern Star"
	dock_name     = "Vir Interstellar Spaceport"
	boss_name     = "Central Command"
	boss_short    = "Centcomm"
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

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_ENGINEERING_OUTPOST,
							NETWORK_DEFAULT,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_NORTHERN_STAR,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_PRISON,
							NETWORK_SECURITY,
							NETWORK_INTERROGATION
							)

	allowed_spawns = list("Arrivals Shuttle","Gateway", "Cryogenic Storage", "Cyborg Storage", "Elevator")


/datum/map/northern_star/perform_map_generation()
	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_MAIN_NORTHERN_STAR, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_MAIN_NORTHERN_STAR, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_ABANDONED_ASTEROID_NORTHERN_STAR, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_ABANDONED_ASTEROID_NORTHERN_STAR, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_MINING_NORTHERN_STAR, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_MINING_NORTHERN_STAR, 64, 64)         // Create the mining ore distribution map.
	return 1