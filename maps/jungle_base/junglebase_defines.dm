//Normal map defs
#define Z_LEVEL_UNDERBRUSH_BASE				1 // The ground level. Nobody 'owns' this, and Security cannot stop you from walking out the gate if you wish.
#define Z_LEVEL_PLATFORM_CIVILIAN			2 // Our multi-building level, with walkways and such between each building! Civilian-focused, bar/dorms/tram/holodeck/etc here.
#define Z_LEVEL_PLATFORM_PRIMARY			3 // Actually the largest station level, with multiple buildings connected via walkway, but more corp-focused than the 'civvy' level.
#define Z_LEVEL_SHUTTLEPAD					4 // The shuttlepad, above the station and looking down on the canopy.
#define Z_LEVEL_UNDERMINE					5 // Despite being fifth in the list, it's underground, deep under the 'main' base.
#define Z_LEVEL_ENGINE						6 // The Z level we use for our engine (It's away from the 'main' station.)
#define Z_LEVEL_OUTPOST						7 // Xenoarchaeology, Toxins, AI Bunker, General "Research Outpost"
#define Z_LEVEL_WILDERNESS					8 // The Z level we're going to use to make "transits" feel longer and unique, as well as our 'wilderness'.
#define Z_LEVEL_MISC						9
#define Z_LEVEL_UNDERDARK					10
#define Z_LEVEL_OFFMAP1						11
#define Z_LEVEL_OFFMAP2						12
#define Z_LEVEL_ROGUEMINE_1					13
#define Z_LEVEL_ROGUEMINE_2					14
#define Z_LEVEL_ROGUEMINE_3					15
#define Z_LEVEL_ROGUEMINE_4					16
#define Z_LEVEL_BEACH						17
#define Z_LEVEL_BEACH_CAVE					18
#define Z_LEVEL_AEROSTAT					19
#define Z_LEVEL_AEROSTAT_SURFACE			20
#define Z_LEVEL_DEBRISFIELD					21
#define Z_LEVEL_GUTTERSITE					22
#define Z_LEVEL_FUELDEPOT					23
#define Z_LEVEL_GATEWAY						24 // Gateway must always be LAST.

//Camera networks
#define NETWORK_BASE "Base"
#define NETWORK_TCOMMS "Telecommunications" //Using different from Polaris one for better name
#define NETWORK_EXTERIOR "Exterior" // Harsher-sounding, given we're in a jungle.
#define NETWORK_EXPLORATION "Exploration" // Exploration's own personal network.
#define NETWORK_XENOBIO "Xenobiology" // Xenobiology-Exclusive Network

/datum/map/junglebase/New()
	..()
	var/choice = pickweight(list(
		"title" = 10,
		"tether" = 50,
		"tether_night" = 50,
		"tether2_night" = 50,
		"tether2_dog" = 1,
		"tether2_love" = 1
	))
	if(choice)
		lobby_screens = list(choice)

