
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

	lobby_screens = list('html/lobby/mockingjay00.gif')

	zlevel_datum_type = /datum/map_z_level/northern_star

	station_name  = "NCS Northern Star"
	station_short = "Northern Star"
	dock_name     = "Vir Interstellar Spaceport"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
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

	secondary_networks = list(
							NETWORK_ERT,
							NETWORK_MERCENARY,
							NETWORK_THUNDER,
							NETWORK_COMMUNICATORS,
							NETWORK_ALARM_ATMOS,
							NETWORK_ALARM_POWER,
							NETWORK_ALARM_FIRE
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

/datum/map_z_level/northern_star/main
	z = Z_LEVEL_MAIN_NORTHERN_STAR
	name = "Main"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	transit_chance = 5
	base_turf = /turf/simulated/mineral/floor

/datum/map_z_level/northern_star/centcomm
	z = Z_LEVEL_CENTCOM_NORTHERN_STAR
	name = "CentCom"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT

/datum/map_z_level/northern_star/telecomms
	z = Z_LEVEL_TELECOMMS_NORTHERN_STAR
	name = "Telecomms"
	flags = MAP_LEVEL_PLAYER
	transit_chance = 10

/datum/map_z_level/northern_star/abandoned_asteroid
	z = Z_LEVEL_ABANDONED_ASTEROID_NORTHERN_STAR
	name = "Abandoned Asteroid"
	flags = MAP_LEVEL_PLAYER
	transit_chance = 15
	base_turf = /turf/simulated/mineral/floor

/datum/map_z_level/northern_star/mining
	z = Z_LEVEL_MINING_NORTHERN_STAR
	name = "Mining"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	transit_chance = 10
	base_turf = /turf/simulated/mineral/floor

/datum/map_z_level/northern_star/empty
	z = Z_LEVEL_EMPTY_NORTHERN_STAR
	name = "Empty"
	flags = MAP_LEVEL_PLAYER
	transit_chance = 60


//Unit test stuff.

/datum/unit_test/zas_area_test/supply_centcomm
	name = "ZAS: Supply Shuttle (CentCom)"
	area_path = /area/supply/dock

/datum/unit_test/zas_area_test/emergency_shuttle
	name = "ZAS: Emergency Shuttle"
	area_path = /area/shuttle/escape/centcom

/datum/unit_test/zas_area_test/ai_chamber
	name = "ZAS: AI Chamber"
	area_path = /area/ai

/datum/unit_test/zas_area_test/mining_shuttle_at_station
	name = "ZAS: Mining Shuttle (Station)"
	area_path = /area/shuttle/mining/station

/datum/unit_test/zas_area_test/cargo_maint
	name = "ZAS: Cargo Maintenance"
	area_path = /area/maintenance/cargo

/datum/unit_test/zas_area_test/eng_shuttle
	name = "ZAS: Construction Site Shuttle (Station)"
	area_path = /area/shuttle/constructionsite/station

/datum/unit_test/zas_area_test/virology
	name = "ZAS: Virology"
	area_path = /area/medical/virology

/datum/unit_test/zas_area_test/xenobio
	name = "ZAS: Xenobiology"
	area_path = /area/rnd/xenobiology

/datum/unit_test/zas_area_test/mining_area
	name = "ZAS: Mining Area (Vacuum)"
	area_path = /area/mine/explored
	expectation = UT_VACUUM

/datum/unit_test/zas_area_test/cargo_bay
	name = "ZAS: Cargo Bay"
	area_path = /area/quartermaster/storage
