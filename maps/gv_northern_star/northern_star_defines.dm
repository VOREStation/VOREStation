
#define Z_LEVEL_MAIN_NORTHERN_STAR					1
#define Z_LEVEL_CENTCOM_NORTHERN_STAR				2
#define Z_LEVEL_TELECOMMS_NORTHERN_STAR				3
#define Z_LEVEL_ABANDONED_ASTEROID_NORTHERN_STAR	4
#define Z_LEVEL_MINING_NORTHERN_STAR				5
#define Z_LEVEL_EMPTY_NORTHERN_STAR					6
#define Z_LEVEL_MISC								7
#define Z_LEVEL_ROGUEMINE_1							8
#define Z_LEVEL_ROGUEMINE_2							9
#define Z_LEVEL_ROGUEMINE_3							10
#define Z_LEVEL_ROGUEMINE_4							11
#define Z_LEVEL_BEACH								12
#define Z_LEVEL_BEACH_CAVE							13
#define Z_LEVEL_AEROSTAT							14
#define Z_LEVEL_AEROSTAT_SURFACE					15
#define Z_LEVEL_DEBRISFIELD							16
#define Z_LEVEL_GUTTERSITE							17
#define Z_LEVEL_FUELDEPOT							18
#define Z_LEVEL_GATEWAY								19


/datum/map/northern_star
	name = "Northern Star"
	full_name = "NCS Northern Star"
	path = "gv_northern_star"

	lobby_icon = 'icons/misc/title.dmi'
	lobby_screens = list("mockingjay00")


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

/datum/skybox_settings/tether
	icon_state = "space5"
	use_stars = FALSE

/datum/planet/northern_star
	expected_z_levels = list(
		Z_LEVEL_CENTCOM_NORTHERN_STAR,
		Z_LEVEL_TELECOMMS_NORTHERN_STAR,
		Z_LEVEL_ABANDONED_ASTEROID_NORTHERN_STAR,
		Z_LEVEL_MINING_NORTHERN_STAR,
		Z_LEVEL_EMPTY_NORTHERN_STAR,
		Z_LEVEL_MISC
	)

// Overmap represetation of tether
/obj/effect/overmap/visitable/sector/northern_star
	name = "Northern Star"
	desc = "Full of phoron, and home to the NSB Northern Star, where you can dock and refuel your craft."
	scanner_desc = @{"[i]Registration[/i]: NSB Northern Star
[i]Class[/i]: Installation
[i]Transponder[/i]: Transmitting (CIV), NanoTrasen IFF
[b]Notice[/b]: NanoTrasen Base, authorized personnel only"}
	base = 1
	icon_state = "globe"
	color = "#d35b5b"
	initial_generic_waypoints = list(
//		"tether_dockarm_d1a1", //Bottom left,
//		"tether_dockarm_d1a2", //Top left,
//		"tether_dockarm_d1a3", //Left on inside,
//		"tether_dockarm_d2a1", //Bottom right,
//		"tether_dockarm_d2a2", //Top right,
//		"tether_dockarm_d1l", //End of left arm,
//		"tether_dockarm_d2l", //End of right arm,
//		"tether_space_SE", //station1, bottom right of space,
//		"tether_space_NE", //station1, top right of space,
//		"tether_space_SW", //station3, bottom left of space,
//		"tether_excursion_hangar", //Excursion shuttle hangar,
//		"tether_medivac_dock", //Medical shuttle dock,
//		"tourbus_dock" //Surface large hangar
		)

	extra_z_levels = list(
//		Z_LEVEL_SURFACE_MINE,
//		Z_LEVEL_SOLARS,
//		Z_LEVEL_PLAINS,
//		Z_LEVEL_UNDERDARK
	)

/obj/effect/overmap/visitable/sector/northern_star/Crossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = FALSE)

/obj/effect/overmap/visitable/sector/northern_star/Uncrossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = TRUE)

/obj/effect/overmap/visitable/sector/northern_cross/get_space_zlevels()
	return list(Z_LEVEL_CENTCOM_NORTHERN_STAR, Z_LEVEL_MINING_NORTHERN_STAR, Z_LEVEL_EMPTY_NORTHERN_STAR)

/obj/effect/overmap/visitable/sector/northern_star/proc/announce_atc(var/atom/movable/AM, var/going = FALSE)
	var/message = "Sensor contact for vessel '[AM.name]' has [going ? "left" : "entered"] ATC control area."
	//For landables, we need to see if their shuttle is cloaked
	if(istype(AM, /obj/effect/overmap/visitable/ship/landable))
		var/obj/effect/overmap/visitable/ship/landable/SL = AM //Phew
		var/datum/shuttle/autodock/multi/shuttle = SSshuttles.shuttles[SL.shuttle]
		if(!istype(shuttle) || !shuttle.cloaked) //Not a multishuttle (the only kind that can cloak) or not cloaked
			atc.msg(message)

	//For ships, it's safe to assume they're big enough to not be sneaky
	else if(istype(AM, /obj/effect/overmap/visitable/ship))
		atc.msg(message)

// For making the 6-in-1 holomap, we calculate some offsets
#define NORTHERN_STAR_MAP_SIZE 140 // Width and height of compiled in tether z levels.
#define NORTHERN_STAR_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define NORTHERN_STAR_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*NORTHERN_STAR_MAP_SIZE) - NORTHERN_STAR_HOLOMAP_CENTER_GUTTER) / 2) // 100
#define NORTHERN_STAR_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*NORTHERN_STAR_MAP_SIZE)) / 2) // 60

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