/datum/map/junglebase
	name = "Torris"
	full_name = "NSB Forbearance"
	path = "jungle_base"

	use_overmap = TRUE
	overmap_z = Z_LEVEL_MISC
	overmap_size = 35
	overmap_event_areas = 34
	usable_email_tlds = list("torris.nt")

	zlevel_datum_type = /datum/map_z_level/junglebase

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("tether2_night")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'

	holomap_smoosh = list(list(
		Z_LEVEL_UNDERBRUSH_BASE,
		Z_LEVEL_PLATFORM_CIVILIAN,
		Z_LEVEL_PLATFORM_PRIMARY,
		Z_LEVEL_SHUTTLEPAD))

	station_name  = "NSB Forbearance"
	station_short = "Tether"
	dock_name     = "Torris Colony"
	dock_type     = "surface"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Virgo-Erigone"

	shuttle_docked_message = "The scheduled Orange Line tram to the %dock_name% has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Orange Line tram has left the station. Estimate %ETA% until the tram arrives at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The tram will be arriving shortly. Those departing should proceed to the Orange Line tram station within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	shuttle_name = "Automated Tram"
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
							NETWORK_EXTERIOR,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_SECURITY,
							NETWORK_TCOMMS,
							NETWORK_BASE
							)
	secondary_networks = list(
							NETWORK_ERT,
							NETWORK_MERCENARY,
							NETWORK_THUNDER,
							NETWORK_COMMUNICATORS,
							NETWORK_ALARM_ATMOS,
							NETWORK_ALARM_POWER,
							NETWORK_ALARM_FIRE,
							NETWORK_TALON_HELMETS,
							NETWORK_TALON_SHIP
							)

	bot_patrolling = FALSE

	allowed_spawns = list("Tram Station","Gateway","Cryogenic Storage","Cyborg Storage","ITV Talon Cryo")
	spawnpoint_died = /datum/spawnpoint/tram
	spawnpoint_left = /datum/spawnpoint/tram
	spawnpoint_stayed = /datum/spawnpoint/cryo

	meteor_strike_areas = list(/area/junglebase/exterior/exterior3)

	default_skybox = /datum/skybox_settings/junglebase

	unit_test_exempt_areas = list(
		/area/junglebase/exterior/exterior1,
		/area/junglebase/turboshaft,
		/area/vacant/vacant_site,
		/area/crew_quarters/sleep/Dorm_1/holo,
		/area/crew_quarters/sleep/Dorm_3/holo,
		/area/crew_quarters/sleep/Dorm_5/holo,
		/area/crew_quarters/sleep/Dorm_7/holo,
		/area/looking_glass/lg_1,
		/area/rnd/miscellaneous_lab
		)

	unit_test_exempt_from_atmos = list(
		/area/engineering/atmos_intake, // Outside,
		/area/rnd/external, //  Outside,
		/area/junglebase/mining_main/external, // Outside,
		/area/junglebase/cargo,
		/area/junglebase/emergency_storage/rnd)

	lateload_z_levels = list(
		list("Misc"), //Stock lateload maps, only including overmap to start.
		list("Offmap Ship - Talon Z1","Offmap Ship - Talon Z2"),
		list("Asteroid Belt 1","Asteroid Belt 2","Asteroid Belt 3","Asteroid Belt 4"),
		list("Desert Planet - Z1 Beach","Desert Planet - Z2 Cave"),
		list("Remmi Aerostat - Z1 Aerostat","Remmi Aerostat - Z2 Surface"),
		list("Debris Field - Z1 Space"),
		list("Gutter Site - Z1 Space"),
		list("Fuel Depot - Z1 Space")
		)

	lateload_single_pick = list(
		list("Snow Outpost"),
		list("Carp Farm"),
		list("Snow Field"),
		list("Listening Post")
		)

	ai_shell_restricted = TRUE
	ai_shell_allowed_levels = list(
		Z_LEVEL_UNDERBRUSH_BASE,
		Z_LEVEL_PLATFORM_CIVILIAN,
		Z_LEVEL_PLATFORM_PRIMARY,
		Z_LEVEL_SHUTTLEPAD,
		Z_LEVEL_ENGINE,
		Z_LEVEL_MISC,
		Z_LEVEL_BEACH
		)

	belter_docked_z = 		list(Z_LEVEL_SHUTTLEPAD)
	belter_transit_z =	 	list(Z_LEVEL_MISC)
	belter_belt_z = 		list(Z_LEVEL_ROGUEMINE_1,
						 		 Z_LEVEL_ROGUEMINE_2,
						 	 	 Z_LEVEL_ROGUEMINE_3,
								 Z_LEVEL_ROGUEMINE_4)

// Commenting out mining shuttle for now, assuming you use elevator to go deep underground. :blep:
	//mining_station_z =		list(Z_LEVEL_SHUTTLEPAD)
	//mining_outpost_z =		list(Z_LEVEL_UNDERMINE)

	lateload_single_pick = null //Nothing right now.

	planet_datums_to_make = list(/datum/planet/torris)

/datum/map/junglebase/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_UNDERMINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_UNDERMINE, 64, 64)         // Create the mining ore distribution map.
	
	/* // Commenting out Solars for now, we don't have a 'solars' level.
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SOLARS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SOLARS, 64, 64)         // Create the mining ore distribution map.
	*/
	return 1

/datum/skybox_settings/junglebase
	icon_state = "space5"
	use_stars = FALSE

/datum/planet/torris
	expected_z_levels = list(
		Z_LEVEL_UNDERBRUSH_BASE,
		Z_LEVEL_PLATFORM_CIVILIAN,
		Z_LEVEL_PLATFORM_PRIMARY,
		Z_LEVEL_UNDERMINE
	)

// Overmap represetation of our base
/obj/effect/overmap/visitable/sector/torris
	name = "Torris"
	desc = "Covered in lush, dense jungles, home to hostile wildlife and the NSB Forbearance."
	scanner_desc = @{"[i]Registration[/i]: NSB Forbearance
[i]Class[/i]: Installation
[i]Transponder[/i]: Transmitting (CIV), NanoTrasen IFF
[b]Notice[/b]: NanoTrasen Base, authorized personnel only"}
	base = 1
	icon_state = "globe"
	color = "#d35b5b"
	// 12 Landing Pads on the Shuttlepad Z, arranged from Outer -> Inner.
	initial_generic_waypoints = list(
		"jungle_landing_pad_l1", // Left Far Top Pad,
		"jungle_landing_pad_l2", // Left Far Bottom Pad,
		"jungle_landing_pad_l3", // Left Mid Top Pad,
		"jungle_landing_pad_l4", // Left Mid Bottom Pad,
		"excursion_landing_pad", // Left Inner Top Pad, Excursion shuttle pad,
		"jungle_landing_pad_l6", // Left Inner Bottom Pad,
		"jungle_landing_pad_r1", // Right Far Top Pad,
		"jungle_landing_pad_r2", // Right Far Bottom Pad,
		"jungle_landing_pad_r3", // Right Mid Top Pad,
		"jungle_landing_pad_r4", // Right Mid Bottom Pad,
		"medivac_landing_pad", // Right Inner Top Pad, Medivac Landing Pad Pad,
		"tourbus_landing_pad", // Right Inner Bottom Pad, Tourbus Landing Pad,
		"junglebase_backup_pad" // Backup Pad for the Jungle backup shuttle
		)
	//Despite not being in the multi-z complex, these levels are part of the overmap sector
	extra_z_levels = list(
		Z_LEVEL_UNDERMINE,
		Z_LEVEL_ENGINE,
		//Z_LEVEL_PLAINS, // Commented out for now,
		Z_LEVEL_UNDERDARK
	)

/obj/effect/overmap/visitable/sector/torris/Crossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = FALSE)

/obj/effect/overmap/visitable/sector/torris/Uncrossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = TRUE)

/* // Commenting this out to test, Junglebase is intended to have 0 space access save shuttlepad landing.
/obj/effect/overmap/visitable/sector/torris/get_space_zlevels()
	return list(Z_LEVEL_SHUTTLEPAD)
*/
/obj/effect/overmap/visitable/sector/torris/proc/announce_atc(var/atom/movable/AM, var/going = FALSE)
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
#define JUNGLE_MAP_SIZE 200 // Width and height of compiled junglebase z levels.
#define JUNGLE_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define JUNGLE_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*JUNGLE_MAP_SIZE) - JUNGLE_HOLOMAP_CENTER_GUTTER) / 2) // 100
#define JUNGLE_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*JUNGLE_MAP_SIZE)) / 2) // 60

// We have a bunch of stuff common to the station z levels
/datum/map_z_level/junglebase/station
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_z_level/junglebase/station/underbrush
	z = Z_LEVEL_UNDERBRUSH_BASE
	name = "Jungle Floor Base"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks/torris
	holomap_offset_x = JUNGLE_HOLOMAP_MARGIN_X
	holomap_offset_y = JUNGLE_HOLOMAP_MARGIN_Y + JUNGLE_MAP_SIZE*0

/datum/map_z_level/junglebase/station/platform_civilian
	z = Z_LEVEL_PLATFORM_CIVILIAN
	name = "Civilian Platform Level"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
	holomap_offset_x = JUNGLE_HOLOMAP_MARGIN_X
	holomap_offset_y = JUNGLE_HOLOMAP_MARGIN_Y + JUNGLE_MAP_SIZE*1

/datum/map_z_level/junglebase/station/platform_primary
	z = Z_LEVEL_PLATFORM_PRIMARY
	name = "Above-Canopy Primary Platform Level"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
	holomap_offset_x = JUNGLE_HOLOMAP_MARGIN_X
	holomap_offset_y = JUNGLE_HOLOMAP_MARGIN_Y + JUNGLE_MAP_SIZE*2

/datum/map_z_level/junglebase/shuttlepad
	z = Z_LEVEL_SHUTTLEPAD
	name = "Shuttlepad"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_z_level/junglebase/mine
	z = Z_LEVEL_UNDERMINE
	name = "Underground Mining"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/floor/outdoors/rocks/torris

/datum/map_z_level/junglebase/engine
	z = Z_LEVEL_ENGINE
	name = "Engine Complex"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks/torris
